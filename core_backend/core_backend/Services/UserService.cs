using core_backend.Data;
using core_backend.Exceptions;
using core_backend.Models;
using core_backend.Repositories;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace core_backend.Services
{
    public class UserService
    {
        private readonly ApplicationDbContext _database;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly IRepository<ApplicationUser> _userRepository;
        private readonly ClaimsPrincipal caller;

        public UserService(ApplicationDbContext database, UserManager<ApplicationUser> userManager, IHttpContextAccessor httpContextAccessor, IRepository<ApplicationUser> userRepository)
        {
            caller = httpContextAccessor.HttpContext?.User;
            _userManager = userManager;
            _database = database;
            _userRepository = userRepository;
        }

        public async Task<ApplicationUser> GetLoggedInUser(ClaimsPrincipal principle)
        {
            var appUser = await _userManager.GetUserAsync(principle);
            if (appUser == null)
            {
                throw new Exception();
            }

            return await _database.Users.FirstAsync(u => u.Id == appUser.Id);
        }

        public async Task<ApplicationUser> GetUserByEmailAsync(string email)
        {
            var appUser = await _database.Users.FirstOrDefaultAsync(u => u.UserName == email);
            if (appUser is null)
            {
                throw new Exception();
            }

            return appUser;
        }

        public async Task<ApplicationUser> GetLoggedInUser()
        {
            var test = caller.Claims.ToList();

            if(test.Count() == 0)
            {
                return null;
            }

            var userId = caller.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier)?.Value;

            if (userId == null)
            {
                throw new ResponseException("NullReferenceClaimException", "Unable to get claim from context", 500);
            }

            var appUser = await _userManager.FindByIdAsync(userId);
            if (appUser == null)
            {
                throw new ResponseException("NullReferenceAppUserException", "Unable to get appUser from userId", 500);
            }

            var user = await _userRepository.FindByAsync(u => u.Id == appUser.Id);
            if (user == null)
            {
                throw new ResponseException("NullReferenceUserException", "Unable to get user from appUser", 500);
            }

            return user;
        }
    }
}
