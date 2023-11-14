namespace core_backend.Models.DTOs
{
    public class VehicleClusterDTO
    {
        public List<SensorGeolocation> Locations { get; set; }
        public int AverageSpeed { get; set; }
        public int AmountOfTime { get; set; }
        public int AmountOfPoints { get; set; }
        public int MaxSpeed { get; set; }
    }
}
