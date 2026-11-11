using ExpiryTracker.Api.Models;

namespace ExpiryTracker.Api.Dtos;

public record CategoryLoss(Category Category, int BatchCount, long ValuePiasters);

public record LossesReportResponse(
    string Month,                     // "2026-11"
    int TotalBatches,
    long TotalValuePiasters,
    List<CategoryLoss> Categories);   // biggest loss first
