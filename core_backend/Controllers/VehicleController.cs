using core_backend.Models;
using core_backend.Repositories;
using Microsoft.AspNetCore.Mvc;

namespace core_backend.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class VehicleController : ControllerBase
    {
        private readonly IRepository<Vehicle> _vehicleRepository;

        public VehicleController(IRepository<Vehicle> vehicleRepository)
        {
            _vehicleRepository = vehicleRepository;
        }

        [HttpGet]
        public async Task<IActionResult> GetTransports()
        {
            var vehicles = await _vehicleRepository.GetAllAsync();

            return Ok(vehicles);
        }
    }
}
