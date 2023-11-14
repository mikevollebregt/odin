using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace core_backend.Data.Migrations
{
    public partial class userDaySensorCountviews : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "UserDaySensorCountViews",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<long>(type: "bigint", nullable: false),
                    UserId1 = table.Column<string>(type: "nvarchar(450)", nullable: true),
                    SensorCount = table.Column<int>(type: "int", nullable: false),
                    TrackedDayId = table.Column<long>(type: "bigint", nullable: false),
                    TrackedDayUuid = table.Column<string>(type: "nvarchar(450)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserDaySensorCountViews", x => x.Id);
                    table.ForeignKey(
                        name: "FK_UserDaySensorCountViews_AspNetUsers_UserId1",
                        column: x => x.UserId1,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_UserDaySensorCountViews_TrackedDays_TrackedDayUuid",
                        column: x => x.TrackedDayUuid,
                        principalTable: "TrackedDays",
                        principalColumn: "Uuid");
                });

            migrationBuilder.CreateTable(
                name: "DaySensorGeolocationViews",
                columns: table => new
                {
                    Id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserDaySensorCountViewId = table.Column<long>(type: "bigint", nullable: false),
                    UserDaySensorCountId = table.Column<long>(type: "bigint", nullable: false),
                    Uuid = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Latitude = table.Column<float>(type: "real", nullable: false),
                    Longitude = table.Column<float>(type: "real", nullable: false),
                    Altitude = table.Column<float>(type: "real", nullable: false),
                    Bearing = table.Column<float>(type: "real", nullable: false),
                    Accuracy = table.Column<float>(type: "real", nullable: false),
                    SensoryType = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Provider = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsNoise = table.Column<bool>(type: "bit", nullable: false),
                    CreatedOn = table.Column<long>(type: "bigint", nullable: false),
                    DeletedOn = table.Column<long>(type: "bigint", nullable: false),
                    BatteryLevel = table.Column<long>(type: "bigint", nullable: false),
                    UserId = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_DaySensorGeolocationViews", x => x.Id);
                    table.ForeignKey(
                        name: "FK_DaySensorGeolocationViews_UserDaySensorCountViews_UserDaySensorCountViewId",
                        column: x => x.UserDaySensorCountViewId,
                        principalTable: "UserDaySensorCountViews",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.NoAction);
                });

            migrationBuilder.CreateIndex(
                name: "IX_DaySensorGeolocationViews_UserDaySensorCountViewId",
                table: "DaySensorGeolocationViews",
                column: "UserDaySensorCountViewId");

            migrationBuilder.CreateIndex(
                name: "IX_UserDaySensorCountViews_TrackedDayUuid",
                table: "UserDaySensorCountViews",
                column: "TrackedDayUuid");

            migrationBuilder.CreateIndex(
                name: "IX_UserDaySensorCountViews_UserId1",
                table: "UserDaySensorCountViews",
                column: "UserId1");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "DaySensorGeolocationViews");

            migrationBuilder.DropTable(
                name: "UserDaySensorCountViews");
        }
    }
}
