using core_backend.Services;
using Microsoft.AspNetCore.Mvc;

namespace core_backend.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class TramSourceController : ControllerBase
    {
        private readonly IHttpClientFactory _clientFactory;
        private readonly TransformerService _transformerService;


        //https://www.openov.nl/

        public TramSourceController(IHttpClientFactory clientFactory, TransformerService transformerService)
        {
            _clientFactory = clientFactory;
            _transformerService = transformerService;
        }

        [HttpGet]
        public async Task<IActionResult> GeTramInfastructure()
        {
            return Ok();
        }
    }
}
