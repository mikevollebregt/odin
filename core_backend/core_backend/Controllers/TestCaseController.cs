using core_backend.Data;
using core_backend.Models;
using core_backend.Models.DTOs;
using core_backend.Models.Views;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace core_backend.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class TestCaseController : ControllerBase
    {
        private readonly ApplicationDbContext _database;

        public TestCaseController(ApplicationDbContext database)
        {
            _database = database;
        }

        [HttpGet]
        public async Task<IActionResult> CreateViews()
        {
            var users = await _database.Devices
                .Include(d => d.User)
                .Select(d => new UserSensorGeolocationDataDTO
                {
                    Brand = d.Brand,
                    Model = d.DeviceModel,
                    Sdk = d.SDK,
                    User = d.User.UserName,
                    UserId = d.UserId,
                    SensorCount = _database.SensorGeolocations.Where(s => s.UserId == d.UserId).Count().ToString()
                })
                .Where(d => Convert.ToInt32(d.SensorCount) > 200)
                .OrderBy(d => Convert.ToInt32(d.SensorCount))
                .ToListAsync();

            foreach(var user in users)
            {

                var trackedDays = await _database.TrackedDays.Where(t => t.UserId == user.UserId).ToListAsync();
                foreach (var day in trackedDays)
                {
                    var date = (new DateTime(1970, 1, 1)).AddMilliseconds((double)day.Day);
                    var startTime = new DateTimeOffset(StartOfDay(date)).ToUnixTimeMilliseconds();
                    var endTime = new DateTimeOffset(EndOfDay(date)).ToUnixTimeMilliseconds();
                    var rawdata = await _database.SensorGeolocations.Where(s => s.UserId == user.UserId && s.CreatedOn > startTime && s.CreatedOn < endTime).ToListAsync();

                    if(rawdata.Count == 0)
                    {
                        continue;
                    }

                    var userview = new UserDaySensorCountView
                    {
                        SensorCount = rawdata.Count,
                        UserId = user.UserId,
                        TrackedDayId = day.Uuid
                    };

                    await _database.UserDaySensorCountViews.AddAsync(userview);
                    await _database.SaveChangesAsync();

                    foreach(var sl in rawdata)
                    {
                        var daySensorGeolocationView = new DaySensorGeolocationView
                        {
                            UserDaySensorCountViewId = userview.Id,
                            Accuracy = sl.Accuracy,
                            BatteryLevel = sl.BatteryLevel,
                            Altitude = sl.Altitude,
                            Bearing = sl.Bearing,
                            CreatedOn = sl.CreatedOn,
                            DeletedOn = sl.DeletedOn,
                            IsNoise = sl.IsNoise,
                            Latitude = sl.Latitude,
                            Longitude = sl.Longitude,
                            Provider = sl.Provider,
                            SensoryType = sl.SensoryType,
                            UserId = sl.UserId,
                            Uuid = sl.Uuid
                        };

                        await _database.DaySensorGeolocationViews.AddAsync(daySensorGeolocationView);
                        await _database.SaveChangesAsync();
                    }
                }
            }


            return Ok(users);
        }

        [HttpGet]
        public async Task<IActionResult> CreateUsersViews()
        {
            var users = await _database.Users
                .Select(d => new UserSensorGeolocationDataDTO
                {
                    Brand = "",
                    Model = "",
                    Sdk = "",
                    User = d.UserName,
                    UserId = d.Id,
                    SensorCount = _database.SensorGeolocations.Where(s => s.UserId == d.Id).Count().ToString()
                })
                .Where(d => d.UserId == "dd81263a-b3bb-4e12-8562-30207b06e0fd")
                .OrderBy(d => Convert.ToInt32(d.SensorCount))
                .ToListAsync();

            foreach (var user in users)
            {
                var userExist = _database.UserDaySensorCountViews.FirstOrDefault(u => u.UserId == user.UserId);

                if(userExist != null)
                {
                    continue;
                }

                var firstSensorgeolocation = _database.SensorGeolocations.OrderBy(s => s.CreatedOn).First(s => s.UserId == user.UserId);

                var firstDay = (new DateTime(1970, 1, 1)).AddMilliseconds((double)firstSensorgeolocation.CreatedOn);

                for(var i = 0; i<6; i++)
                {
                    var date = firstDay.AddDays(i);
                    var startTime = new DateTimeOffset(StartOfDay(date)).ToUnixTimeMilliseconds();
                    var endTime = new DateTimeOffset(EndOfDay(date)).ToUnixTimeMilliseconds();
                    var rawdata = await _database.SensorGeolocations.Where(s => s.UserId == user.UserId && s.CreatedOn > startTime && s.CreatedOn < endTime).ToListAsync();

                    if (rawdata.Count == 0)
                    {
                        continue;
                    }

                    

                    var userview = new UserDaySensorCountView
                    {
                        SensorCount = rawdata.Count,
                        UserId = user.UserId,
                        //TrackedDayId = day.Uuid
                    };

                    await _database.UserDaySensorCountViews.AddAsync(userview);
                    await _database.SaveChangesAsync();

                    foreach (var sl in rawdata)
                    {
                        var daySensorGeolocationView = new DaySensorGeolocationView
                        {
                            UserDaySensorCountViewId = userview.Id,
                            Accuracy = sl.Accuracy,
                            BatteryLevel = sl.BatteryLevel,
                            Altitude = sl.Altitude,
                            Bearing = sl.Bearing,
                            CreatedOn = sl.CreatedOn,
                            DeletedOn = sl.DeletedOn,
                            IsNoise = sl.IsNoise,
                            Latitude = sl.Latitude,
                            Longitude = sl.Longitude,
                            Provider = sl.Provider,
                            SensoryType = sl.SensoryType,
                            UserId = sl.UserId,
                            Uuid = sl.Uuid
                        };

                        await _database.DaySensorGeolocationViews.AddAsync(daySensorGeolocationView);
                        await _database.SaveChangesAsync();
                    }
                }
            }


            return Ok(users);
        }

        [HttpGet]
        public async Task<IActionResult> GetUserViewId()
        {
           

            var users = await _database.UserDaySensorCountViews
                .Include(u => u.TrackedDay)
                .Where(u => u.SensorCount > 5000)
                .OrderBy(d => Convert.ToInt32(d.SensorCount))
                .ThenBy(d => d.TrackedDay.Day)
                .ToListAsync();

            foreach(var user in users)
            {
                var periods = await _database.ClassifiedPeriods.Where(cp => user.TrackedDay.Day < cp.StartDate && (user.TrackedDay.Day + 86400000) > cp.EndDate).ToListAsync();
                var i = 0;
            }

            return Ok(users);
        }

        [HttpGet]
        public async Task<IActionResult> GetUsefulUsersDays()
        {
            var list = new List<long> { 2007, 1985, 1988, 1994, 2000, 2002 };


            var users = await _database.UserDaySensorCountViews
                .Include(u => u.TrackedDay)
                .Include(u => u.User)
                .ThenInclude(u => u.Device)
                .Select(u => new UserSensorGeolocationDataDTO
                {
                    UserDaySensorCountViewsId = u.Id,
                    Brand = u.User.Device.Brand,
                    Model = u.User.Device.DeviceModel,
                    Sdk = u.User.Device.SDK,
                    User = u.User.UserName,
                    UserId = u.UserId,
                    SensorCount = u.SensorCount.ToString(),
                    TrackedDay = u.TrackedDay
                })
                .Where(u => list.Contains(u.UserDaySensorCountViewsId))
                //.DistinctBy(d => d.TrackedDay.Uuid)
                .OrderBy(d => Convert.ToInt32(d.SensorCount))
                .ThenBy(d => d.TrackedDay.Day)
                .ToListAsync();
           
            return Ok(users);
        }

        [HttpGet("{userDaySensorCountViewsId}")]
        public async Task<IActionResult> GetUsefulDays(long userDaySensorCountViewsId)
        {
            var userDay = await _database.UserDaySensorCountViews
                .Include(u => u.TrackedDay)
                .FirstOrDefaultAsync(u => u.Id == userDaySensorCountViewsId);

            var sensors = await _database.DaySensorGeolocationViews
                .Where(d => d.UserDaySensorCountViewId == userDaySensorCountViewsId)
                .Select(d => new DaySensorGeolocationView
                {
                    Accuracy = d.Accuracy,
                    Altitude = d.Altitude,  
                    BatteryLevel = d.BatteryLevel,
                    Bearing = d.Bearing,
                    CreatedOn = d.CreatedOn,
                    DeletedOn = d.DeletedOn,
                    Id = d.Id,
                    IsNoise = d.IsNoise,
                    Latitude = d.Latitude,
                    Longitude = d.Longitude,
                    Provider = d.Provider,
                    SensoryType = d.SensoryType,
                    UserId = d.UserId,
                    Uuid = d.Uuid,
                })
                .ToListAsync();

            var diffSensors = GetDaySensorGeolocationView(sensors);

            var date = (new DateTime(1970, 1, 1)).AddMilliseconds((double)sensors.First().CreatedOn).AddHours(1);
           
            var d = new DateTime(date.Year, date.Month, date.Day, 0, 0, 0);
            var groupedSensorLocatiosn = new List<GroupedSensorLocations>();
            var fusedSensorLocations = new List<GroupedSensorLocations>();
            var balencedSensorLocations = new List<GroupedSensorLocations>();
            var normalSensorLocations = new List<GroupedSensorLocations>();
            var groupedBatteryLevels = new List<GroupedBatteryDTO>();

            for (var i = 1; i <= 24; i++)
            {
                for(var j=1;j<=60;j++)
                {
                    var start = new DateTimeOffset(d.AddMinutes((i * 60) + (j))).ToUnixTimeMilliseconds();
                    var end = new DateTimeOffset(d.AddMinutes(((i * 60) + (j)) + 5)).ToUnixTimeMilliseconds();
                    var list = sensors.Where(s => s.CreatedOn >= start && s.CreatedOn <= end).ToList();
                    var fusedList = diffSensors[1].Where(s => s.CreatedOn >= start && s.CreatedOn <= end).ToList();
                    var balancedList = diffSensors[2].Where(s => s.CreatedOn >= start && s.CreatedOn <= end).ToList();
                    var normalList = diffSensors[0].Where(s => s.CreatedOn >= start && s.CreatedOn <= end).ToList();

                    var groupedSensorLocation = new GroupedSensorLocations
                    {
                        Count = list.Count,
                        Time = new DateTimeOffset(d.AddMinutes((i * 60) + (j))).ToUnixTimeMilliseconds()
                    };

                    var groupedBatteryLevel = new GroupedBatteryDTO
                    {
                        Time = new DateTimeOffset(d.AddMinutes((i * 60) + (j))).ToUnixTimeMilliseconds(),
                        BatteryLevel = list.Count > 0 ? (int)list.Average(l => l.BatteryLevel) : 0
                    };

                    var normalSensorLocation = new GroupedSensorLocations
                    {
                        Count = normalList.Count,
                        Time = new DateTimeOffset(d.AddMinutes((i * 60) + (j))).ToUnixTimeMilliseconds()
                    };

                    var fusedSensorLocation = new GroupedSensorLocations
                    {
                        Count = fusedList.Count,
                        Time = new DateTimeOffset(d.AddMinutes((i * 60) + (j))).ToUnixTimeMilliseconds()
                    };

                    var balancedSensorLocation = new GroupedSensorLocations
                    {
                        Count = balancedList.Count,
                        Time = new DateTimeOffset(d.AddMinutes((i * 60) + (j))).ToUnixTimeMilliseconds()
                    };

                    if((i != 1 && j != 1) || (i == 24 && j == 60))
                    {
                        if(list.Count > 0)
                        {
                            groupedBatteryLevels.Add(groupedBatteryLevel);
                            groupedSensorLocatiosn.Add(groupedSensorLocation);

                        }

                        if(normalList.Count > 0)
                        {
                            normalSensorLocations.Add(normalSensorLocation);
                        }

                        if(fusedList.Count > 0)
                        {
                            fusedSensorLocations.Add(fusedSensorLocation);
                        }

                        if(balancedList.Count > 0)
                        {
                            balencedSensorLocations.Add(balancedSensorLocation);
                        }
                    }
                }
            }


            var processedDay = new ProcessedDayDTO
            {
                SensorGeolocations = sensors.OrderBy(s => s.CreatedOn).ToList(),
                GroupedSensorLocations = groupedSensorLocatiosn.OrderBy(i => i.Time).ToList(),
                GroupedBatteries = groupedBatteryLevels,
                GroupedNormalSensorLocations = normalSensorLocations,
                GroupedFusedSensorLocations = fusedSensorLocations,
                GroupedBalancedSensorLocations = balencedSensorLocations,
                NormalSensorGeolocations = diffSensors[0],
                FusedSensorGeolocations = diffSensors[1],
                BalancedSensorGeolocations = diffSensors[2]
            };

            return Ok(processedDay);
        }


        [HttpGet]
        public async Task<IActionResult> GetUserSensorGeolocationData()
        {
            var users = await _database.Devices
                .Include(d => d.User)
                .Select(d => new UserSensorGeolocationDataDTO
                {
                    Brand = d.Brand,
                    Model = d.DeviceModel,
                    Sdk = d.SDK,
                    User = d.User.UserName,
                    UserId = d.UserId,
                    SensorCount = _database.SensorGeolocations.Where(s => s.UserId == d.UserId && s.SensoryType != "GeolocatorPlatform").Count().ToString()
                })
                .Where(d => Convert.ToInt32(d.SensorCount) > 200)
                .OrderBy(d => Convert.ToInt32(d.SensorCount))
                .ToListAsync();

            return Ok(users);
        }

        [HttpGet("{userId}")]
        public async Task<IActionResult> GetUserSensorGeolocationDayData(string userId)
        {
            var trackedDays = await _database.TrackedDays.Where(t => t.UserId == userId).ToListAsync();
            var userSensorGeolocationDays = new List<UserSensorGeolocationDayDataDTO>();
            var device = await _database.Devices.FirstOrDefaultAsync(d => d.UserId == userId);
            var sensorCount = await _database.SensorGeolocations.Where(s => s.UserId == userId).CountAsync();

            foreach (var day in trackedDays)
            {
                var date = (new DateTime(1970, 1, 1)).AddMilliseconds((double)day.Day);
                var startTime = new DateTimeOffset(StartOfDay(date)).ToUnixTimeMilliseconds();
                var endTime = new DateTimeOffset(EndOfDay(date)).ToUnixTimeMilliseconds();
                var sensorCountDay = await _database.SensorGeolocations.Where(s => s.UserId == userId && s.CreatedOn > startTime && s.CreatedOn < endTime).CountAsync();
                //var comfirmedClassifiedPeriodsPercentage = classifiedPeriods.Where(g => g.Confirmed == true).Select(g => g.EndDate - g.StartDate).Sum() / 86400000 * 100;
                //var unconfirmedClassifiedPeriodsPercentage = classifiedPeriods.Where(g => g.Confirmed == false).Select(g => g.EndDate - g.StartDate).Sum() / 86400000 * 100;

                day.Validated = sensorCountDay > 0 ? 100 : 0;
                day.Unvalidated = 0; // (int)unconfirmedClassifiedPeriodsPercentage;
                day.Unknown = 0; // 100 - (day.Validated + day.Unvalidated);

                var rawdata = await _database.SensorGeolocations.Where(s => s.UserId == userId && s.CreatedOn > startTime && s.CreatedOn < endTime).ToListAsync();
                var iteratedData = new List<GroupedSensorLocations>();
                var d = new DateTime(date.Year, date.Month, date.Day, 0, 0, 0);

                for (var i = 0;i < 23; i++)
                {
                    var start = new DateTimeOffset(d.AddHours(i)).ToUnixTimeMilliseconds();
                    var end = new DateTimeOffset(d.AddHours(i + 1)).ToUnixTimeMilliseconds();
                    var count = rawdata.Where(s => s.UserId == userId && s.CreatedOn > start && s.CreatedOn < end).Count();
                    var groupedSensorLocation = new GroupedSensorLocations
                    {
                        Count = count,
                        Time = new DateTimeOffset(d.AddHours(i)).ToUnixTimeMilliseconds()
                    };

                    iteratedData.Add(groupedSensorLocation);
                }

              

                userSensorGeolocationDays.Add(new UserSensorGeolocationDayDataDTO
                {
                    Rawdata = rawdata.OrderBy(r => r.CreatedOn).ToList(),
                    TrackedDay = day,
                    TestRawdata = GetTestRawData(rawdata),
                    GroupedRawdata = iteratedData
                });
            }

            var data = new UserSensorGeolocationDataDTO
            {
                Brand = device.Brand,
                Model = device.DeviceModel,
                Sdk = device.SDK,
                User = "",
                UserId = userId,
                SensorCount = "",
                UserTestDaysDataDTO = userSensorGeolocationDays
            };

            return Ok(data);
        }


        private List<List<DaySensorGeolocationView>> GetDaySensorGeolocationView(List<DaySensorGeolocationView> rawData)
        {
            var normal = rawData.Where(r => r.SensoryType == "normal" || r.Provider == "ios" || r.SensoryType == "").OrderBy(r => r.CreatedOn).ToList();
            var fused = rawData.Where(r => r.SensoryType == "fused").OrderBy(r => r.CreatedOn).ToList();
            var balanced = rawData.Where(r => r.SensoryType == "balanced").OrderBy(r => r.CreatedOn).ToList();
            var list = new List<List<DaySensorGeolocationView>>();

            list.Add(normal);
            list.Add(fused);
            list.Add(balanced);

            return list;
        }

        private List<List<SensorGeolocation>> GetTestRawData(List<SensorGeolocation> rawData)
        {
            var normal = rawData.Where(r => r.SensoryType == "normal").OrderBy(r => r.CreatedOn).ToList();
            var fused = rawData.Where(r => r.SensoryType == "fused").OrderBy(r => r.CreatedOn).ToList();
            var balanced = rawData.Where(r => r.SensoryType == "balanced").OrderBy(r => r.CreatedOn).ToList();
            var list = new List<List<SensorGeolocation>>(); 

            list.Add(normal);
            list.Add(fused);
            list.Add(balanced);

            return list;
        }

        private static DateTime EndOfDay(DateTime date)
        {
            return new DateTime(date.Year, date.Month, date.Day, 23, 59, 59, 999);
        }

        private static DateTime StartOfDay(DateTime date)
        {
            return new DateTime(date.Year, date.Month, date.Day, 0, 0, 0, 0);
        }
    }
}
