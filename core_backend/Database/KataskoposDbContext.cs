using Duende.IdentityServer.EntityFramework.Options;
using KataskoposServer.Models;
using Microsoft.AspNetCore.ApiAuthorization.IdentityServer;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace core_backend.Database
{
    public class KataskoposDbContext : ApiAuthorizationDbContext<IdentityUser>
    {
        public KataskoposDbContext(
            DbContextOptions<KataskoposDbContext> options,
            IOptions<OperationalStoreOptions> operationalStoreOptions) : base(options, operationalStoreOptions)
        {
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
        }


        //Odin
        public DbSet<SensorGeolocation> SensorGeolocations { get; set; }

    }
}
