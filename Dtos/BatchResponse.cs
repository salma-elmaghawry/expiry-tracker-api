using ExpiryTracker.Api.Models;

namespace ExpiryTracker.Api.Dtos;

// What the API sends back to Flutter.
public record BatchResponse(
    int Id,
    string ProductName,
    string? Barcode,
    Category Category,
    int Quantity,
    long CostPricePiasters,
    long UnitPricePiasters,
    long? DiscountPricePiasters,
    DateOnly ExpiryDate,
    BatchStatus Status,
    WasteReason? WasteReason,
    DateTime CreatedAt,
    DateTime? ActionAt)
{
    public static BatchResponse FromEntity(Batch batch) => new(
        batch.Id,
        batch.ProductName,
        batch.Barcode,
        batch.Category,
        batch.Quantity,
        batch.CostPricePiasters,
        batch.UnitPricePiasters,
        batch.DiscountPricePiasters,
        batch.ExpiryDate,
        batch.Status,
        batch.WasteReason,
        batch.CreatedAt,
        batch.ActionAt);
}
