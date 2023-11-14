using Newtonsoft.Json;

namespace core_backend.Models.DTOs.OSM
{
    public class OSMProperties
    {
        [JsonProperty("crossing:activation")]
        public string crossingactivation { get; set; }

        [JsonProperty("crossing:barrier")]
        public string crossingbarrier { get; set; }

        [JsonProperty("crossing:bell")]
        public string crossingbell { get; set; }

        [JsonProperty("crossing:light")]
        public string crossinglight { get; set; }

        [JsonProperty("crossing:saltire")]
        public string crossingsaltire { get; set; }
        public string railway { get; set; }
        public string supervised { get; set; }
        public string highway { get; set; }
        public string name { get; set; }
        public string @ref { get; set; }
        public string created_by { get; set; }
        public string noref { get; set; }
        public string traffic_sign { get; set; }
        public string expected_rwn_route_relations { get; set; }

        [JsonProperty("network:type")]
        public string networktype { get; set; }
        public string rwn_ref { get; set; }

        [JsonProperty("TMC:cid_58:tabcd_1:Class")]
        public string TMCcid_58tabcd_1Class { get; set; }

        [JsonProperty("TMC:cid_58:tabcd_1:LCLversion")]
        public string TMCcid_58tabcd_1LCLversion { get; set; }

        [JsonProperty("TMC:cid_58:tabcd_1:LocationCode")]
        public string TMCcid_58tabcd_1LocationCode { get; set; }

        [JsonProperty("TMC:cid_58:tabcd_1:NextLocationCode")]
        public string TMCcid_58tabcd_1NextLocationCode { get; set; }
        public string capital { get; set; }

        [JsonProperty("name:ar")]
        public string namear { get; set; }

        [JsonProperty("name:carnaval")]
        public string namecarnaval { get; set; }

        [JsonProperty("name:de")]
        public string namede { get; set; }

        [JsonProperty("name:en")]
        public string nameen { get; set; }

        [JsonProperty("name:es")]
        public string namees { get; set; }

        [JsonProperty("name:fr")]
        public string namefr { get; set; }

        [JsonProperty("name:ja")]
        public string nameja { get; set; }

        [JsonProperty("name:nl")]
        public string namenl { get; set; }

        [JsonProperty("name:ru")]
        public string nameru { get; set; }

        [JsonProperty("name:sr")]
        public string namesr { get; set; }

        [JsonProperty("name:zh-Hans")]
        public string namezhHans { get; set; }

        [JsonProperty("name:zh-Hant")]
        public string namezhHant { get; set; }
        public string place { get; set; }
        public string population { get; set; }

        [JsonProperty("population:date")]
        public string populationdate { get; set; }

        [JsonProperty("population:note")]
        public string populationnote { get; set; }

        [JsonProperty("source:population")]
        public string sourcepopulation { get; set; }
        public string wikidata { get; set; }
        public string wikipedia { get; set; }
        public string amenity { get; set; }
        public string information { get; set; }
        public string tourism { get; set; }
        public string bus { get; set; }
        public string public_transport { get; set; }
        public string check_date { get; set; }
        public string traffic_calming { get; set; }
        public string noexit { get; set; }
        public string barrier { get; set; }
        public string crossing { get; set; }

        [JsonProperty("crossing:island")]
        public string crossingisland { get; set; }
        public string cycle_barrier { get; set; }
        public string cyclestreet { get; set; }
        public string bicycle { get; set; }
        public string cycleway { get; set; }
        public string embedded_rails { get; set; }

        [JsonProperty("bus:lanes")]
        public string buslanes { get; set; }
        public string busway { get; set; }
        [JsonProperty("lanes:bus")]
        public string lanesbus { get; set; }
        public string route { get; set; }
        public string psv { get; set; }

    }
}
