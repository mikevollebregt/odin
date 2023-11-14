using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace core_backend.Data.Migrations
{
    public partial class trainRailIndex : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateIndex(
                name: "IX_TrainRailCoordinates_Latitude_Longitude",
                table: "TrainRailCoordinates",
                columns: new[] { "Latitude", "Longitude" });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_TrainRailCoordinates_Latitude_Longitude",
                table: "TrainRailCoordinates");
        }
    }
}
