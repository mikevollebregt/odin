namespace core_backend.Models
{
    public class CSVSensorGeolocation
    {
        public string Id { get; set; }
        public string CreatedAt { get; set; }
        public string UpdatedAt { get; set; }
        public string DeletedAt { get; set; }
        public string ClassifiedPeriodId { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public string Altitude { get; set; }
        public string SensorType { get; set; }
        public string Bearing { get; set; }
        public string Accuracy { get; set; }
        public string Speed { get; set; }
        public string Provider { get; set; }
        public string IsNoise { get; set; }
        public long CreatedOn { get; set; }
        public long DeletedOn { get; set; }
        public string UserId { get; set; }
        public string BatteryLevel { get; set; }
    }
}
