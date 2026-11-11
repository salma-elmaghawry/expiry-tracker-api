namespace ExpiryTracker.Api.Dtos;

// What the user did with the batch. Lives in Dtos because it is never stored:
// the action changes the batch's Status, and Status is what we save.
public enum BatchAction
{
    Sell,
    Discount,
    Waste
}
