using ExpiryTracker.Api.Models;

namespace ExpiryTracker.Api.Dtos;

// What the scan result screen shows BEFORE anything is saved.
public record CartonPreviewResponse(
    string CartonCode,
    string Barcode,
    string ProductName,
    Category Category,
    string LotNumber,
    DateOnly ProductionDate,
    DateOnly ExpiryDate,
    int BoxesCount,
    int PiecesPerBox,
    int TotalPieces,
    long CostPiasters,              // whole carton
    bool NeedsSellingPrice,         // true: show the "selling price per piece" field
    long? SellingPricePiasters,     // the saved price, when the product is already known
    DateTime? AlreadyReceivedAt);   // not null: show "this carton was already received on ..."
