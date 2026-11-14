namespace ExpiryTracker.Api.Models;

// One "Print N labels" click on the factory page.
// We store the form once, not every label: label number i is rebuilt from this row on demand.
// Example: lot ED-2611-07, 50 cartons -> CT-ED261107-0001 ... CT-ED261107-0050.
public class LabelJob
{
    public int Id { get; set; }

    public required string ProductName { get; set; }
    public required string Barcode { get; set; }
    public Category Category { get; set; }
    public int BoxesCount { get; set; }
    public int PiecesPerBox { get; set; }
    public required string LotNumber { get; set; }
    public DateOnly ProductionDate { get; set; }
    public DateOnly ExpiryDate { get; set; }
    public long CostPiasters { get; set; } // whole carton

    // "CT-ED261107": the start of every carton id in this job (from the lot number).
    public required string CodePrefix { get; set; }

    // This job owns carton numbers FirstSequence .. FirstSequence + CartonCount - 1.
    // A second job for the same lot continues after the last one, so ids never repeat.
    public int FirstSequence { get; set; }
    public int CartonCount { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}
