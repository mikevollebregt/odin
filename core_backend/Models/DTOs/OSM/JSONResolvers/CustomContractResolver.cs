using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System.Reflection;

namespace core_backend.Models.DTOs.OSM.JSONResolvers
{
    public class CustomContractResolver : DefaultContractResolver
    {
        private Dictionary<string, string> PropertyMappings { get; set; }

        public CustomContractResolver()
        {
            this.PropertyMappings = new Dictionary<string, string>
        {
            {"Coordinates", "Coordinates"},
        };
        }

        protected override string ResolvePropertyName(string propertyName)
        {
            string resolvedName = null;
            var resolved = this.PropertyMappings.TryGetValue(propertyName, out resolvedName);
            return (resolved) ? resolvedName : base.ResolvePropertyName(propertyName);
        }

        public override JsonContract ResolveContract(Type type)
        {
            var contract = base.ResolveContract(type);
            //if (contract.Converter == null && type.IsGenericType && type.GetGenericTypeDefinition() == typeof(List<>) && type.GetGenericArguments()[0] == typeof(double))
            //{
            //    // This may look fancy but it's just calling GetOptionalJsonConverter<T> with the correct T
            //    var optionalValueType = type.GetGenericArguments()[0];
            //    var genericMethod = this.GetAndMakeGenericMethod("GetOptionalJsonConverter", optionalValueType);
            //    var converter = (JsonConverter)genericMethod.Invoke(null, null);
            //    // Set the converter for the type
            //    contract.Converter = converter;
            //}
            return contract;
        }

        protected override JsonProperty CreateProperty(MemberInfo member, MemberSerialization memberSerialization)
        {
            var jsonProperty = base.CreateProperty(member, memberSerialization);
            var type = jsonProperty.PropertyType;
            //if (type.IsGenericType && type.GetGenericTypeDefinition() == typeof(List<>) && type.GetGenericArguments()[0] == typeof(double))
            //{
            //    // This may look fancy but it's just calling SetJsonPropertyValuesForOptionalMember<T> with the correct T
            //    var optionalValueType = type.GetGenericArguments()[0];
            //    var genericMethod = this.GetAndMakeGenericMethod("SetJsonPropertyValuesForOptionalMember", optionalValueType);
            //    genericMethod.Invoke(null, new object[] { member.Name, jsonProperty });
            //}
            return jsonProperty;
        }

        
    }
}
