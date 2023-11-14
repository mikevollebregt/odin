using core_backend.Models;
using core_backend.Repositories;
using core_backend.Services;
using Microsoft.AspNetCore.Mvc;

namespace core_backend.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class GoogleMapsDataController : ControllerBase
    {
        private readonly UserService _userService;
        private readonly IRepository<GoogleMapsData> _googleMapsDataRepository;

        public GoogleMapsDataController(UserService userService, IRepository<GoogleMapsData> googleMapsDataRepository)
        {
            _userService = userService;
            _googleMapsDataRepository = googleMapsDataRepository;
        }

        [HttpPost]
        public async Task<IActionResult> Upsert([FromBody] GoogleMapsData googleMapsData)
        {
            var user = await _userService.GetLoggedInUser();
            googleMapsData.UserId = user.Id;

            var oldStop = await _googleMapsDataRepository.FindByAsync(s => s.Uuid == googleMapsData.Uuid);

            if (oldStop == null)
            {
                await _googleMapsDataRepository.AddAsync(googleMapsData);
            }
            else
            {
                await _googleMapsDataRepository.UpdateAsync(googleMapsData);
            }

            return Ok(googleMapsData);
        }
    }
}
