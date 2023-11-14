namespace core_backend.Models.DTOs
{
    public class UserSensorGeolocationDataDTO
    {
        public string Sdk { get; set; }
        public string Brand { get; set; }
        public string Model { get; set; }
        public string User { get; set; }
        public string UserId { get; set; }
        public string SensorCount { get; set; }
        public TrackedDay TrackedDay { get; set; }
        public long UserDaySensorCountViewsId { get; set; }

        public List<UserSensorGeolocationDayDataDTO> UserTestDaysDataDTO { get; set; }

    }
}
