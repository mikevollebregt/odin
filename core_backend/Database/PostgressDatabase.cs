using core_backend.Models;
using core_backend.Models.Views;
using Duende.IdentityServer.EntityFramework.Options;
using Microsoft.AspNetCore.ApiAuthorization.IdentityServer;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace core_backend.Database
{
    public class PostgressDatabase : ApiAuthorizationDbContext<ApplicationUser>
    {
        public PostgressDatabase(DbContextOptions<PostgressDatabase> options, IOptions<OperationalStoreOptions> operationalStoreOptions)
            : base(options, operationalStoreOptions)
        {
            Database.SetCommandTimeout(0);
        }

        //CSV stuff
        public DbSet<CSVSensorGeolocation> CSVSensorGeolocations { get; set; }

        //Logs
        public DbSet<ErrorLog> ErrorLogs { get; set; }

        //Odin data
        public DbSet<ClassifiedPeriod> ClassifiedPeriods { get; set; }
        public DbSet<Stop> Stops { get; set; }
        public DbSet<Movement> Movements { get; set; }
        public DbSet<Vehicle> Vehicles { get; set; }
        public DbSet<Reason> Reasons { get; set; }
        public DbSet<ManualGeolocation> ManualGeolocations { get; set; }
        public DbSet<SensorGeolocation> SensorGeolocations { get; set; }
        public DbSet<TrackedDay> TrackedDays { get; set; }
        public DbSet<Device> Devices { get; set; }
        public DbSet<Questionnaire> Questionnaires { get; set; }

        //Google
        public DbSet<GoogleErrorLog> GoogleErrorLogs { get; set; }
        public DbSet<GoogleLog> GoogleLogs { get; set; }
        public DbSet<GoogleMapsData> GoogleMapsDatas { get; set; }

        //Views
        public DbSet<DaySensorGeolocationView> DaySensorGeolocationViews { get; set; }
        public DbSet<UserDaySensorCountView> UserDaySensorCountViews { get; set; }

        // transportCoordinates
        public DbSet<TrainRailCoordinate> TrainRailCoordinates { get; set; }
        public DbSet<SubwayRailCoordinate> SubwayRailCoordinates { get; set; }
        public DbSet<TramRailwayCoordinate> TramRailCoordinates { get; set; }
        public DbSet<CarRoadCoordinate> CarRoadCoordinates { get; set; }
        public DbSet<BusLineCoordinate> BusLineCoordinates { get; set; }
        public DbSet<WalkingPathCoordinate> WalkingPathCoordinates { get; set; }
        public DbSet<BicycleRoadsCoordinate> BicycleRoadsCoordinates { get; set; }
        public DbSet<TrainStop> TrainStops { get; set; }
    }
}
