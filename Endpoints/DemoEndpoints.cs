using ExpiryTracker.Api.Dtos;
using ExpiryTracker.Api.Services;
using Microsoft.AspNetCore.Http.HttpResults;

namespace ExpiryTracker.Api.Endpoints;

public static class DemoEndpoints
{
    public static void MapDemoEndpoints(this IEndpointRouteBuilder app)
    {
        app.MapPost("/api/demo/seed", Seed).WithTags("Demo");
    }

    // POST /api/demo/seed  => deletes ALL batches, then adds the demo set
    private static async Task<Ok<SeedResponse>> Seed(DemoSeedService service)
    {
        var result = await service.SeedAsync();
        return TypedResults.Ok(result);
    }
}
