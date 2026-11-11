using ExpiryTracker.Api.Models;

namespace ExpiryTracker.Api.Dtos;

// Sell:     { "action": "Sell" }
// Discount: { "action": "Discount", "discountPricePiasters": 2800 }
// Waste:    { "action": "Waste", "wasteReason": "Expired" }
public record BatchActionRequest(
    BatchAction Action,
    long? DiscountPricePiasters = null,
    WasteReason? WasteReason = null)
{
    // Rules we can check without loading the batch from the database.
    public Dictionary<string, string[]> Validate()
    {
        var errors = new Dictionary<string, string[]>();

        if (Action == BatchAction.Discount && (DiscountPricePiasters is null || DiscountPricePiasters <= 0))
            errors["discountPricePiasters"] = ["Discount price is required and must be greater than 0."];

        if (Action == BatchAction.Waste && WasteReason is null)
            errors["wasteReason"] = ["Waste reason is required."];

        return errors;
    }
}
