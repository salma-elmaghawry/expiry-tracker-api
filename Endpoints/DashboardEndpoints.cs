using ExpiryTracker.Api.Dtos;
using ExpiryTracker.Api.Services;
using Microsoft.AspNetCore.Http.HttpResults;

namespace ExpiryTracker.Api.Endpoints;

public static class DashboardEndpoints
{
    public static void MapDashboardEndpoints(this IEndpointRouteBuilder app)
    {
        app.MapGet("/api/dashboard", GetDashboard).WithTags("Dashboard");
    }

    private static async Task<Ok<DashboardResponse>> GetDashboard(DashboardService service)
    {
        var dashboard = await service.GetAsync();
        return TypedResults.Ok(dashboard);
    }
}
