using ExpiryTracker.Api.Data;
using ExpiryTracker.Api.Dtos;
using ExpiryTracker.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace ExpiryTracker.Api.Services;

public class DashboardService(AppDbContext db)
{
    private enum Bucket { Expired, Within3Days, Within4To7Days }

    public async Task<DashboardResponse> GetAsync()
    {
        // The server runs on the supermarket's own PC, so local time = Cairo time.
        var today = DateOnly.FromDateTime(DateTime.Now);
        var in3Days = today.AddDays(3);
        var in7Days = today.AddDays(7);

        // One SQL query: filter, put each batch in a bucket, then count and sum per bucket.
        var groups = await db.Batches
            .Where(b => (b.Status == BatchStatus.Active || b.Status == BatchStatus.Discounted)
                        && b.ExpiryDate <= in7Days)
            .GroupBy(b => b.ExpiryDate < today ? Bucket.Expired
                        : b.ExpiryDate <= in3Days ? Bucket.Within3Days
                        : Bucket.Within4To7Days)
            .Select(g => new
            {
                Bucket = g.Key,
                Count = g.Count(),
                // Value at risk = what the store paid. If it gets thrown away, this is the loss.
                Value = g.Sum(b => b.Quantity * b.CostPricePiasters)
            })
            .ToListAsync();

        // A bucket with no batches does not come back from SQL at all, so default it to zero.
        DashboardBucket For(Bucket bucket)
        {
            var group = groups.FirstOrDefault(g => g.Bucket == bucket);
            return group is null
                ? new DashboardBucket(0, 0)
                : new DashboardBucket(group.Count, group.Value);
        }

        return new DashboardResponse(
            today,
            For(Bucket.Expired),
            For(Bucket.Within3Days),
            For(Bucket.Within4To7Days));
    }
}
