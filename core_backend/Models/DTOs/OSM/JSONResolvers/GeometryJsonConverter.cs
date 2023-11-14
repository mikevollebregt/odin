using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace core_backend.Models.DTOs.OSM.JSONResolvers
{
    public class GeometryJsonConverter : JsonConverter
    {
        public override bool CanConvert(Type objectType)
        {
            return objectType == typeof(OSMGeometry);
        }

        public override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
        {
            var obj = JObject.Load(reader);
            var info = new OSMGeometry();


            info.Type = obj["type"].ToObject<string>(serializer);
            if(info.Type == "Point")
            {
                info.Coordinates = new List<List<double>> { obj["coordinates"].ToObject<List<double>>(serializer) };
            } else if(info.Type == "LineString")
            {
                info.Coordinates = obj["coordinates"].ToObject<List<List<double>>>(serializer);
            } else if(info.Type == "MultiPolygon")
            {
                info.Coordinates = obj["coordinates"].ToObject<List<List<List<List<double>>>>>(serializer).First().First();
            } else
            {
                var i = 0;
            }
               

            return info;
        }

        public override void WriteJson(JsonWriter writer, object? value, JsonSerializer serializer)
        {
            throw new NotImplementedException();
        }
    }
}
