namespace core_backend.Models.DTOs.BicycleData
{
    public class BicycleGeometryDTO
    {
        public string type { get; set; }
        public List<List<List<double>>> Coordinates { get; set; }
    }
}
