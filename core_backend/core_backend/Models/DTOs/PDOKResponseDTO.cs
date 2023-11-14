using Newtonsoft.Json;
using System.Text.Json.Serialization;

namespace core_backend.Models.DTOs
{
    public class PDOKResponseDTO
    {
        [JsonProperty(PropertyName = "numFound")]
        public int NumFound { get; set; }
        [JsonProperty(PropertyName = "start")]
        public int Start { get; set; }
        [JsonProperty(PropertyName = "maxScore")]
        public double MaxScore { get; set; }
        [JsonProperty(PropertyName = "numFoundExact")]
        public bool NumFoundExact { get; set; }
        [JsonProperty(PropertyName = "docs")]
        public List<PDOKLocationDTO> Docs { get; set; }
    }
}
