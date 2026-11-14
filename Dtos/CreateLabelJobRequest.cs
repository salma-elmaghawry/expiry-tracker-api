using ExpiryTracker.Api.Models;

namespace ExpiryTracker.Api.Dtos;

// What the factory "Create carton labels" form sends.
public record CreateLabelJobRequest(
    string ProductName,
    string Barcode,
    Category Category,
    int BoxesCount,
    int PiecesPerBox,
    string LotNumber,
    DateOnly ProductionDate,
    DateOnly ExpiryDate,
    long CostPiasters,  // whole carton
    int CartonCount)
{
    public const int MaxCartons = 1000;

    // Same rules as the form, checked again here because the server never trusts the client.
    // Keys are the JSON field names, so Flutter can show each error under its field.
    public Dictionary<string, string[]> Validate()
    {
        var errors = new Dictionary<string, string[]>();

        if (string.IsNullOrWhiteSpace(ProductName))
            errors["productName"] = ["Product name is required."];

        if (string.IsNullOrWhiteSpace(Barcode) || !Barcode.Trim().All(char.IsAsciiDigit))
            errors["barcode"] = ["Barcode must contain digits only."];

        if (BoxesCount <= 0)
            errors["boxesCount"] = ["Boxes per carton must be greater than 0."];

        if (PiecesPerBox <= 0)
            errors["piecesPerBox"] = ["Pieces per box must be greater than 0."];

        if (string.IsNullOrWhiteSpace(LotNumber) || !LotNumber.Any(char.IsAsciiLetterOrDigit))
            errors["lotNumber"] = ["Lot number must contain letters or digits."];

        if (ExpiryDate <= ProductionDate)
            errors["expiryDate"] = ["Expiry date must be after the production date."];

        if (CostPiasters <= 0)
            errors["costPiasters"] = ["Carton cost must be greater than 0."];

        if (CartonCount is <= 0 or > MaxCartons)
            errors["cartonCount"] = [$"Number of cartons must be between 1 and {MaxCartons}."];

        return errors;
    }
}
