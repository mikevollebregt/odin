using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace core_backend.Models
{
    public class TrackedDay
    {
        [Key]
        public string Uuid { get; set; }
        public long Date { get; set; }
        public long Day { get; set; }
        public bool Confirmed { get; set; }
        public long ChoiceId { get; set; }
        public string ChoiceText { get; set; }
        public string UserId { get; set; }
        [NotMapped]
        public int Validated { get; set; }
        [NotMapped]
        public int Unvalidated { get; set; }
        [NotMapped]
        public int Unknown { get; set; }

    }
}
