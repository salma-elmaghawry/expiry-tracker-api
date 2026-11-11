using ExpiryTracker.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace ExpiryTracker.Api.Data;

public class AppDbContext(DbContextOptions<AppDbContext> options) : DbContext(options)
{
    public DbSet<Batch> Batches => Set<Batch>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // Store enums as readable text ("Wasted") instead of numbers (3).
        modelBuilder.Entity<Batch>(batch =>
        {
            batch.Property(b => b.Category).HasConversion<string>();
            batch.Property(b => b.Status).HasConversion<string>();
            batch.Property(b => b.WasteReason).HasConversion<string>();
        });
    }
}
