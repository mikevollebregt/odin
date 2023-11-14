using core_backend.Models;
using core_backend.Repositories;
using core_backend.Services;
using Microsoft.AspNetCore.Mvc;

namespace core_backend.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class MovementController : ControllerBase
    {
        private readonly UserService _userService;
        private readonly IRepository<Movement> _movementRepository;

        public MovementController(UserService userService, IRepository<Movement> movementRepository)
        {
            _userService = userService;
            _movementRepository = movementRepository;
        }

        [HttpPost]
        public async Task<IActionResult> Upsert([FromBody] Movement movement)
        {
            var user = await _userService.GetLoggedInUser();
            movement.UserId = user.Id;

            var oldStop = await _movementRepository.FindByAsync(s => s.Uuid == movement.Uuid);

            if (oldStop == null)
            {
                await _movementRepository.AddAsync(movement);
            }
            else
            {
                await _movementRepository.UpdateAsync(movement);
            }

            return Ok(movement);
        }
    }
}
