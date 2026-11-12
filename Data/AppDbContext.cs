using ExpiryTracker.Api.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

namespace ExpiryTracker.Api.Data;

public class AppDbContext(DbContextOptions<AppDbContext> options) : DbContext(options)
{
    public DbSet<Batch> Batches => Set<Batch>();

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
    }
}
