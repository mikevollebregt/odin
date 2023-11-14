namespace core_backend.Models.DTOs.Transformer
{
    public class TransformCoordinateDTO
    {
        public string Type { get; set; }
        public List<List<double>> Coordinates { get; set; }
    }
}
