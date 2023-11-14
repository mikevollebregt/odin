using System.ComponentModel.DataAnnotations;

namespace core_backend.Models
{
    public class Stop
    {
        [Key]
        public string Uuid { get; set; }
        public string ClassifiedPeriodUuid { get; set; }
        public long ReasonId { get; set; }
        public string GoogleMapsDataUuid { get; set; }
        public string UserId { get; set; }
    }
}
