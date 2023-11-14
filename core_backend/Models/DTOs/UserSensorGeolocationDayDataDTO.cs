namespace core_backend.Models.DTOs
{
    public class UserSensorGeolocationDayDataDTO
    {
        public List<SensorGeolocation> Rawdata { get; set; }
        public List<List<SensorGeolocation>> TestRawdata { get; set; }
        public TrackedDay TrackedDay { get; set; }
        public List<GroupedSensorLocations> GroupedRawdata { get; set; }
    }
}
