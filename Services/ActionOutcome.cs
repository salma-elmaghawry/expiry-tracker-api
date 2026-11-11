using ExpiryTracker.Api.Dtos;

namespace ExpiryTracker.Api.Services;

// Every way an action can end. The service decides which one happened,
// and the endpoint turns it into an HTTP status code.
public enum ActionStatus
{
    Ok,
    NotFound,
    AlreadyClosed,     // batch is already Sold or Wasted
    DiscountNotLower   // discount price is not lower than the selling price
}

public record ActionOutcome(ActionStatus Status, BatchResponse? Batch = null);
