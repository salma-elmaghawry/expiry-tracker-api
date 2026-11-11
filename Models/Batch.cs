namespace ExpiryTracker.Api.Models;

// One batch = a quantity of the same product that shares the same expiry date.
public class Batch
{
    public int Id { get; set; }

    public required string ProductName { get; set; }
    public string? Barcode { get; set; }
    public Category Category { get; set; }

    public int Quantity { get; set; }

    // Money is stored in piasters (1 EGP = 100 piasters). 35.50 EGP => 3550
    public long CostPricePiasters { get; set; } // what the store paid the supplier (losses use this)
    public long UnitPricePiasters { get; set; } // what the customer pays
    public long? DiscountPricePiasters { get; set; }

    public DateOnly ExpiryDate { get; set; }

    public BatchStatus Status { get; set; } = BatchStatus.Active;
    public WasteReason? WasteReason { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime? ActionAt { get; set; } // when it was last sold / discounted / wasted
}
