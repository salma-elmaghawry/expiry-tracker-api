using ExpiryTracker.Api.Data;
using ExpiryTracker.Api.Dtos;
using ExpiryTracker.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace ExpiryTracker.Api.Services;

public class CartonService(AppDbContext db)
{
    // Reads what a label means for this store WITHOUT saving anything.
    public async Task<CartonPreviewResponse> PreviewAsync(CartonQr qr)
    {
        var receivedAt = await GetReceivedAtAsync(qr.CartonCode);

        // Only the columns we need, not the whole product row.
        var product = await db.Products
            .Where(p => p.Barcode == qr.Barcode)
            .Select(p => new { p.Name, p.Category, p.SellingPricePiasters })
            .FirstOrDefaultAsync();

        return new CartonPreviewResponse(
            qr.CartonCode,
            qr.Barcode,
            product?.Name ?? qr.Name.Trim(),   // a known product keeps the name we saved
            product?.Category ?? qr.Category,
            qr.LotNumber,
            qr.ProductionDate,
            qr.ExpiryDate,
            qr.BoxesCount,
            qr.PiecesPerBox,
            qr.BoxesCount * qr.PiecesPerBox,
            qr.CostPiasters,
            NeedsSellingPrice: product?.SellingPricePiasters is null,
            SellingPricePiasters: product?.SellingPricePiasters,
            AlreadyReceivedAt: receivedAt);
    }

    // Registers a scanned carton. The QR was already parsed and validated by the endpoint.
    public async Task<ScanOutcome> ReceiveAsync(CartonQr qr, long? sellingPricePiasters)
    {
        // 1. Same carton scanned before? Answer with a friendly 409.
        //    (The unique index on CartonCode is the safety net if this check is ever skipped.)
        var receivedAt = await GetReceivedAtAsync(qr.CartonCode);

        if (receivedAt is not null)
            return new ScanOutcome(ScanStatus.AlreadyReceived, ReceivedAt: receivedAt);

        // 2. Find the product by barcode, or create it the first time we see it.
        var product = await db.Products.FirstOrDefaultAsync(p => p.Barcode == qr.Barcode);

        if (product is null)
        {
            if (sellingPricePiasters is null)
                return new ScanOutcome(ScanStatus.SellingPriceRequired);

            product = new Product
            {
                Barcode = qr.Barcode,
                Name = qr.Name.Trim(),
                Category = qr.Category,
                SellingPricePiasters = sellingPricePiasters,
            };
            db.Products.Add(product);
        }
        else if (product.SellingPricePiasters is null)
        {
            // Known product that still has no price: ask for it now.
            if (sellingPricePiasters is null)
                return new ScanOutcome(ScanStatus.SellingPriceRequired);

            product.SellingPricePiasters = sellingPricePiasters;
        }

        // 3. The carton itself. All pieces are on the shelf when it arrives.
        var totalPieces = qr.BoxesCount * qr.PiecesPerBox;

        var carton = new Carton
        {
            CartonCode = qr.CartonCode.Trim(),
            Product = product, // EF inserts a new product first, then uses its Id here
            LotNumber = qr.LotNumber.Trim(),
            ProductionDate = qr.ProductionDate,
            ExpiryDate = qr.ExpiryDate,
            BoxesCount = qr.BoxesCount,
            PiecesPerBox = qr.PiecesPerBox,
            TotalPieces = totalPieces,
            RemainingPieces = totalPieces,
            CostPiasters = qr.CostPiasters,
        };
        db.Cartons.Add(carton);

        // One SaveChanges = one transaction: product and carton are saved together or not at all
        // (like a WriteBatch in Firestore).
        await db.SaveChangesAsync();

        return new ScanOutcome(ScanStatus.Ok, CartonResponse.FromEntity(carton));
    }

    // When this carton was scanned, or null if it never was.
    private Task<DateTime?> GetReceivedAtAsync(string cartonCode) =>
        db.Cartons
            .Where(c => c.CartonCode == cartonCode)
            .Select(c => (DateTime?)c.ScannedAt)
            .FirstOrDefaultAsync();
}
