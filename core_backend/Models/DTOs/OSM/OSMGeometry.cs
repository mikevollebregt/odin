using core_backend.Models.DTOs.OSM.JSONResolvers;
using Newtonsoft.Json;

namespace core_backend.Models.DTOs.OSM
{
    [JsonConverter(typeof(GeometryJsonConverter))]
    public class OSMGeometry
    {
        public string Type { get; set; }
        public List<List<double>> Coordinates { get; set; }
    }
}
