namespace core_backend.Models.DTOs
{
    public class PDOKLocationDTO
    {
        public string Type { get; set; }
        public string Weergavenaam { get; set; }
        public string Id { get; set; }
        public double Score { get; set; }
        public double Afstand { get; set; }
    }
}
