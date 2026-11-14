using ExpiryTracker.Api.Dtos;
using ExpiryTracker.Api.Services;
using Microsoft.AspNetCore.Http.HttpResults;

namespace ExpiryTracker.Api.Endpoints;

// Factory portal: create carton labels and load them again for printing.
public static class LabelEndpoints
{
    public static void MapLabelEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/api/labels").WithTags("Factory labels");

        group.MapPost("/jobs", CreateJob);
        group.MapGet("/jobs/{id:int}", GetJob);
    }

    // POST /api/labels/jobs   201 = job created with all its signed labels, 400 = form errors
    private static async Task<Results<Created<LabelJobResponse>, ValidationProblem>> CreateJob(
        CreateLabelJobRequest request,
        LabelService service)
    {
        var errors = request.Validate();
        if (errors.Count > 0)
            return TypedResults.ValidationProblem(errors);

        var job = await service.CreateJobAsync(request);
        return TypedResults.Created($"/api/labels/jobs/{job.Id}", job);
    }

    // GET /api/labels/jobs/5   the print preview page loads its labels from here (also after a refresh)
    private static async Task<Results<Ok<LabelJobResponse>, NotFound>> GetJob(int id, LabelService service)
    {
        var job = await service.GetJobAsync(id);
        return job is null ? TypedResults.NotFound() : TypedResults.Ok(job);
    }
}
