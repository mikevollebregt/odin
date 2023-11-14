namespace core_backend.Models.DTOs.BicycleData
{
    public class BicycleFeatureDTO
    {
        public string Type { get; set; }
        public string Id { get; set; }
        public BicycleGeometryDTO Geometry { get; set; }

        public BicyclePropertiesDTO Properties { get; set; }
    }
}
