using ExpiryTracker.Api.Models;

namespace ExpiryTracker.Api.Dtos;

// What Flutter sends when adding a new batch.
// No Id, Status, or CreatedAt here: the server decides those, not the client.
public record CreateBatchRequest(
    string ProductName,
    Category Category,
    int Quantity,
    long CostPricePiasters,
    long UnitPricePiasters,
    DateOnly ExpiryDate,
    string? Barcode = null)
{
    // Business rules. Keys are camelCase to match the JSON field names Flutter sees.
    public Dictionary<string, string[]> Validate()
    {
        var errors = new Dictionary<string, string[]>();

        if (string.IsNullOrWhiteSpace(ProductName))
            errors["productName"] = ["Product name is required."];

        if (Quantity <= 0)
            errors["quantity"] = ["Quantity must be greater than 0."];

        if (CostPricePiasters <= 0)
            errors["costPricePiasters"] = ["Cost price must be greater than 0."];

        if (UnitPricePiasters <= 0)
            errors["unitPricePiasters"] = ["Selling price must be greater than 0."];

        return errors;
    }
}
