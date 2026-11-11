using ExpiryTracker.Api.Data;
using ExpiryTracker.Api.Dtos;
using ExpiryTracker.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace ExpiryTracker.Api.Services;

// Wipes all batches and fills the database with realistic demo data.
// All dates are relative to today, so the dashboard and reports always have something to show.
public class DemoSeedService(AppDbContext db)
{
    public async Task<SeedResponse> SeedAsync()
    {
        var today = DateOnly.FromDateTime(DateTime.Now);
        var now = DateTime.UtcNow;

        // The 10th of last month at noon (Cairo), so it always lands in last month's losses report.
        var lastMonthDay = new DateOnly(today.Year, today.Month, 1).AddMonths(-1).AddDays(9);
        var lastMonthUtc = lastMonthDay.ToDateTime(new TimeOnly(12, 0), DateTimeKind.Local).ToUniversalTime();

        // Prices are in piasters. The underscore is just for reading: 35_00 = 3500 = 35.00 EGP
        Batch Make(
            string name, Category category, int quantity, long cost, long price, DateOnly expires,
            BatchStatus status = BatchStatus.Active, long? discount = null,
            WasteReason? reason = null, DateTime? actionAt = null)
        {
            var actionTime = status == BatchStatus.Active ? (DateTime?)null : actionAt ?? now;

            return new Batch
            {
                ProductName = name,
                Category = category,
                Quantity = quantity,
                CostPricePiasters = cost,
                UnitPricePiasters = price,
                DiscountPricePiasters = discount,
                ExpiryDate = expires,
                Status = status,
                WasteReason = reason,
                ActionAt = actionTime,
                CreatedAt = (actionTime ?? now).AddDays(-7), // received a week before anything happened to it
            };
        }

        var batches = new List<Batch>
        {
            // ---- Dashboard: expired (still on the shelf!) ----
            Make("Juhayna Full Cream Milk 1L", Category.Dairy, 6, 30_00, 35_00, today.AddDays(-2)),
            Make("Rich Bake Toast", Category.Bakery, 4, 20_00, 25_00, today.AddDays(-1)),

            // ---- Dashboard: within 3 days ----
            Make("Almarai Plain Yogurt 105g", Category.Dairy, 30, 4_50, 6_00, today,
                status: BatchStatus.Discounted, discount: 5_00),
            Make("Fresh Chicken Breast 1kg", Category.MeatAndPoultry, 8, 180_00, 220_00, today.AddDays(1)),
            Make("Domty Feta Cheese 500g", Category.Dairy, 12, 45_00, 55_00, today.AddDays(2)),
            Make("Strawberries 1kg", Category.FruitsAndVegetables, 10, 60_00, 80_00, today.AddDays(3),
                status: BatchStatus.Discounted, discount: 70_00),

            // ---- Dashboard: within 4 to 7 days ----
            Make("Edita Molto Croissant", Category.Bakery, 40, 5_00, 7_00, today.AddDays(5)),
            Make("Juhayna Mango Juice 1L", Category.Beverages, 20, 35_00, 42_00, today.AddDays(6)),
            Make("Halwani Luncheon 250g", Category.MeatAndPoultry, 10, 40_00, 50_00, today.AddDays(7)),

            // ---- Safe for now (more than 7 days) ----
            Make("Abu Auf Turkish Coffee 250g", Category.Grocery, 15, 95_00, 120_00, today.AddDays(60)),
            Make("Chipsy Cheese Large", Category.Snacks, 50, 8_00, 10_00, today.AddDays(45)),
            Make("Atyab Frozen Burger 8pcs", Category.Frozen, 6, 90_00, 115_00, today.AddDays(120)),

            // ---- Sold ----
            Make("Fino Bread", Category.Bakery, 20, 5_00, 7_00, today.AddDays(-1), status: BatchStatus.Sold),
            Make("Pepsi 1L", Category.Beverages, 24, 15_00, 20_00, today.AddDays(90), status: BatchStatus.Sold),

            // ---- Wasted this month (losses report) ----
            Make("Juhayna Laban Rayeb 1L", Category.Dairy, 5, 28_00, 33_00, today.AddDays(-1),
                status: BatchStatus.Wasted, reason: WasteReason.Expired),
            Make("Tomatoes 1kg", Category.FruitsAndVegetables, 15, 15_00, 20_00, today.AddDays(-2),
                status: BatchStatus.Wasted, reason: WasteReason.Spoiled),
            Make("Chicken Thighs 1kg", Category.MeatAndPoultry, 3, 150_00, 185_00, today.AddDays(-1),
                status: BatchStatus.Wasted, reason: WasteReason.Expired),
            Make("Rich Bake Toast", Category.Bakery, 2, 20_00, 25_00, today.AddDays(4),
                status: BatchStatus.Wasted, reason: WasteReason.Damaged),

            // ---- Wasted last month (so the report has a previous month to compare) ----
            Make("Domty Feta Cheese 500g", Category.Dairy, 4, 45_00, 55_00, lastMonthDay.AddDays(-1),
                status: BatchStatus.Wasted, reason: WasteReason.Expired, actionAt: lastMonthUtc),
            Make("Cucumbers 1kg", Category.FruitsAndVegetables, 20, 10_00, 15_00, lastMonthDay.AddDays(-1),
                status: BatchStatus.Wasted, reason: WasteReason.Spoiled, actionAt: lastMonthUtc),
            Make("Frozen Molokhia 400g", Category.Frozen, 12, 18_00, 22_00, lastMonthDay.AddDays(90),
                status: BatchStatus.Wasted, reason: WasteReason.Damaged, actionAt: lastMonthUtc),
        };

        // Delete and insert succeed together, or neither happens.
        await using var transaction = await db.Database.BeginTransactionAsync();

        var deleted = await db.Batches.ExecuteDeleteAsync(); // one DELETE statement, nothing loaded into memory
        db.Batches.AddRange(batches);
        await db.SaveChangesAsync();

        await transaction.CommitAsync();

        return new SeedResponse(deleted, batches.Count);
    }
}
