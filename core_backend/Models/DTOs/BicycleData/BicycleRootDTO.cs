namespace core_backend.Models.DTOs.BicycleData
{
    public class BicycleRootDTO
    {
        public string Type { get; set; }
        public List<BicycleFeatureDTO> Features { get; set; }
    }
}
