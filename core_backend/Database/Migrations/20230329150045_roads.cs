using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace core_backend.Data.Migrations
{
    public partial class roads : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "BicycleRoadsCoordinates",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Latitude = table.Column<double>(type: "float", nullable: false),
                    Longitude = table.Column<double>(type: "float", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BicycleRoadsCoordinates", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "BusLineCoordinates",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Latitude = table.Column<double>(type: "float", nullable: false),
                    Longitude = table.Column<double>(type: "float", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BusLineCoordinates", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "CarRoadCoordinates",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Latitude = table.Column<double>(type: "float", nullable: false),
                    Longitude = table.Column<double>(type: "float", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CarRoadCoordinates", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "WalkingPathCoordinates",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Latitude = table.Column<double>(type: "float", nullable: false),
                    Longitude = table.Column<double>(type: "float", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_WalkingPathCoordinates", x => x.Id);
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "BicycleRoadsCoordinates");

            migrationBuilder.DropTable(
                name: "BusLineCoordinates");

            migrationBuilder.DropTable(
                name: "CarRoadCoordinates");

            migrationBuilder.DropTable(
                name: "WalkingPathCoordinates");
        }
    }
}
