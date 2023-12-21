using core_backend.Data;
using core_backend.Database;
using core_backend.Middlewares;
using core_backend.Models;
using core_backend.Repositories;
using core_backend.Services;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Infrastructure;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;

namespace core_backend
{
    public class Startup
    {
        public IConfiguration Configuration { get; }

        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public void ConfigureServices(IServiceCollection services)
        {
            // Add services to the container.
            var connectionPostgressString = Configuration.GetConnectionString("PostgressConnection");
            //var connectionSQLString = Configuration.GetConnectionString("DefaultConnection");
            //services.AddDbContext<ApplicationDbContext>(options =>
            //    options.UseSqlServer(connectionString));

            services.AddDbContext<PostgressDatabase>(options =>
                options.UseNpgsql(connectionPostgressString));

            //services.AddDbContext<ApplicationDbContext>(options =>
            //    options.UseSqlServer(connectionSQLString));

            services.AddDatabaseDeveloperPageExceptionFilter();

            services.AddDefaultIdentity<ApplicationUser>(options => options.SignIn.RequireConfirmedAccount = true)
                .AddEntityFrameworkStores<PostgressDatabase>();

            //services.AddDbContext<KataskoposDbContext>(options =>
            //    options.UseSqlServer(
            //        Configuration.GetConnectionString("KataskoposConnection")), ServiceLifetime.Transient);


            services.AddIdentityServer()
                .AddApiAuthorization<ApplicationUser, PostgressDatabase>();

            services.AddAuthentication()
                .AddIdentityServerJwt();

            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new OpenApiInfo());
            });

            //Response wrapper
            services.AddScoped<IActionResultExecutor<ObjectResult>, ResponseEnvelopeResultExecutor>();

            //Generic
            services.AddScoped(typeof(IRepository<>), typeof(Repository<>));

            //Services
            services.AddScoped<ErrorService>();
            services.AddScoped<LogService>();
            services.AddScoped<UserService>();
            services.AddScoped<GoogleMapsService>();
            services.AddScoped<PDOKService>();
            services.AddScoped<TransformerService>();
            services.AddScoped<ExcelService>();
        }


        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env, IServiceProvider serviceProvider, PostgressDatabase dbContext)
        {
            dbContext.Database.Migrate();

            app.UseMiddleware<ExceptionMiddleware>();

            app.UseSwaggerUI(c =>
            {
                c.SwaggerEndpoint("/swagger/v1/swagger.json", "Server");
            });
            app.UseSwagger();

            app.UseHttpsRedirection();
            app.UseStaticFiles();
            app.UseRouting();

            app.UseAuthentication();
            app.UseIdentityServer();
            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllerRoute(
                    name: "default",
                    pattern: "{controller}/{action=Index}/{id?}");
                endpoints.MapRazorPages();
            });

        }
    }
}
