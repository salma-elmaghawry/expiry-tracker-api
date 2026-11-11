using ExpiryTracker.Api.Data;
using ExpiryTracker.Api.Dtos;
using ExpiryTracker.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace ExpiryTracker.Api.Services;

public class ReportService(AppDbContext db)
{
    // monthStart is always the 1st of the month, e.g. 2026-11-01
    public async Task<LossesReportResponse> GetLossesAsync(DateOnly monthStart)
    {
        // The month is a Cairo month, but ActionAt is saved in UTC.
        // So we turn "Nov 1, 00:00 Cairo" and "Dec 1, 00:00 Cairo" into UTC before comparing.
        var fromUtc = monthStart.ToDateTime(TimeOnly.MinValue, DateTimeKind.Local).ToUniversalTime();
        var toUtc = monthStart.AddMonths(1).ToDateTime(TimeOnly.MinValue, DateTimeKind.Local).ToUniversalTime();

        // Wasted is a final status, so ActionAt on a wasted batch is the moment it was thrown away.
        var groups = await db.Batches
            .Where(b => b.Status == BatchStatus.Wasted && b.ActionAt >= fromUtc && b.ActionAt < toUtc)
            .GroupBy(b => b.Category)
            .Select(g => new
            {
                Category = g.Key,
                Count = g.Count(),
                Value = g.Sum(b => b.Quantity * b.CostPricePiasters) // loss = what the store paid
            })
            .OrderByDescending(x => x.Value)
            .ToListAsync();

        var categories = groups
            .Select(g => new CategoryLoss(g.Category, g.Count, g.Value))
            .ToList();

        return new LossesReportResponse(
            monthStart.ToString("yyyy-MM"),
            categories.Sum(c => c.BatchCount),
            categories.Sum(c => c.ValuePiasters),
            categories);
    }
}
