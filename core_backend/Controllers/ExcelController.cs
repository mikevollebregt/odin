using core_backend.Data;
using core_backend.Database;
using core_backend.Models;
using core_backend.Services;
using CsvHelper;
using CsvHelper.Configuration;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Text;

namespace core_backend.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class ExcelController : ControllerBase
    {
        private readonly ExcelService _excelService;
        private readonly PostgressDatabase _database;
        private readonly ApplicationDbContext _sqlDatabase;
        public ExcelController(ExcelService excelService, PostgressDatabase database, ApplicationDbContext sqlDatabase)
        {
            _excelService = excelService;
            _database = database;
            _sqlDatabase = sqlDatabase;
        }

        [HttpGet]
        public async Task<IActionResult> ImportGeolocations()
        {
            var geolocations = _excelService.Import("C:/CBS/movement/core_backend/core_backend/DataSources/sensorgeolocations.csv");
            await _database.AddRangeAsync(geolocations);
            await _database.SaveChangesAsync();

            return Ok("Geolocations imported and saved to the database");
        }

        [HttpGet]
        public async Task<ActionResult> ExportGeolocations()
        {
            var sesonsGeolocations = await _sqlDatabase.SensorGeolocations.ToListAsync();

            var cc = new CsvConfiguration(new System.Globalization.CultureInfo("en-US"));

            using var sw = new StreamWriter($"export_{DateTime.UtcNow.Ticks}.csv", false, Encoding.UTF8);
            using var cw = new CsvWriter(sw, cc);
            cw.WriteRecords(sesonsGeolocations);

            return Ok("Geolocations exported and saved");
        }
        

    }
}
