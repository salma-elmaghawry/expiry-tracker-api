using ExpiryTracker.Api.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

namespace ExpiryTracker.Api.Data;

public class AppDbContext(DbContextOptions<AppDbContext> options) : DbContext(options)
{
    public DbSet<Batch> Batches => Set<Batch>(); // old flow, removed once everything uses cartons

    public DbSet<Product> Products => Set<Product>();
    public DbSet<Carton> Cartons => Set<Carton>();
    public DbSet<StockMovement> StockMovements => Set<StockMovement>();
    public DbSet<LabelJob> LabelJobs => Set<LabelJob>();

    // SQLite stores DateTime as text with no time zone, so values come back with Kind = Unspecified
    // and the JSON loses its "Z". Every DateTime we save is UTC, so mark it as UTC when reading.
    protected override void ConfigureConventions(ModelConfigurationBuilder configurationBuilder)
    {
        configurationBuilder.Properties<DateTime>().HaveConversion<UtcDateTimeConverter>();
    }

    private class UtcDateTimeConverter() : ValueConverter<DateTime, DateTime>(
        toDatabase => toDatabase,
        fromDatabase => DateTime.SpecifyKind(fromDatabase, DateTimeKind.Utc));

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // Store enums as readable text ("Wasted") instead of numbers (3).
        modelBuilder.Entity<Batch>(batch =>
        {
            batch.Property(b => b.Category).HasConversion<string>();
            batch.Property(b => b.Status).HasConversion<string>();
            batch.Property(b => b.WasteReason).HasConversion<string>();
        });

        modelBuilder.Entity<Product>(product =>
        {
            // One row per barcode: the second carton of the same product reuses this row.
            product.HasIndex(p => p.Barcode).IsUnique();
            product.Property(p => p.Category).HasConversion<string>();
        });

        modelBuilder.Entity<Carton>(carton =>
        {
            // The database itself refuses a second carton with the same QR id,
            // so a double scan can never create duplicate stock, even if our code has a bug.
            carton.HasIndex(c => c.CartonCode).IsUnique();
        });

        modelBuilder.Entity<StockMovement>(movement =>
        {
            movement.Property(m => m.Type).HasConversion<string>();
            movement.Property(m => m.WasteReason).HasConversion<string>();
        });

        modelBuilder.Entity<LabelJob>(job =>
        {
            job.Property(j => j.Category).HasConversion<string>();
            // Finding "where did this lot stop?" is a lookup by prefix.
            job.HasIndex(j => j.CodePrefix);
        });
    }
}
