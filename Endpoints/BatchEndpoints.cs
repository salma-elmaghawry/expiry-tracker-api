using ExpiryTracker.Api.Dtos;
using ExpiryTracker.Api.Services;
using Microsoft.AspNetCore.Http.HttpResults;

namespace ExpiryTracker.Api.Endpoints;

public static class BatchEndpoints
{
    public static void MapBatchEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/api/batches").WithTags("Batches");

        group.MapPost("/", CreateBatch);
    }

    private static async Task<Results<Created<BatchResponse>, ValidationProblem>> CreateBatch(
        CreateBatchRequest request,
        BatchService service)
    {
        var errors = request.Validate();
        if (errors.Count > 0)
            return TypedResults.ValidationProblem(errors);

        var batch = await service.CreateAsync(request);
        return TypedResults.Created($"/api/batches/{batch.Id}", batch);
    }
}
