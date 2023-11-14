namespace core_backend.Models
{
    public class GoogleErrorLog : BaseModel
    {
        public string UserId { get; set; }
        public string ErrorMessage { get; set; }
    }
}
