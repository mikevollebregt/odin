using System.ComponentModel.DataAnnotations;

namespace core_backend.Models
{
    public class ClassifiedPeriod
    {
        [Key]
        public string Uuid { get; set; }
        public string Origin { get; set; }
        public long StartDate { get; set; }
        public long EndDate { get; set; }
        public bool Confirmed { get; set; }
        public long CreatedOn { get; set; }
        public long DeletedOn { get; set; }
        public string UserId { get; set; }
    }
}
