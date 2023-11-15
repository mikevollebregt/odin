using core_backend.Models.DTOs.OSM;
using Microsoft.EntityFrameworkCore;

namespace core_backend.Models
{
    [Index(nameof(Latitude), nameof(Longitude))]
    public class TrainRailCoordinate : OSMVehicleCoordinate
    {
        public long Id { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
    }
}
