namespace ExpiryTracker.Api.Models;

// One carton from the factory. Everything here comes from its QR label, except ScannedAt.
// Example: 12 boxes x 10 pieces = 120 pieces, all the same product, lot and expiry date.
public class Carton
{
    public int Id { get; set; }

    // The unique id inside the QR. Scanning the same carton twice is rejected using this.
    public required string CartonCode { get; set; }

    // Foreign key + navigation to the product (many cartons -> one product).
    public int ProductId { get; set; }
    public Product Product { get; set; } = null!; // EF fills it when we load it with Include()

    public required string LotNumber { get; set; }
    public DateOnly ProductionDate { get; set; }
    public DateOnly ExpiryDate { get; set; }

    public int BoxesCount { get; set; }      // boxes in the carton (12)
    public int PiecesPerBox { get; set; }    // pieces in each box (10)
    public int TotalPieces { get; set; }     // BoxesCount x PiecesPerBox (120), saved once at scan time
    public int RemainingPieces { get; set; } // goes down with every sale or waste

    // What the store paid for the WHOLE carton, in piasters (set by the factory inside the QR).
    // Kept per carton, not per piece, to avoid rounding: 400 EGP / 120 = 3.333...
    public long CostPiasters { get; set; }

    // Discounted price of ONE piece, if the store lowered the price to sell it before expiry.
    public long? DiscountPricePiasters { get; set; }

    public DateTime ScannedAt { get; set; } = DateTime.UtcNow;

    // Navigation: the history of this carton (sales and waste).
    public List<StockMovement> Movements { get; set; } = [];
}
