using core_backend.Models;
using core_backend.Repositories;
using Microsoft.AspNetCore.Mvc;

namespace core_backend.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class ReasonController : ControllerBase
    {
        private readonly IRepository<Reason> _reasonRepository;

        public ReasonController(IRepository<Reason> reasonRepository)
        {
            _reasonRepository = reasonRepository;
        }

        [HttpGet]
        public async Task<IActionResult> GetReasons()
        {
            var reasons = await _reasonRepository.GetAllAsync();

            return Ok(reasons);
        }
    }
}
