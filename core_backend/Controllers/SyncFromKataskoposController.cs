using core_backend.Data;
using core_backend.Database;
using core_backend.Models;
using Microsoft.AspNetCore.Mvc;

namespace core_backend.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class SyncFromKataskoposController : ControllerBase
    {
        private readonly IHttpClientFactory _clientFactory;
        private readonly KataskoposDbContext _kataskoposDatabase;
        private readonly ApplicationDbContext _database;

        public SyncFromKataskoposController(IHttpClientFactory clientFactory, KataskoposDbContext kataskoposDatabase, ApplicationDbContext database)
        {
            _clientFactory = clientFactory;
            _database = database;
            _kataskoposDatabase = kataskoposDatabase;
        }


        [HttpGet]
        public async Task<IActionResult> Test()
        {
            var users = _kataskoposDatabase.Users.Select(u => new ApplicationUser { 
                Id = u.Id,
                UserName = u.UserName,
                AccessFailedCount = u.AccessFailedCount,
                ConcurrencyStamp = u.ConcurrencyStamp,
                Email = u.Email,
                EmailConfirmed = u.EmailConfirmed,
                LockoutEnabled = u.LockoutEnabled,
                NormalizedEmail = u.NormalizedEmail,
                NormalizedUserName = u.NormalizedUserName,
                PasswordHash = u.PasswordHash,
                PhoneNumberConfirmed = u.PhoneNumberConfirmed,
                SecurityStamp = u.SecurityStamp,
                TwoFactorEnabled = u.TwoFactorEnabled,               
            }).ToList();

            foreach(var user in users)
            {
                var list = _kataskoposDatabase.SensorGeolocations
                    .Select(s => new SensorGeolocation
                    {
                        Accuracy = s.Accuracy,
                        Altitude = s.Altitude,
                        BatteryLevel = s.BatteryLevel,
                        Bearing = s.Bearing,
                        CreatedOn = s.CreatedOn,
                        Latitude = s.Latitude,
                        Longitude = s.Longitude,
                        Provider = s.Provider,
                        UserId = s.UserId,
                        Uuid = s.Uuid,
                        DeletedOn = null,
                        IsNoise = false,
                        SensoryType = ""
                    })
                    .Where(s => s.UserId == user.Id)
                    .ToList();
                _database.Users.Add(user);
                _database.SensorGeolocations.AddRange(list);
                _database.SaveChanges();
            }


            return Ok();
        }
    }
}
