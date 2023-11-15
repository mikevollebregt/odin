namespace core_backend.Models.DTOs.OSM
{
    public class OSMStationCoordinate
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
    }
}
