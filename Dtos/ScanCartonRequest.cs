namespace ExpiryTracker.Api.Dtos;

// What Flutter sends after scanning a carton.
// QrText is the raw text the camera (or a USB scanner) read; the server parses it.
// SellingPricePiasters is the price of ONE piece, needed only the first time we see a product.
public record ScanCartonRequest(string QrText, long? SellingPricePiasters = null);
