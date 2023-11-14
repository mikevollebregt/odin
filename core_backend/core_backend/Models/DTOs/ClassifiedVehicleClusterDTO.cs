namespace core_backend.Models.DTOs
{
    public class ClassifiedVehicleClusterDTO
    {
        public List<ProbableTransportDTO> ProbableTransports { get; set; }
        public List<ExtraLocationsDataDTO> ExtraLocationsDataDTOs { get; set; }
        public List<ExtraLocationsDataDTO> TrainStopsDTOs { get; set; }
    }
}
