namespace core_backend.Models.DTOs.OSM
{
    public class OSMCoordinatesDTO
    {
        public List<OSMVehicleCoordinate> Coordinates { get; set; }
        public List<OSMStationCoordinate> Stations { get; set; }
    }
}
