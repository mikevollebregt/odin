using GoogleMaps.LocationServices;

namespace core_backend.Services
{
    public class GoogleMapsService
    {
        //https://developers.google.com/maps/documentation/places/web-service/details

        public int GetPlace(double lat, double lon)
        {
            var gls = new GoogleLocationService(apikey: "");

            var data = gls.GetAddressFromLatLang(50.97541, 5.979837);

            return 0;
        }

    }

}
