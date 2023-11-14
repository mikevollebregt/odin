using Newtonsoft.Json;

namespace core_backend.Models.DTOs
{
    public class ErrorDetailsDTO
    {
        public int Id { get; set; }
        public int StatusCode { get; set; }
        public string Message { get; set; }
        public Type TypeException { get; set; }

        public override string ToString()
        {
            return JsonConvert.SerializeObject(this);
        }
    }
}
