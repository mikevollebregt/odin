namespace core_backend.Models.DTOs.OSM
{
    public class OSMFeature
    {
        public string Type { get; set; }
        public OSMGeometry Geometry { get; set; }
        public OSMProperties Properties { get; set; }
    }
}
