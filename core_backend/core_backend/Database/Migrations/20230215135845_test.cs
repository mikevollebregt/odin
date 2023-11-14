using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace core_backend.Data.Migrations
{
    public partial class test : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "UserDaySensorCountId",
                table: "DaySensorGeolocationViews");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<long>(
                name: "UserDaySensorCountId",
                table: "DaySensorGeolocationViews",
                type: "bigint",
                nullable: false,
                defaultValue: 0L);
        }
    }
}
