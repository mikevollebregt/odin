using core_backend.Models.DTOs.BicycleData;
using core_backend.Services;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;

namespace core_backend.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class WalkingSourceController : ControllerBase
    {
        private readonly IHttpClientFactory _clientFactory;
        private readonly TransformerService _transformerService;

        public WalkingSourceController(IHttpClientFactory clientFactory, TransformerService transformerService)
        {
            _clientFactory = clientFactory;
            _transformerService = transformerService;
        }

        [HttpGet]
        public async Task<IActionResult> GetBicycleInfastructure()
        {
            using (StreamReader r = new StreamReader("DataSources/Wandelnetwerken.json"))
            {
                string json = r.ReadToEnd();
                var convertedResponse = JsonConvert.DeserializeObject<BicycleRootDTO>(json);

                return Ok(convertedResponse);
            }
        }
    }
}
