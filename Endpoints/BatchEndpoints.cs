using ExpiryTracker.Api.Dtos;
using ExpiryTracker.Api.Models;
using ExpiryTracker.Api.Services;
using Microsoft.AspNetCore.Http.HttpResults;

namespace ExpiryTracker.Api.Endpoints;

public static class BatchEndpoints
{
    public static void MapBatchEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/api/batches").WithTags("Batches");

        group.MapGet("/", GetBatches);
        group.MapPost("/", CreateBatch);
        group.MapPatch("/{id:int}/action", ApplyAction);
    }

    // GET /api/batches               => all
    // GET /api/batches?status=Active => only Active
    private static async Task<Ok<List<BatchResponse>>> GetBatches(
        BatchStatus? status,
        BatchService service)
    {
        var batches = await service.GetAllAsync(status);
        return TypedResults.Ok(batches);
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

    // PATCH /api/batches/5/action   body: { "action": "Waste", "wasteReason": "Expired" }
    private static async Task<Results<Ok<BatchResponse>, ValidationProblem, NotFound, ProblemHttpResult>> ApplyAction(
        int id,
        BatchActionRequest request,
        BatchService service)
    {
        var errors = request.Validate();
        if (errors.Count > 0)
            return TypedResults.ValidationProblem(errors);

        var outcome = await service.ApplyActionAsync(id, request);

        return outcome.Status switch
        {
            ActionStatus.Ok => TypedResults.Ok(outcome.Batch!),

            ActionStatus.NotFound => TypedResults.NotFound(),

            ActionStatus.AlreadyClosed => TypedResults.Problem(
                title: "This batch is already sold or wasted.",
                statusCode: StatusCodes.Status409Conflict),

            ActionStatus.DiscountNotLower => TypedResults.ValidationProblem(new Dictionary<string, string[]>
            {
                ["discountPricePiasters"] = ["Discount price must be lower than the selling price."]
            }),

            _ => throw new InvalidOperationException($"Unhandled action status: {outcome.Status}")
        };
    }
}
