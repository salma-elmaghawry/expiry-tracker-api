using ExpiryTracker.Api.Models;

namespace ExpiryTracker.Api.Dtos;

// One printed label: the id written under the QR, and the exact text to encode in the QR.
public record LabelResponse(string CartonCode, string QrText);

// A label job with all its labels, ready for the print preview page.
public record LabelJobResponse(
    int Id,
    string ProductName,
    string Barcode,
    Category Category,
    int BoxesCount,
    int PiecesPerBox,
    int PiecesPerCarton,
    string LotNumber,
    DateOnly ProductionDate,
    DateOnly ExpiryDate,
    long CostPiasters,
    int CartonCount,
    DateTime CreatedAt,
    List<LabelResponse> Labels);
