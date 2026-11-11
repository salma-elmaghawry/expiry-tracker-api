using ExpiryTracker.Api.Data;
using ExpiryTracker.Api.Dtos;
using ExpiryTracker.Api.Models;

namespace ExpiryTracker.Api.Services;

public class BatchService(AppDbContext db)
{
    public async Task<BatchResponse> CreateAsync(CreateBatchRequest request)
    {
        var batch = new Batch
        {
            ProductName = request.ProductName.Trim(),
            Barcode = request.Barcode,
            Category = request.Category,
            Quantity = request.Quantity,
            CostPricePiasters = request.CostPricePiasters,
            UnitPricePiasters = request.UnitPricePiasters,
            ExpiryDate = request.ExpiryDate,
        };

        db.Batches.Add(batch);
        await db.SaveChangesAsync(); // this is where the INSERT actually runs

        return BatchResponse.FromEntity(batch);
    }
}
