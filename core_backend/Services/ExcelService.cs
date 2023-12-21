using core_backend.Models;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;

namespace core_backend.Services
{
    public class ExcelService
    {
        public List<CSVSensorGeolocation> Import(string filePath)
        {
            var sensorgeolocations = new List<CSVSensorGeolocation>();

            using (var reader = new StreamReader(filePath))
            {
                var first = true;

                while (!reader.EndOfStream)
                {
                    var line = reader.ReadLine();
                    var values = line.Split(',');

                    if (first)
                    {
                        first = false;
                        continue;
                    }

                    var geoLocation = new CSVSensorGeolocation {
                        Id = values[0],
                        CreatedAt = values[1],
                        UpdatedAt = values[2],
                        DeletedAt = values[3],
                        ClassifiedPeriodId = values[4],
                        Latitude = Convert.ToDouble(values[5]),
                        Longitude = Convert.ToDouble(values[6]),
                        Altitude = values[7],
                        Bearing = values[8],
                        Accuracy = values[9],
                        Speed = values[10],
                        Provider = values[11],
                        CreatedOn = Convert.ToInt64(values[14]),
                        UserId = values[17],
                        BatteryLevel = values[18],
                    };

                    sensorgeolocations.Add(geoLocation);
                }
            }

            return sensorgeolocations;
        }

       
    }
}
