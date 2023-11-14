namespace core_backend.Models.DTOs.OSM
{
    public class OSMRoot
    {
        public string Type { get; set; }
        public List<OSMFeature> Features { get; set; }
    }
}
