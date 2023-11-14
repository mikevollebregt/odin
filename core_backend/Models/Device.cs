namespace core_backend.Models
{
    public class Device : BaseModel
    {
        public string Name { get; set; }
        public string Version { get;set; }
        public string Product { get; set; }
        public string DeviceModel { get; set; }
        public string Brand { get; set; }
        public string AndroidId { get; set; }
        public string SecureId { get; set; }
        public string SDK { get; set; }
        public float Width { get; set; }
        public float Height { get; set; }
        public float WidthLogical { get; set; }
        public float HeightLogical { get; set; }
        public string UserId { get; set; }
        public ApplicationUser User { get; set; }
    }
}
