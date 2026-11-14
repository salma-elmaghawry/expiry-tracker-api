using System.Globalization;
using System.Text.Json;
using System.Text.Json.Serialization;
using ExpiryTracker.Api.Services;
using ExpiryTracker.Api.Models;

namespace ExpiryTracker.Api.Dtos;

// What is printed inside the carton QR label (version 1).
// Only our server makes these: "sig" proves the label came from us (see LabelSigner).
// The QR uses short keys to stay small; [JsonPropertyName] maps them to clear names
// (same idea as @JsonKey(name: 'mfg') in Dart's json_serializable).
//
// Example QR text:
// {"v":1,"id":"7f3a9c2e-...","barcode":"6221234567890","name":"Chocolate biscuit","category":"Snacks",
//  "boxes":12,"perBox":10,"lot":"L-2611-A","mfg":"2026-11-01","exp":"2027-05-01","cost":40000,"sig":"q3V..."}
public record CartonQr(
    [property: JsonPropertyName("v")] int Version,
    [property: JsonPropertyName("id")] string CartonCode,
    [property: JsonPropertyName("barcode")] string Barcode,
    [property: JsonPropertyName("name")] string Name,
    [property: JsonPropertyName("category")] Category Category,
    [property: JsonPropertyName("boxes")] int BoxesCount,
    [property: JsonPropertyName("perBox")] int PiecesPerBox,
    [property: JsonPropertyName("lot")] string LotNumber,
    [property: JsonPropertyName("mfg")] DateOnly ProductionDate,
    [property: JsonPropertyName("exp")] DateOnly ExpiryDate,
    [property: JsonPropertyName("cost")] long CostPiasters, // whole carton, in piasters
    [property: JsonPropertyName("sig")] string Signature)
{
    private static readonly JsonSerializerOptions Options = new()
    {
        PropertyNameCaseInsensitive = true,
        Converters = { new JsonStringEnumConverter(allowIntegerValues: false) }, // "Snacks", not 6
        RespectRequiredConstructorParameters = true, // a missing key means it is not our label
        RespectNullableAnnotations = true,
    };

    // Parse + check the signature + validate, used by both scan and preview.
    // Returns the label, or the errors to send back as 400 (then Qr is null).
    // The (A, B) return type is a tuple, like a Dart 3 record: (CartonQr?, Map<String, List<String>>).
    public static (CartonQr? Qr, Dictionary<string, string[]> Errors) Read(string text, LabelSigner signer)
    {
        var qr = TryParse(text);
        // No signature, or a wrong one (fake label, or someone edited the expiry date):
        // same answer as a random QR.
        if (qr is null || !signer.IsValid(qr))
            return (null, new Dictionary<string, string[]>
            {
                ["qrText"] = ["This QR is not an Expiry Tracker carton label."]
            });

        var errors = qr.Validate();
        return (errors.Count > 0 ? null : qr, errors);
    }

    // Like int.tryParse in Dart: returns null instead of throwing
    // when the text is not a carton label (a website link, a broken QR, ...).
    public static CartonQr? TryParse(string text)
    {
        try
        {
            return JsonSerializer.Deserialize<CartonQr>(text, Options);
        }
        catch (JsonException)
        {
            return null;
        }
    }

    // The exact text that gets signed: every field except the signature, in a fixed order.
    // Built by hand (not by serializing JSON) so key order or spaces in the QR can't change it.
    // InvariantCulture: dates and numbers are written the same way on every computer.
    public string SignedText() => string.Join('|',
        Version.ToString(CultureInfo.InvariantCulture),
        CartonCode,
        Barcode,
        Name,
        Category.ToString(),
        BoxesCount.ToString(CultureInfo.InvariantCulture),
        PiecesPerBox.ToString(CultureInfo.InvariantCulture),
        LotNumber,
        ProductionDate.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture),
        ExpiryDate.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture),
        CostPiasters.ToString(CultureInfo.InvariantCulture));

    // The text to put inside the printed QR (compact JSON with the short keys).
    public string ToQrText() => JsonSerializer.Serialize(this, Options);

    // Business rules. Keys match the QR keys so the factory can see which field is wrong.
    public Dictionary<string, string[]> Validate()
    {
        var errors = new Dictionary<string, string[]>();

        if (Version != 1)
            errors["v"] = ["Unsupported label version."];

        if (string.IsNullOrWhiteSpace(CartonCode))
            errors["id"] = ["Carton id is required."];

        if (string.IsNullOrWhiteSpace(Barcode) || !Barcode.All(char.IsAsciiDigit))
            errors["barcode"] = ["Barcode must contain digits only."];

        if (string.IsNullOrWhiteSpace(Name))
            errors["name"] = ["Product name is required."];

        if (BoxesCount <= 0)
            errors["boxes"] = ["Boxes per carton must be greater than 0."];

        if (PiecesPerBox <= 0)
            errors["perBox"] = ["Pieces per box must be greater than 0."];

        if (string.IsNullOrWhiteSpace(LotNumber))
            errors["lot"] = ["Lot number is required."];

        if (ExpiryDate <= ProductionDate)
            errors["exp"] = ["Expiry date must be after the production date."];

        if (CostPiasters <= 0)
            errors["cost"] = ["Carton cost must be greater than 0."];

        return errors;
    }
}
