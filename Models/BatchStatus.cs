namespace ExpiryTracker.Api.Models;

public enum BatchStatus
{
    Active,      // on the shelf, nothing done yet
    Discounted,  // price reduced to sell it before expiry (still on the shelf)
    Sold,        // closed: sold
    Wasted       // closed: thrown away (this is the loss)
}
