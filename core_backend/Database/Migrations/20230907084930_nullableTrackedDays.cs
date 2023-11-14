using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace core_backend.Data.Migrations
{
    public partial class nullableTrackedDays : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_UserDaySensorCountViews_TrackedDays_TrackedDayId",
                table: "UserDaySensorCountViews");

            migrationBuilder.AlterColumn<string>(
                name: "TrackedDayId",
                table: "UserDaySensorCountViews",
                type: "nvarchar(450)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(450)");

            migrationBuilder.AddForeignKey(
                name: "FK_UserDaySensorCountViews_TrackedDays_TrackedDayId",
                table: "UserDaySensorCountViews",
                column: "TrackedDayId",
                principalTable: "TrackedDays",
                principalColumn: "Uuid");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_UserDaySensorCountViews_TrackedDays_TrackedDayId",
                table: "UserDaySensorCountViews");

            migrationBuilder.AlterColumn<string>(
                name: "TrackedDayId",
                table: "UserDaySensorCountViews",
                type: "nvarchar(450)",
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(string),
                oldType: "nvarchar(450)",
                oldNullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_UserDaySensorCountViews_TrackedDays_TrackedDayId",
                table: "UserDaySensorCountViews",
                column: "TrackedDayId",
                principalTable: "TrackedDays",
                principalColumn: "Uuid",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
