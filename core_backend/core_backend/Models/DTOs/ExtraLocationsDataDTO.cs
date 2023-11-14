namespace core_backend.Models.DTOs
{
    public class ExtraLocationsDataDTO
    {
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public string Station { get; set; }
        public bool TrainRailCloseBy { get; set; }
        public long CreatedOn { get; set; }
    }
}
