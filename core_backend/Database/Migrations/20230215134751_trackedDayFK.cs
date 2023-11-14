using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace core_backend.Data.Migrations
{
    public partial class trackedDayFK : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_UserDaySensorCountViews_AspNetUsers_UserId1",
                table: "UserDaySensorCountViews");

            migrationBuilder.DropForeignKey(
                name: "FK_UserDaySensorCountViews_TrackedDays_TrackedDayUuid",
                table: "UserDaySensorCountViews");

            migrationBuilder.DropIndex(
                name: "IX_UserDaySensorCountViews_TrackedDayUuid",
                table: "UserDaySensorCountViews");

            migrationBuilder.DropIndex(
                name: "IX_UserDaySensorCountViews_UserId1",
                table: "UserDaySensorCountViews");

            migrationBuilder.DropColumn(
                name: "TrackedDayUuid",
                table: "UserDaySensorCountViews");

            migrationBuilder.DropColumn(
                name: "UserId1",
                table: "UserDaySensorCountViews");

            migrationBuilder.AlterColumn<string>(
                name: "UserId",
                table: "UserDaySensorCountViews",
                type: "nvarchar(450)",
                nullable: false,
                oldClrType: typeof(long),
                oldType: "bigint");

            migrationBuilder.AlterColumn<string>(
                name: "TrackedDayId",
                table: "UserDaySensorCountViews",
                type: "nvarchar(450)",
                nullable: false,
                oldClrType: typeof(long),
                oldType: "bigint");

            migrationBuilder.CreateIndex(
                name: "IX_UserDaySensorCountViews_TrackedDayId",
                table: "UserDaySensorCountViews",
                column: "TrackedDayId");

            migrationBuilder.CreateIndex(
                name: "IX_UserDaySensorCountViews_UserId",
                table: "UserDaySensorCountViews",
                column: "UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_UserDaySensorCountViews_AspNetUsers_UserId",
                table: "UserDaySensorCountViews",
                column: "UserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.NoAction);

            migrationBuilder.AddForeignKey(
                name: "FK_UserDaySensorCountViews_TrackedDays_TrackedDayId",
                table: "UserDaySensorCountViews",
                column: "TrackedDayId",
                principalTable: "TrackedDays",
                principalColumn: "Uuid",
                onDelete: ReferentialAction.NoAction);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_UserDaySensorCountViews_AspNetUsers_UserId",
                table: "UserDaySensorCountViews");

            migrationBuilder.DropForeignKey(
                name: "FK_UserDaySensorCountViews_TrackedDays_TrackedDayId",
                table: "UserDaySensorCountViews");

            migrationBuilder.DropIndex(
                name: "IX_UserDaySensorCountViews_TrackedDayId",
                table: "UserDaySensorCountViews");

            migrationBuilder.DropIndex(
                name: "IX_UserDaySensorCountViews_UserId",
                table: "UserDaySensorCountViews");

            migrationBuilder.AlterColumn<long>(
                name: "UserId",
                table: "UserDaySensorCountViews",
                type: "bigint",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(450)");

            migrationBuilder.AlterColumn<long>(
                name: "TrackedDayId",
                table: "UserDaySensorCountViews",
                type: "bigint",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(450)");

            migrationBuilder.AddColumn<string>(
                name: "TrackedDayUuid",
                table: "UserDaySensorCountViews",
                type: "nvarchar(450)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "UserId1",
                table: "UserDaySensorCountViews",
                type: "nvarchar(450)",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_UserDaySensorCountViews_TrackedDayUuid",
                table: "UserDaySensorCountViews",
                column: "TrackedDayUuid");

            migrationBuilder.CreateIndex(
                name: "IX_UserDaySensorCountViews_UserId1",
                table: "UserDaySensorCountViews",
                column: "UserId1");

            migrationBuilder.AddForeignKey(
                name: "FK_UserDaySensorCountViews_AspNetUsers_UserId1",
                table: "UserDaySensorCountViews",
                column: "UserId1",
                principalTable: "AspNetUsers",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_UserDaySensorCountViews_TrackedDays_TrackedDayUuid",
                table: "UserDaySensorCountViews",
                column: "TrackedDayUuid",
                principalTable: "TrackedDays",
                principalColumn: "Uuid");
        }
    }
}
