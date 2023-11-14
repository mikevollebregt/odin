namespace core_backend.Models
{
    public class GoogleLog : BaseModel
    {
        public bool WasAllowed { get; set; }
        public string Query { get; set; }
        public float Lat { get; set; }
        public float Lon { get; set; }
        public long DateTime { get; set; }
        public string UserId { get; set; }
        public string Request { get; set; }
    }
}
