namespace core_backend.Models
{
    public class ErrorLog : BaseModel
    {
        public ErrorLog() { }

        public string StackTrace { get; set; }
        public string Message { get; set; }
        public string InnerException { get; set; }
        public string Body { get; set; }
        public int StatusCode { get; set; }
        public DateTime DateTime { get; set; }
        public string TypeException { get; set; }
        public string UserId { get; set; }
    }
}
