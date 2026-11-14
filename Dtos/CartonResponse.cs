using ExpiryTracker.Api.Models;

namespace ExpiryTracker.Api.Dtos;

// What the API sends back to Flutter for one carton (product info included, so no second request).
public record CartonResponse(
    int Id,
    string CartonCode,
    int ProductId,
    string ProductName,
    string Barcode,
    Category Category,
    string LotNumber,
    DateOnly ProductionDate,
    DateOnly ExpiryDate,
    int BoxesCount,
    int PiecesPerBox,
    int TotalPieces,
    int RemainingPieces,
    long CostPiasters,
    long? SellingPricePiasters,
    long? DiscountPricePiasters,
    DateTime ScannedAt)
{
    // carton.Product must be loaded (Include) or set before calling this.
    public static CartonResponse FromEntity(Carton carton) => new(
        carton.Id,
        carton.CartonCode,
        carton.ProductId,
        carton.Product.Name,
        carton.Product.Barcode,
        carton.Product.Category,
        carton.LotNumber,
        carton.ProductionDate,
        carton.ExpiryDate,
        carton.BoxesCount,
        carton.PiecesPerBox,
        carton.TotalPieces,
        carton.RemainingPieces,
        carton.CostPiasters,
        carton.Product.SellingPricePiasters,
        carton.DiscountPricePiasters,
        carton.ScannedAt);
}
