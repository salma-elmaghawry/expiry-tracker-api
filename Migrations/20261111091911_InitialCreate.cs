using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ExpiryTracker.Api.Migrations;

/// <inheritdoc />
public partial class _20261111091911_InitialCreate : Migration
{
    /// <inheritdoc />
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.CreateTable(
            name: "Batches",
            columns: table => new
            {
                Id = table.Column<int>(type: "INTEGER", nullable: false)
                    .Annotation("Sqlite:Autoincrement", true),
                ProductName = table.Column<string>(type: "TEXT", nullable: false),
                Barcode = table.Column<string>(type: "TEXT", nullable: true),
                Category = table.Column<string>(type: "TEXT", nullable: false),
                Quantity = table.Column<int>(type: "INTEGER", nullable: false),
                CostPricePiasters = table.Column<long>(type: "INTEGER", nullable: false),
                UnitPricePiasters = table.Column<long>(type: "INTEGER", nullable: false),
                DiscountPricePiasters = table.Column<long>(type: "INTEGER", nullable: true),
                ExpiryDate = table.Column<DateOnly>(type: "TEXT", nullable: false),
                Status = table.Column<string>(type: "TEXT", nullable: false),
                WasteReason = table.Column<string>(type: "TEXT", nullable: true),
                CreatedAt = table.Column<DateTime>(type: "TEXT", nullable: false),
                ActionAt = table.Column<DateTime>(type: "TEXT", nullable: true)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_Batches", x => x.Id);
            });
    }

    /// <inheritdoc />
    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropTable(
            name: "Batches");
    }
}
