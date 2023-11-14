using System.ComponentModel.DataAnnotations;

namespace core_backend.Models
{
    public class SensorGeolocation
    {
        [Key]
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
