using core_backend.Models;
using core_backend.Repositories;
using core_backend.Services;
using Microsoft.AspNetCore.Mvc;

namespace core_backend.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class StopController : ControllerBase
    {
        private readonly UserService _userService;
        private readonly IRepository<Stop> _stopRepository;

        public StopController(UserService userService, IRepository<Stop> stopRepository) { 
            _userService = userService;
            _stopRepository = stopRepository;
        }

        [HttpPost]
        public async Task<IActionResult> Upsert([FromBody] Stop stop)
        {
            var user = await _userService.GetLoggedInUser();
            stop.UserId = user.Id;

            var oldStop = await _stopRepository.FindByAsync(s => s.Uuid == stop.Uuid);

            if(oldStop == null)
            {
                await _stopRepository.AddAsync(stop);
            } else
            {
                await _stopRepository.UpdateAsync(stop);
            }

            return Ok(stop);
        }
    }
}
