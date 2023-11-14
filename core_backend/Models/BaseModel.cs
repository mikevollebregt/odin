using core_backend.Helpers;
using Newtonsoft.Json;

namespace core_backend.Models
{
    public class BaseModel
    {
        public long Id { get; set; }
        [JsonConverter(typeof(DateFormatConverter), "yyyy-MM-dd HH:mm:ss")]
        public DateTime Created { get; set; }
        [JsonConverter(typeof(DateFormatConverter), "yyyy-MM-dd HH:mm:ss")]
        public DateTime? Updated { get; set; }
        [JsonConverter(typeof(DateFormatConverter), "yyyy-MM-dd HH:mm:ss")]
        public DateTime? Deleted { get; set; }
    }
}
