namespace ExpiryTracker.Api.Dtos;

// The three dashboard cards. Shared by the dashboard and the batches list filter,
// so tapping a card always lists exactly the batches that card counted.
public enum ExpiryBucket
{
    Expired,          // expiry date is before today
    Within3Days,      // today .. today + 3
    Within4To7Days    // today + 4 .. today + 7
}
