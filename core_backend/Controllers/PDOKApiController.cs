using core_backend.Services;
using Microsoft.AspNetCore.Mvc;

namespace core_backend.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class PDOKApiController : ControllerBase
    {
        private readonly PDOKService _pdokService;

        public PDOKApiController(PDOKService pdokService)
        {
            _pdokService = pdokService;
        }

        [HttpGet("{lat}/{lon}/{distance}")]
        public async Task<IActionResult> GetPointsOfInterest(double lat, double lon, int distance)
        {
            var response = await _pdokService.GetPointsOfInterestAsync(lat, lon, distance);

            return Ok(response);
        }
    }
}
