using core_backend.Services;
using Microsoft.AspNetCore.Mvc;

namespace core_backend.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class GoogleApiController : ControllerBase
    {
        private readonly GoogleMapsService _googleMapsService;

        public GoogleApiController(GoogleMapsService googleMapsService)
        {
            _googleMapsService = googleMapsService;
        }

        [HttpGet]
        public async Task<IActionResult> Test()
        {
            _googleMapsService.GetPlace(0, 0);

            return Ok();
        }
    }
}
