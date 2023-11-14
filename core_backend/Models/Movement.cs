using System.ComponentModel.DataAnnotations;

namespace core_backend.Models
{
    public class Movement
    {
        [Key]
        public string Uuid { get; set; }
        public string ClassifiedPeriodUuid { get; set; }
        public long VehicleId { get; set; }
        public string UserId { get; set; }
    }
}
