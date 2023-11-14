using core_backend.Models.Views;

namespace core_backend.Models.DTOs
{
    public class ProcessedDayDTO
    {
        public List<DaySensorGeolocationView> SensorGeolocations { get; set; }
        public List<DaySensorGeolocationView> FusedSensorGeolocations { get; set; }
        public List<DaySensorGeolocationView> BalancedSensorGeolocations { get; set; }
        public List<DaySensorGeolocationView> NormalSensorGeolocations { get; set; }
        public List<GroupedSensorLocations> GroupedSensorLocations { get; set; }
        public List<GroupedBatteryDTO> GroupedBatteries { get; set; }
        public List<GroupedSensorLocations> GroupedFusedSensorLocations { get; set; }
        public List<GroupedSensorLocations> GroupedBalancedSensorLocations { get; set; }
        public List<GroupedSensorLocations> GroupedNormalSensorLocations { get; set; }
        public TrackedDay TrackedDay { get; set; }
    }
}
