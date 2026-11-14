namespace ExpiryTracker.Api.Models;

// One change in a carton's stock, like a line in a bank statement.
// Carton.RemainingPieces is the balance; these rows explain how it got there.
public class StockMovement
{
    public int Id { get; set; }

    // Foreign key + navigation to the carton (many movements -> one carton).
    public int CartonId { get; set; }
    public Carton Carton { get; set; } = null!;

    public MovementType Type { get; set; }
    public int Quantity { get; set; } // in pieces, always positive

    public WasteReason? WasteReason { get; set; } // only for Waste

    // Receipt number from the cashier system, only for Sale.
    // Lets us ignore the same sale if it arrives twice (idempotency).
    public string? ReceiptNumber { get; set; }

    public DateTime At { get; set; } = DateTime.UtcNow;
}
