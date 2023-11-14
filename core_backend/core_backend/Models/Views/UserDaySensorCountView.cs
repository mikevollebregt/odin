namespace core_backend.Models.Views
{
    public class UserDaySensorCountView
    {
        public long Id { get; set; }
        public string UserId { get; set; }
        public ApplicationUser User { get; set; }
        public int SensorCount { get; set; }
        public string? TrackedDayId { get; set; }
        public TrackedDay? TrackedDay { get; set; }
        public List<DaySensorGeolocationView> DaySensorGeolocationViews { get; set; }
    }
}
