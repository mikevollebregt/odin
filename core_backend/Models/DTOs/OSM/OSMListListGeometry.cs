namespace core_backend.Models.DTOs.OSM
{
    public class OSMListListGeometry
    {
        public string Type { get; set; }
        public List<List<double>> Coordinates { get; set; }
    }
}
