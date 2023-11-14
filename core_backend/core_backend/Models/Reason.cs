namespace core_backend.Models
{
    public class Reason : BaseModel
    {
        public string Name { get; set; }
        public string Icon { get; set; }
        public string Color { get; set; }
        public string Key { get; set; }
    }
}
