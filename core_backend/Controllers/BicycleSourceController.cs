using core_backend.Models.DTOs.BicycleData;
using core_backend.Models.DTOs.Transformer;
using core_backend.Services;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Text;

namespace core_backend.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class BicycleSourceController : ControllerBase
    {
        private readonly IHttpClientFactory _clientFactory;
        private readonly TransformerService _transformerService;

        public BicycleSourceController(IHttpClientFactory clientFactory, TransformerService transformerService)
        {
            _clientFactory = clientFactory;
            _transformerService = transformerService;   
        }

        //https://www.routedatabank.nl/
        //https://data.overheid.nl/dataset/13161-landelijke-fietsroutes--lf-routes-
        //https://pdok-ngr.readthedocs.io/handleidingen.html#wfs-coordinaten-in-lat-lng

        [HttpGet]
        public async Task<IActionResult> GetPointsOfInterestAsync()
        {
            var request = new HttpRequestMessage(HttpMethod.Get,
                $"https://maps.zaanstad.nl/geoserver/wfs?request=GetFeature&service=WFS&version=1.1.0&outputFormat=json&typeName=geo:fietspaden");

            var client = _clientFactory.CreateClient();
            var response = await client.SendAsync(request);

            if (response.IsSuccessStatusCode)
            {
                var raw = await response.Content.ReadAsStringAsync();

                var convertedResponse = JsonConvert.DeserializeObject<BicycleRootDTO>(raw);

                return Ok();
            }
            else
            {
                throw new Exception("Unable to get points of interest");
            }
        }

        [HttpGet]
        public async Task<IActionResult> GetBicycleInfastructure()
        {
            using (StreamReader r = new StreamReader("DataSources/Fietsnetwerken.json"))
            {
                string json = r.ReadToEnd();
                var convertedResponse = JsonConvert.DeserializeObject<BicycleRootDTO>(json);

                return Ok(convertedResponse);
            }
        }

        [HttpGet]
        public async Task<IActionResult> GetTransformedBicycleInfastructure()
        {
            using (StreamReader r = new StreamReader("DataSources/Fietsnetwerken.json"))
            {
                string json = r.ReadToEnd();
                var convertedResponse = JsonConvert.DeserializeObject<BicycleRootDTO>(json);

                convertedResponse.Features = convertedResponse.Features.Take(100).ToList();

                var test = new TransformCoordinateRootDTO
                {
                    Data = new TransformCoordinateDTO
                    {
                        Type = "MultiPoint",
                        Coordinates = new List<List<double>>
                        {
                            new List<double>
                            {
                                155000.000, 463000.000, 100.000
                            }
                        }
                    }
                };


                var request = new HttpRequestMessage(HttpMethod.Post,
                   $"https://api.transformation.nsgi.nl/v1/transform");
                request.Headers.Add("Accept", "application/json");
                request.Headers.Add("Accept-Crs", "EPSG:7931");
                request.Headers.Add("Content-Crs", "EPSG:7415");
                request.Headers.Add("X-Api-Key", "a9227ffa-872d-48eb-875b-9f0cfacc36bf");
                request.Content = JsonContent.Create(test);
                //request.Content.Headers.Add("Content-Type", "application/json");

                var client = _clientFactory.CreateClient();
                var response = await client.SendAsync(request);

               
                var raw = await response.Content.ReadAsStringAsync();

                var transformedConvertedResponse = JsonConvert.DeserializeObject<BicycleRootDTO>(raw);

                return Ok(transformedConvertedResponse);
               
            }
        }
    }
}
