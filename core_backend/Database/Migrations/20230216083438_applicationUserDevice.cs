using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace core_backend.Data.Migrations
{
    public partial class applicationUserDevice : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            //migrationBuilder.DropIndex(
            //    name: "IX_Devices_UserId",
            //    table: "Devices");

            //migrationBuilder.CreateIndex(
            //    name: "IX_Devices_UserId",
            //    table: "Devices",
            //    column: "UserId",
            //    unique: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
        //    migrationBuilder.DropIndex(
        //        name: "IX_Devices_UserId",
        //        table: "Devices");

        //    migrationBuilder.CreateIndex(
        //        name: "IX_Devices_UserId",
        //        table: "Devices",
        //        column: "UserId");
        }
    }
}
