namespace core_backend.Models.DTOs.TrainData
{
    public class TrainFeatureDTO
    {
        public string Type { get; set; }
        public string Id { get; set; }
        public TrainPropertiesDTO Properties { get; set; }
        public TrainGeometryDTO Geometry { get; set; }

    }
}
