using ExpiryTracker.Api.Data;
using ExpiryTracker.Api.Dtos;
using ExpiryTracker.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace ExpiryTracker.Api.Services;

public class BatchService(AppDbContext db)
{
    // status = null means "all batches"
    public async Task<List<BatchResponse>> GetAllAsync(BatchStatus? status)
    {
        IQueryable<Batch> query = db.Batches; // nothing runs yet, we are only building the query

        if (status is not null)
            query = query.Where(b => b.Status == status.Value);

        return await query
            .OrderBy(b => b.ExpiryDate) // closest to expiry first
            .ThenBy(b => b.Id)
            .Select(b => BatchResponse.FromEntity(b))
            .ToListAsync(); // the SELECT runs here
    }

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

    public async Task<ActionOutcome> ApplyActionAsync(int id, BatchActionRequest request)
    {
        var batch = await db.Batches.FindAsync(id);
        if (batch is null)
            return new ActionOutcome(ActionStatus.NotFound);

        // Sold and Wasted are final: nothing can happen after them.
        if (batch.Status == BatchStatus.Sold || batch.Status == BatchStatus.Wasted)
            return new ActionOutcome(ActionStatus.AlreadyClosed);

        switch (request.Action)
        {
            case BatchAction.Sell:
                batch.Status = BatchStatus.Sold;
                break;

            case BatchAction.Discount:
                if (request.DiscountPricePiasters >= batch.UnitPricePiasters)
                    return new ActionOutcome(ActionStatus.DiscountNotLower);

                batch.Status = BatchStatus.Discounted;
                batch.DiscountPricePiasters = request.DiscountPricePiasters;
                break;

            case BatchAction.Waste:
                batch.Status = BatchStatus.Wasted;
                batch.WasteReason = request.WasteReason;
                break;
        }

        batch.ActionAt = DateTime.UtcNow;

        // EF remembers how the batch looked when we loaded it,
        // so it sends an UPDATE for the changed columns only.
        await db.SaveChangesAsync();

        return new ActionOutcome(ActionStatus.Ok, BatchResponse.FromEntity(batch));
    }
}
