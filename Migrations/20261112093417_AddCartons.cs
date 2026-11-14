using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ExpiryTracker.Api.Migrations;

/// <inheritdoc />
public partial class _20261112093417_AddCartons : Migration
{
    /// <inheritdoc />
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.CreateTable(
            name: "Products",
            columns: table => new
            {
                Id = table.Column<int>(type: "INTEGER", nullable: false)
                    .Annotation("Sqlite:Autoincrement", true),
                Barcode = table.Column<string>(type: "TEXT", nullable: false),
                Name = table.Column<string>(type: "TEXT", nullable: false),
                Category = table.Column<string>(type: "TEXT", nullable: false),
                SellingPricePiasters = table.Column<long>(type: "INTEGER", nullable: true)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_Products", x => x.Id);
            });

        migrationBuilder.CreateTable(
            name: "Cartons",
            columns: table => new
            {
                Id = table.Column<int>(type: "INTEGER", nullable: false)
                    .Annotation("Sqlite:Autoincrement", true),
                CartonCode = table.Column<string>(type: "TEXT", nullable: false),
                ProductId = table.Column<int>(type: "INTEGER", nullable: false),
                LotNumber = table.Column<string>(type: "TEXT", nullable: false),
                ProductionDate = table.Column<DateOnly>(type: "TEXT", nullable: false),
                ExpiryDate = table.Column<DateOnly>(type: "TEXT", nullable: false),
                BoxesCount = table.Column<int>(type: "INTEGER", nullable: false),
                PiecesPerBox = table.Column<int>(type: "INTEGER", nullable: false),
                TotalPieces = table.Column<int>(type: "INTEGER", nullable: false),
                RemainingPieces = table.Column<int>(type: "INTEGER", nullable: false),
                CostPiasters = table.Column<long>(type: "INTEGER", nullable: false),
                DiscountPricePiasters = table.Column<long>(type: "INTEGER", nullable: true),
                ScannedAt = table.Column<DateTime>(type: "TEXT", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_Cartons", x => x.Id);
                table.ForeignKey(
                    name: "FK_Cartons_Products_ProductId",
                    column: x => x.ProductId,
                    principalTable: "Products",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
            });

        migrationBuilder.CreateTable(
            name: "StockMovements",
            columns: table => new
            {
                Id = table.Column<int>(type: "INTEGER", nullable: false)
                    .Annotation("Sqlite:Autoincrement", true),
                CartonId = table.Column<int>(type: "INTEGER", nullable: false),
                Type = table.Column<string>(type: "TEXT", nullable: false),
                Quantity = table.Column<int>(type: "INTEGER", nullable: false),
                WasteReason = table.Column<string>(type: "TEXT", nullable: true),
                ReceiptNumber = table.Column<string>(type: "TEXT", nullable: true),
                At = table.Column<DateTime>(type: "TEXT", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_StockMovements", x => x.Id);
                table.ForeignKey(
                    name: "FK_StockMovements_Cartons_CartonId",
                    column: x => x.CartonId,
                    principalTable: "Cartons",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
            });

        migrationBuilder.CreateIndex(
            name: "IX_Cartons_CartonCode",
            table: "Cartons",
            column: "CartonCode",
            unique: true);

        migrationBuilder.CreateIndex(
            name: "IX_Cartons_ProductId",
            table: "Cartons",
            column: "ProductId");

        migrationBuilder.CreateIndex(
            name: "IX_Products_Barcode",
            table: "Products",
            column: "Barcode",
            unique: true);

        migrationBuilder.CreateIndex(
            name: "IX_StockMovements_CartonId",
            table: "StockMovements",
            column: "CartonId");
    }

    /// <inheritdoc />
    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropTable(
            name: "StockMovements");

        migrationBuilder.DropTable(
            name: "Cartons");

        migrationBuilder.DropTable(
            name: "Products");
    }
}
