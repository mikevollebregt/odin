namespace core_backend.Models.Views
{
    public class DaySensorGeolocationView
    {
        public long Id { get; set; }
        public UserDaySensorCountView UserDaySensorCountView { get; set; }
        public long UserDaySensorCountViewId { get; set; }
        public string Uuid { get; set; }
        public float Latitude { get; set; }
        public float Longitude { get; set; }
        public float Altitude { get; set; }
        public float Bearing { get; set; }
        public float Accuracy { get; set; }
        public string SensoryType { get; set; }
        public string Provider { get; set; }
        public bool IsNoise { get; set; }
        public long CreatedOn { get; set; }
        public long? DeletedOn { get; set; }
        public long BatteryLevel { get; set; }
        public string UserId { get; set; }

    }
}
