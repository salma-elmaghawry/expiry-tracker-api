using ExpiryTracker.Api.Dtos;
using ExpiryTracker.Api.Services;
using Microsoft.AspNetCore.Http.HttpResults;

namespace ExpiryTracker.Api.Endpoints;

public static class CartonEndpoints
{
    public static void MapCartonEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/api/cartons").WithTags("Cartons");

        group.MapPost("/scan/preview", PreviewCarton);
        group.MapPost("/scan", ScanCarton);
    }

    // POST /api/cartons/scan/preview   body: { "qrText": "{...}" }
    // A question, not an action: nothing is saved, so "already received" is a field (200), not a 409.
    // POST and not GET because the QR text is long and full of quotes; a GET has no body.
    private static async Task<Results<Ok<CartonPreviewResponse>, ValidationProblem>> PreviewCarton(
        PreviewCartonRequest request,
        CartonService service,
        LabelSigner signer)
    {
        var (qr, errors) = CartonQr.Read(request.QrText, signer);
        if (qr is null)
            return TypedResults.ValidationProblem(errors);

        var preview = await service.PreviewAsync(qr);
        return TypedResults.Ok(preview);
    }

    // POST /api/cartons/scan   body: { "qrText": "{...}", "sellingPricePiasters": 550 }
    // 201 = received, 400 = bad label or price needed, 409 = this carton was already received
    private static async Task<Results<Created<CartonResponse>, ValidationProblem, ProblemHttpResult>> ScanCarton(
        ScanCartonRequest request,
        CartonService service,
        LabelSigner signer)
    {
        var (qr, errors) = CartonQr.Read(request.QrText, signer);
        if (request.SellingPricePiasters <= 0)
            errors["sellingPricePiasters"] = ["Selling price must be greater than 0."];

        if (qr is null || errors.Count > 0)
            return TypedResults.ValidationProblem(errors);

        var outcome = await service.ReceiveAsync(qr, request.SellingPricePiasters);

        return outcome.Status switch
        {
            ScanStatus.Ok => TypedResults.Created($"/api/cartons/{outcome.Carton!.Id}", outcome.Carton),

            // receivedAt travels with the error so the app can say "already received on 12 Nov".
            ScanStatus.AlreadyReceived => TypedResults.Problem(
                title: "This carton was already received.",
                statusCode: StatusCodes.Status409Conflict,
                extensions: new Dictionary<string, object?> { ["receivedAt"] = outcome.ReceivedAt }),

            ScanStatus.SellingPriceRequired => TypedResults.ValidationProblem(new Dictionary<string, string[]>
            {
                ["sellingPricePiasters"] = ["New product: enter the selling price of one piece."]
            }),

            _ => throw new InvalidOperationException($"Unhandled scan status: {outcome.Status}")
        };
    }
}
