using System.ComponentModel.DataAnnotations;

namespace core_backend.Models
{
    public class ManualGeolocation
    {
        [Key]
        public string Uuid { get; set; }
        public string ClassifiedPeriodUuid { get; set; }
        public float Latitude { get; set; }
        public float Longitude { get; set; }
        public long CreatedOn { get; set; }
        public long DeletedOn { get; set; }
        public string UserId { get; set; }
    }
}
