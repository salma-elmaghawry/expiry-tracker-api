using ExpiryTracker.Api.Data;
using ExpiryTracker.Api.Dtos;
using ExpiryTracker.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace ExpiryTracker.Api.Services;

// Factory side: turns the "Create carton labels" form into signed, unique carton labels.
public class LabelService(AppDbContext db, LabelSigner signer)
{
    public async Task<LabelJobResponse> CreateJobAsync(CreateLabelJobRequest request)
    {
        var lot = request.LotNumber.Trim();
        var prefix = CodePrefixFor(lot);

        // Where did the last job of this lot stop? Start right after it.
        // Max() on an empty table throws, so (int?) turns "no rows" into null.
        var lastUsed = await db.LabelJobs
            .Where(j => j.CodePrefix == prefix)
            .MaxAsync(j => (int?)(j.FirstSequence + j.CartonCount - 1)) ?? 0;

        var job = new LabelJob
        {
            ProductName = request.ProductName.Trim(),
            Barcode = request.Barcode.Trim(),
            Category = request.Category,
            BoxesCount = request.BoxesCount,
            PiecesPerBox = request.PiecesPerBox,
            LotNumber = lot,
            ProductionDate = request.ProductionDate,
            ExpiryDate = request.ExpiryDate,
            CostPiasters = request.CostPiasters,
            CodePrefix = prefix,
            FirstSequence = lastUsed + 1,
            CartonCount = request.CartonCount,
        };

        db.LabelJobs.Add(job);
        await db.SaveChangesAsync();

        return ToResponse(job);
    }

    public async Task<LabelJobResponse?> GetJobAsync(int id)
    {
        var job = await db.LabelJobs.FindAsync(id);
        return job is null ? null : ToResponse(job);
    }

    // "ED-2611-07" -> "CT-ED261107". Letters and digits only, so the id is easy to read and type.
    private static string CodePrefixFor(string lot)
    {
        var clean = new string(lot.Where(char.IsAsciiLetterOrDigit).ToArray()).ToUpperInvariant();
        return "CT-" + (clean.Length > 12 ? clean[..12] : clean);
    }

    // Rebuilds every label of the job. Same job -> same ids and same signatures every time,
    // so printing again (a jammed printer) gives identical labels, not new cartons.
    private LabelJobResponse ToResponse(LabelJob job)
    {
        var labels = Enumerable.Range(job.FirstSequence, job.CartonCount)
            .Select(sequence =>
            {
                // D4 = at least 4 digits with leading zeros: 1 -> "0001" (like padLeft(4, '0')).
                var cartonCode = $"{job.CodePrefix}-{sequence:D4}";

                var qr = new CartonQr(
                    Version: 1,
                    CartonCode: cartonCode,
                    Barcode: job.Barcode,
                    Name: job.ProductName,
                    Category: job.Category,
                    BoxesCount: job.BoxesCount,
                    PiecesPerBox: job.PiecesPerBox,
                    LotNumber: job.LotNumber,
                    ProductionDate: job.ProductionDate,
                    ExpiryDate: job.ExpiryDate,
                    CostPiasters: job.CostPiasters,
                    Signature: "");

                // "with" copies a record and changes one field, like copyWith() in Dart.
                var signed = qr with { Signature = signer.Sign(qr) };
                return new LabelResponse(cartonCode, signed.ToQrText());
            })
            .ToList();

        return new LabelJobResponse(
            job.Id,
            job.ProductName,
            job.Barcode,
            job.Category,
            job.BoxesCount,
            job.PiecesPerBox,
            job.BoxesCount * job.PiecesPerBox,
            job.LotNumber,
            job.ProductionDate,
            job.ExpiryDate,
            job.CostPiasters,
            job.CartonCount,
            job.CreatedAt,
            labels);
    }
}
