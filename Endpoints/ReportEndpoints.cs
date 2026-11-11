using System.Globalization;
using ExpiryTracker.Api.Dtos;
using ExpiryTracker.Api.Services;
using Microsoft.AspNetCore.Http.HttpResults;

namespace ExpiryTracker.Api.Endpoints;

public static class ReportEndpoints
{
    public static void MapReportEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/api/reports").WithTags("Reports");

        group.MapGet("/losses", GetLosses);
    }

    // GET /api/reports/losses?month=2026-11
    // GET /api/reports/losses            => current month
    private static async Task<Results<Ok<LossesReportResponse>, ValidationProblem>> GetLosses(
        string? month,
        ReportService service)
    {
        DateOnly monthStart;

        if (month is null)
        {
            var today = DateOnly.FromDateTime(DateTime.Now);
            monthStart = new DateOnly(today.Year, today.Month, 1);
        }
        else if (!DateOnly.TryParseExact(month, "yyyy-MM", CultureInfo.InvariantCulture, DateTimeStyles.None, out monthStart))
        {
            return TypedResults.ValidationProblem(new Dictionary<string, string[]>
            {
                ["month"] = ["Month must look like 2026-11."]
            });
        }

        var report = await service.GetLossesAsync(monthStart);
        return TypedResults.Ok(report);
    }
}
