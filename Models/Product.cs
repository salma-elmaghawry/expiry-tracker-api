namespace ExpiryTracker.Api.Models;

// One product = one barcode that the cashier scans (a single piece, not the box or the carton).
// Created automatically the first time a carton of it is scanned.
public class Product
{
    public int Id { get; set; }

    public required string Barcode { get; set; } // EAN-13 printed on the single piece
    public required string Name { get; set; }
    public Category Category { get; set; }

    // Price of ONE piece in piasters. Null until the supervisor enters it after the first scan.
    public long? SellingPricePiasters { get; set; }

    // Navigation: all cartons of this product (one product -> many cartons).
    public List<Carton> Cartons { get; set; } = [];
}
