namespace core_backend.Models
{
    public class Vehicle : BaseModel
    {
        public string Name { get; set; }
        public string Icon { get;set; }
        public string HexColor { get; set; }
        public string Key { get; set; }
    }
}
