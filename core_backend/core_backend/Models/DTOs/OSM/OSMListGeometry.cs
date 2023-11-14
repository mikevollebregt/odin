namespace core_backend.Models.DTOs.OSM
{
    public class OSMListGeometry
    {
        public string Type { get; set; }
        public List<double> Coordinates { get; set; }
    }
}
