namespace core_backend.Models.DTOs.TrainData
{
    public class TrainRootDTO
    {
        public string Type { get; set; }
        public string Name { get; set; }
        public TrainCrsDTO Crs { get; set; }
        public List<TrainFeatureDTO> Features { get; set; }
    }
}
