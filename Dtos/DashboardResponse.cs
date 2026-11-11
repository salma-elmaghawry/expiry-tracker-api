namespace ExpiryTracker.Api.Dtos;

// One card on the dashboard: how many batches, and how much money is at risk.
public record DashboardBucket(int BatchCount, long ValuePiasters);

// The three buckets never overlap, so a batch is counted in exactly one of them.
public record DashboardResponse(
    DateOnly Today,
    DashboardBucket Expired,         // expiry date is before today
    DashboardBucket Within3Days,     // expires today .. today + 3
    DashboardBucket Within4To7Days); // expires today + 4 .. today + 7
