using System.ComponentModel.DataAnnotations;

namespace core_backend.Models
{
    public class GoogleMapsData
    {
        [Key]
        public string Uuid { get; set; }
        public string GoogleId { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string Postcode { get; set; }
        public string Country { get; set; }
        public string Name { get; set; }
        public string UserId { get; set; }
    }
}
