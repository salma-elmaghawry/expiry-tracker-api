using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ExpiryTracker.Api.Migrations;

/// <inheritdoc />
public partial class _20261112121744_AddLabelJobs : Migration
{
    /// <inheritdoc />
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.CreateTable(
            name: "LabelJobs",
            columns: table => new
            {
                Id = table.Column<int>(type: "INTEGER", nullable: false)
                    .Annotation("Sqlite:Autoincrement", true),
                ProductName = table.Column<string>(type: "TEXT", nullable: false),
                Barcode = table.Column<string>(type: "TEXT", nullable: false),
                Category = table.Column<string>(type: "TEXT", nullable: false),
                BoxesCount = table.Column<int>(type: "INTEGER", nullable: false),
                PiecesPerBox = table.Column<int>(type: "INTEGER", nullable: false),
                LotNumber = table.Column<string>(type: "TEXT", nullable: false),
                ProductionDate = table.Column<DateOnly>(type: "TEXT", nullable: false),
                ExpiryDate = table.Column<DateOnly>(type: "TEXT", nullable: false),
                CostPiasters = table.Column<long>(type: "INTEGER", nullable: false),
                CodePrefix = table.Column<string>(type: "TEXT", nullable: false),
                FirstSequence = table.Column<int>(type: "INTEGER", nullable: false),
                CartonCount = table.Column<int>(type: "INTEGER", nullable: false),
                CreatedAt = table.Column<DateTime>(type: "TEXT", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_LabelJobs", x => x.Id);
            });

        migrationBuilder.CreateIndex(
            name: "IX_LabelJobs_CodePrefix",
            table: "LabelJobs",
            column: "CodePrefix");
    }

    /// <inheritdoc />
    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropTable(
            name: "LabelJobs");
    }
}
