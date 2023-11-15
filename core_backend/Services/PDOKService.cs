using core_backend.Models.DTOs;
using Newtonsoft.Json;

namespace core_backend.Services
{
    public class PDOKService
    {
        //https://github.com/PDOK/locatieserver/wiki/API-Locatieserver
        private readonly IHttpClientFactory _clientFactory;

        public PDOKService(IHttpClientFactory clientFactory)
        {
            _clientFactory = clientFactory;
        }

        public async Task<PDOKResponseDTO> GetPointsOfInterestAsync(double lat, double lon, int distance)
        {
            var request = new HttpRequestMessage(HttpMethod.Get,
                $"https://api.pdok.nl/bzk/locatieserver/search/v3_1/reverse?lat={lat}&lon={lon}&distance={distance}&type=*");

            var client = _clientFactory.CreateClient();
            var response = await client.SendAsync(request);

            if (response.IsSuccessStatusCode)
            {
                var raw = await response.Content.ReadAsStringAsync();

                var convertedResponse = JsonConvert.DeserializeObject<PDOKRootResponseDTO>(raw);

                return convertedResponse.Response;
            }
            else
            {
                throw new Exception("Unable to get points of interest");
            }
        }
    }
}
