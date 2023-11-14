using core_backend.Models;
using Microsoft.AspNetCore.Identity;
using System;

namespace KataskoposServer.Models
{
    public class OdinUser : IdentityUser
    {
        public long Attempts { get; set; }
        public DateTime LastAttempt { get; set; }
        public Device Device { get; set; }
    }
}
