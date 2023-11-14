namespace core_backend.Models.DTOs.BicycleData
{
    public class BicyclePropertiesDTO
    {
        public string Name { get; set; }
        public int Objectid { get; set; }
        public string Gdb_geomattr_data { get; set; }
        public string Geocode { get; set; }
        public string Subcode { get; set; }
        public int Geocode_nr { get; set; }
        public string Geosubcode { get; set; }
        public string Geocode_naam { get; set; }
        public double Km_geocode { get; set; }
        public string Km_geocode_t { get; set; }
        public string Geokmt { get; set; }
        public double X { get; set; }
        public double Y { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public string Kmlint { get; set; }
        public string Kmlint_omschrijving { get; set; }
        public string Geldig_vanaf { get; set; }
        public string Publicatiedatum { get; set; }

    }
}
