using core_backend.Models.DTOs.TrainData;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;

namespace core_backend.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class TrainSourceController : ControllerBase
    {
        private readonly IHttpClientFactory _clientFactory;

        public TrainSourceController(IHttpClientFactory clientFactory)
        {
            _clientFactory = clientFactory;
        }

        //https://www.nationaalgeoregister.nl/geonetwork/srv/dut/catalog.search#/metadata/2768fd98-3d2a-4790-886c-7435fc0ad4f6
        //https://app.pdok.nl/viewer/#x=156411.89897172648&y=448826.42851918103&z=4.113037584169272&background=BRT-A%20standaard&layers=f97f50f1-4fe7-47f7-b4a3-1221d8938577;kilometrering,f97f50f1-4fe7-47f7-b4a3-1221d8938577;kruising,f97f50f1-4fe7-47f7-b4a3-1221d8938577;overweg,f97f50f1-4fe7-47f7-b4a3-1221d8938577;spooras,f97f50f1-4fe7-47f7-b4a3-1221d8938577;station,f97f50f1-4fe7-47f7-b4a3-1221d8938577;trace,f97f50f1-4fe7-47f7-b4a3-1221d8938577;wissel

        [HttpGet]
        public async Task<IActionResult> GetPolylineTrainInfrastructure()
        {
            var features = new List<TrainPropertiesDTO>();
            for(var i = 0; i<50; i++)
            {
                var request = new HttpRequestMessage(HttpMethod.Get,
                $"https://service.pdok.nl/prorail/spoorwegen/wfs/v1_0?request=GetFeature&service=WFS&version=1.1.0&outputFormat=application%2Fjson&typeName=kilometrering&startindex={i * 1000}");

                var client = _clientFactory.CreateClient();
                var response = await client.SendAsync(request);

                if (response.IsSuccessStatusCode)
                {
                    var raw = await response.Content.ReadAsStringAsync();

                    var convertedResponse = JsonConvert.DeserializeObject<TrainRootDTO>(raw);

                    if(convertedResponse != null)
                    {
                        var featureCluster = convertedResponse.Features.Select(f => f.Properties).ToList();

                        if(featureCluster != null)
                        {
                            features.AddRange(featureCluster);
                        }
                    }
                }
                else
                {
                    throw new Exception("Unable to get points of interest");
                }
            }
            

            return Ok(features);
        }

        [HttpGet]
        public async Task<IActionResult> GetStationTrainInfrastructure()
        {
            var features = new List<TrainPropertiesDTO>();
            for (var i = 0; i < 50; i++)
            {
                var request = new HttpRequestMessage(HttpMethod.Get,
                $"https://service.pdok.nl/prorail/spoorwegen/wfs/v1_0?request=GetFeature&service=WFS&version=1.1.0&outputFormat=application%2Fjson&typeName=station&startindex={i * 1000}");

                var client = _clientFactory.CreateClient();
                var response = await client.SendAsync(request);

                if (response.IsSuccessStatusCode)
                {
                    var raw = await response.Content.ReadAsStringAsync();

                    var convertedResponse = JsonConvert.DeserializeObject<TrainRootDTO>(raw);

                    if (convertedResponse != null)
                    {
                        var featureCluster = convertedResponse.Features.Select(f => f.Properties).ToList();

                        if (featureCluster != null)
                        {
                            features.AddRange(featureCluster);
                        }
                    }
                }
                else
                {
                    throw new Exception("Unable to get points of interest");
                }
            }


            return Ok(features);
        }
    }
}
