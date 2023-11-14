using Microsoft.AspNetCore.Identity;

namespace core_backend.Models
{
    public class ApplicationUser : IdentityUser
    {
        public long Attempts { get; set; }
        public DateTime LastAttempt { get; set; }
        public Device Device { get; set; }
        
    }
}