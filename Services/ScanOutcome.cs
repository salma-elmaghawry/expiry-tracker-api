using ExpiryTracker.Api.Dtos;

namespace ExpiryTracker.Api.Services;

// Every way receiving a carton can end. The service decides which one happened,
// and the endpoint turns it into an HTTP status code (same pattern as ActionOutcome).
public enum ScanStatus
{
    Ok,
    AlreadyReceived,      // this carton id was scanned before
    SellingPriceRequired  // first carton of a new product, and no selling price was sent
}

public record ScanOutcome(ScanStatus Status, CartonResponse? Carton = null, DateTime? ReceivedAt = null);
