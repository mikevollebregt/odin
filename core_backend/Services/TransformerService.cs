using core_backend.Models.DTOs.BicycleData;
using core_backend.Models.DTOs.Transformer;
using Newtonsoft.Json;

namespace core_backend.Services
{
    public class TransformerService
    {
        private readonly IHttpClientFactory _clientFactory;

        public TransformerService(IHttpClientFactory clientFactory)
        {
            _clientFactory = clientFactory;
        }

        public async Task GetTransformedDataSource(string dataSource)
        {
            using (StreamReader r = new StreamReader(dataSource))
            {
                string json = r.ReadToEnd();

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

            }
        }
    }
}
