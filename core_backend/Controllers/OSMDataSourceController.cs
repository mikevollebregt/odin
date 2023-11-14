using core_backend.Data;
using core_backend.Models;
using core_backend.Models.DTOs.BicycleData;
using core_backend.Models.DTOs.OSM;
using core_backend.Models.DTOs.OSM.JSONResolvers;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;

namespace core_backend.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class OSMDataSourceController : ControllerBase
    {
        private readonly ApplicationDbContext _database;
        private readonly IHttpClientFactory _clientFactory;
        // https://wiki.openstreetmap.org/wiki/Key:highway

        public OSMDataSourceController(IHttpClientFactory clientFactory, ApplicationDbContext database)
        {
            _clientFactory = clientFactory;
            _database = database;
        }

        [HttpGet]
        public async Task<IActionResult> GetTrainInfastructure()
        {
            var coordinates = await _database.TrainRailCoordinates
                .Select(t => new OSMVehicleCoordinate
                    {
                        Id = t.Id,
                        Latitude = t.Latitude,
                        Longitude = t.Longitude,
                    })
                .ToListAsync();

            var stations = await _database.TrainStops
                .Select(t => new OSMStationCoordinate
                {
                    Latitude = t.Latitude,
                    Longitude = t.Longitude,
                    Name = t.Name
                })
                .ToListAsync();

            var dto = new OSMCoordinatesDTO
            {
                Coordinates = coordinates,
                Stations = stations.DistinctBy(s => s.Name).ToList()
            };

            return Ok(dto);
        }

        [HttpGet]
        public async Task<IActionResult> GetTramInfastructure()
        {
            var coordinates = await _database.TramRailCoordinates
                .Select(t => new OSMVehicleCoordinate
                {
                    Id = t.Id,
                    Latitude = t.Latitude,
                    Longitude = t.Longitude,
                })
                .ToListAsync();

            var dto = new OSMCoordinatesDTO
            {
                Coordinates = coordinates
            };

            return Ok(dto);
        }

        [HttpGet]
        public async Task<IActionResult> GetSubwayInfastructure()
        {
            var coordinates = await _database.SubwayRailCoordinates
                .Select(t => new OSMVehicleCoordinate
                {
                    Id = t.Id,
                    Latitude = t.Latitude,
                    Longitude = t.Longitude,
                })
                .ToListAsync();

            var dto = new OSMCoordinatesDTO
            {
                Coordinates = coordinates
            };

            return Ok(dto);
        }

        [HttpGet]
        public async Task<IActionResult> GetCarInfastructure()
        {
            var coordinates = await _database.CarRoadCoordinates
                .Select(t => new OSMVehicleCoordinate
                {
                    Id = t.Id,
                    Latitude = t.Latitude,
                    Longitude = t.Longitude,
                })
                .ToListAsync();

            var dto = new OSMCoordinatesDTO
            {
                Coordinates = coordinates
            };

            return Ok(dto);
        }

        [HttpGet]
        public async Task<IActionResult> GetBicycleInfastructure()
        {
            var coordinates = await _database.BicycleRoadsCoordinates
                .Select(t => new OSMVehicleCoordinate
                {
                    Id = t.Id,
                    Latitude = t.Latitude,
                    Longitude = t.Longitude,
                })
                .ToListAsync();

            var dto = new OSMCoordinatesDTO
            {
                Coordinates = coordinates
            };

            return Ok(dto);
        }

        [HttpGet]
        public async Task<IActionResult> GetBusInfastructure()
        {
            var coordinates = await _database.BusLineCoordinates
                .Select(t => new OSMVehicleCoordinate
                {
                    Id = t.Id,
                    Latitude = t.Latitude,
                    Longitude = t.Longitude,
                })
                .ToListAsync();

            var dto = new OSMCoordinatesDTO
            {
                Coordinates = coordinates
            };

            return Ok(dto);
        }

        [HttpGet]
        public async Task<IActionResult> GetWalkingInfastructure()
        {
            var coordinates = await _database.WalkingPathCoordinates
                .Select(t => new OSMVehicleCoordinate
                {
                    Id = t.Id,
                    Latitude = t.Latitude,
                    Longitude = t.Longitude,
                })
                .ToListAsync();

            var dto = new OSMCoordinatesDTO
            {
                Coordinates = coordinates
            };

            return Ok(dto);
        }


        [HttpGet]
        public async Task<IActionResult> ImportTrainRailWayFromGeoJson()
        {
            var list = new List<string> {
                "drenthe.geojson",
                "flevoland.geojson",
                "friesland.geojson",
                "gelderland.geojson",
                "gelderland_2.geojson",
                "groningen.geojson",
                "limburg.geojson",
                "noord-brabant.geojson",
                "noord-brabant_2.geojson",
                "noord-holland.geojson",
                "noord-holland_2.geojson",
                "overijssel.geojson",
                "overijssel_2.geojson",
                "utrecht.geojson",
                "zeeland.geojson",
                "zuid-holland.geojson",
                "zuid-holland_2.geojson",
                "zuid-holland_3.geojson"
            };

            foreach (var province in list)
            {
                var trainRailWayList = new List<TrainRailCoordinate>();
                using (StreamReader r = new StreamReader("D:/DataSources/" + province))
                {
                    var json = r.ReadToEnd();
                    var convertedResponse = JsonConvert.DeserializeObject<OSMRoot>(json);

                    var railGeometry = convertedResponse!.Features
                        .Where(f => f.Properties.railway == "rail")
                        .ToList();

                    foreach (var rail in railGeometry)
                    {
                        foreach (var coordinates in rail.Geometry.Coordinates)
                        {
                            trainRailWayList.Add(new TrainRailCoordinate
                            {
                                Latitude = coordinates[1],
                                Longitude = coordinates[0]
                            });
                        }
                    }

                    await _database.TrainRailCoordinates.AddRangeAsync(trainRailWayList);
                    await _database.SaveChangesAsync();
                }
            }

            return Ok();


        }

        [HttpGet]
        public async Task<IActionResult> ImportSubwayRailWayFromGeoJson()
        {
            var list = new List<string> {
                "drenthe.geojson",
                "flevoland.geojson",
                "friesland.geojson",
                "gelderland.geojson",
                "gelderland_2.geojson",
                "groningen.geojson",
                "limburg.geojson",
                "noord-brabant.geojson",
                "noord-brabant_2.geojson",
                "noord-holland.geojson",
                "noord-holland_2.geojson",
                "overijssel.geojson",
                "overijssel_2.geojson",
                "utrecht.geojson",
                "zeeland.geojson",
                "zuid-holland.geojson",
                "zuid-holland_2.geojson",
                "zuid-holland_3.geojson"
            };

            foreach (var province in list)
            {
                var subWayList = new List<SubwayRailCoordinate>();
                using (StreamReader r = new StreamReader("D:/DataSources/" + province))
                {
                    var json = r.ReadToEnd();
                    var convertedResponse = JsonConvert.DeserializeObject<OSMRoot>(json);

                    var railGeometry = convertedResponse!.Features
                        .Where(f => f.Properties.railway == "subway")
                        .ToList();

                    foreach (var rail in railGeometry)
                    {
                        foreach (var coordinates in rail.Geometry.Coordinates)
                        {
                            subWayList.Add(new SubwayRailCoordinate
                            {
                                Latitude = coordinates[1],
                                Longitude = coordinates[0]
                            });
                        }
                    }

                    await _database.SubwayRailCoordinates.AddRangeAsync(subWayList);
                    await _database.SaveChangesAsync();
                }
            }

            return Ok();


        }

        [HttpGet]
        public async Task<IActionResult> ImportTramRailWayFromGeoJson()
        {
            var list = new List<string> {
                "drenthe.geojson",
                "flevoland.geojson",
                "friesland.geojson",
                "gelderland.geojson",
                "gelderland_2.geojson",
                "groningen.geojson",
                "limburg.geojson",
                "noord-brabant.geojson",
                "noord-brabant_2.geojson",
                "noord-holland.geojson",
                "noord-holland_2.geojson",
                "overijssel.geojson",
                "overijssel_2.geojson",
                "utrecht.geojson",
                "zeeland.geojson",
                "zuid-holland.geojson",
                "zuid-holland_2.geojson",
                "zuid-holland_3.geojson"
            };

            foreach (var province in list)
            {
                var tramRailWayList = new List<TramRailwayCoordinate>();
                using (StreamReader r = new StreamReader("D:/DataSources/" + province))
                {
                    var json = r.ReadToEnd();
                    var convertedResponse = JsonConvert.DeserializeObject<OSMRoot>(json);

                    var railGeometry = convertedResponse!.Features
                        .Where(f => f.Properties.railway == "tram" ||
                                f.Properties.embedded_rails == "tram" ||
                                f.Properties.railway == "light_rail")
                        .ToList();

                    foreach (var rail in railGeometry)
                    {
                        foreach (var coordinates in rail.Geometry.Coordinates)
                        {
                            tramRailWayList.Add(new TramRailwayCoordinate
                            {
                                Latitude = coordinates[1],
                                Longitude = coordinates[0]
                            });
                        }
                    }

                    await _database.TramRailCoordinates.AddRangeAsync(tramRailWayList);
                    await _database.SaveChangesAsync();
                }
            }

            return Ok();


        }

        [HttpGet]
        public async Task<IActionResult> ImportCarRoadFromGeoJson()
        {
            var list = new List<string> {
                "drenthe.geojson",
                "flevoland.geojson",
                "friesland.geojson",
                "gelderland.geojson",
                "gelderland_2.geojson",
                "groningen.geojson",
                "limburg.geojson",
                "noord-brabant.geojson",
                "noord-brabant_2.geojson",
                "noord-holland.geojson",
                "noord-holland_2.geojson",
                "overijssel.geojson",
                "overijssel_2.geojson",
                "utrecht.geojson",
                "zeeland.geojson",
                "zuid-holland.geojson",
                "zuid-holland_2.geojson",
                "zuid-holland_3.geojson"
            };

            foreach (var province in list)
            {
                var carRoadList = new List<CarRoadCoordinate>();
                using (StreamReader r = new StreamReader("D:/DataSources/" + province))
                {
                    var json = r.ReadToEnd();
                    var convertedResponse = JsonConvert.DeserializeObject<OSMRoot>(json);

                    var railGeometry = convertedResponse!.Features
                        .Where(f =>
                        f.Properties.highway == "motorway"
                        || f.Properties.highway == "trunk"
                        || f.Properties.highway == "primary"
                        || f.Properties.highway == "secondary"
                        || f.Properties.highway == "tertiary"
                        || f.Properties.highway == "unclassified"
                        || f.Properties.highway == "residential"
                        || f.Properties.highway == "motorway_link"
                        || f.Properties.highway == "trunk_link"
                        || f.Properties.highway == "primary_link"
                        || f.Properties.highway == "secondary_link"
                        || f.Properties.highway == "tertiary_link"
                        || f.Properties.highway == "primary_link"
                        )
                        .ToList();

                    foreach (var rail in railGeometry)
                    {
                        foreach (var coordinates in rail.Geometry.Coordinates)
                        {
                            carRoadList.Add(new CarRoadCoordinate
                            {
                                Latitude = coordinates[1],
                                Longitude = coordinates[0]
                            });
                        }
                    }

                    await _database.CarRoadCoordinates.AddRangeAsync(carRoadList);
                    await _database.SaveChangesAsync();
                }
            }

            return Ok();
        }


        [HttpGet]
        public async Task<IActionResult> ImportWalkingRoadFromGeoJson()
        {
            var list = new List<string> {
                "drenthe.geojson",
                "flevoland.geojson",
                "friesland.geojson",
                "gelderland.geojson",
                "gelderland_2.geojson",
                "groningen.geojson",
                "limburg.geojson",
                "noord-brabant.geojson",
                "noord-brabant_2.geojson",
                "noord-holland.geojson",
                "noord-holland_2.geojson",
                "overijssel.geojson",
                "overijssel_2.geojson",
                "utrecht.geojson",
                "zeeland.geojson",
                "zuid-holland.geojson",
                "zuid-holland_2.geojson",
                "zuid-holland_3.geojson"
            };

            foreach (var province in list)
            {
                var walkRoadList = new List<WalkingPathCoordinate>();
                using (StreamReader r = new StreamReader("D:/DataSources/" + province))
                {
                    var json = r.ReadToEnd();
                    var convertedResponse = JsonConvert.DeserializeObject<OSMRoot>(json);

                    var railGeometry = convertedResponse!.Features
                        .Where(f =>
                        f.Properties.highway == "living_street"
                        || f.Properties.highway == "pedestrian"
                        || f.Properties.highway == "track"
                        || f.Properties.highway == "footway"
                        || f.Properties.highway == "bridleway"
                        || f.Properties.highway == "steps"
                        || f.Properties.highway == "corridor"
                        || f.Properties.highway == "footway"
                        )
                        .ToList();

                    foreach (var rail in railGeometry)
                    {
                        foreach (var coordinates in rail.Geometry.Coordinates)
                        {
                            walkRoadList.Add(new WalkingPathCoordinate
                            {
                                Latitude = coordinates[1],
                                Longitude = coordinates[0]
                            });
                        }
                    }

                    await _database.WalkingPathCoordinates.AddRangeAsync(walkRoadList);
                    await _database.SaveChangesAsync();
                }
            }

            return Ok();
        }

        [HttpGet]
        public async Task<IActionResult> ImportTrainStopFromGeoJson()
        {
            var list = new List<string> {
                "drenthe.geojson",
                "flevoland.geojson",
                "friesland.geojson",
                "gelderland.geojson",
                "gelderland_2.geojson",
                "groningen.geojson",
                "limburg.geojson",
                "noord-brabant.geojson",
                "noord-brabant_2.geojson",
                "noord-holland.geojson",
                "noord-holland_2.geojson",
                "overijssel.geojson",
                "overijssel_2.geojson",
                "utrecht.geojson",
                "zeeland.geojson",
                "zuid-holland.geojson",
                "zuid-holland_2.geojson",
                "zuid-holland_3.geojson"
            };

            foreach (var province in list)
            {
                var trainStopList = new List<TrainStop>();
                using (StreamReader r = new StreamReader("D:/DataSources/" + province))
                {
                    var json = r.ReadToEnd();
                    var convertedResponse = JsonConvert.DeserializeObject<OSMRoot>(json);

                    var railGeometry = convertedResponse!.Features
                        .Where(f =>
                        f.Properties.railway == "station"
                        )
                        .ToList();

                    foreach (var rail in railGeometry)
                    {
                        foreach (var coordinates in rail.Geometry.Coordinates)
                        {
                            if(!string.IsNullOrEmpty(rail.Properties.name))
                            {
                                trainStopList.Add(new TrainStop
                                {
                                    Latitude = coordinates[1],
                                    Longitude = coordinates[0],
                                    Name = rail.Properties.name
                                });
                            }
                        }
                    }

                    await _database.TrainStops.AddRangeAsync(trainStopList);
                    await _database.SaveChangesAsync();
                }
            }

            return Ok();
        }

        [HttpGet]
        public async Task<IActionResult> ImportBusRoadFromGeoJson()
        {
            var list = new List<string> {
                "drenthe.geojson",
                "flevoland.geojson",
                "friesland.geojson",
                "gelderland.geojson",
                "gelderland_2.geojson",
                "groningen.geojson",
                "limburg.geojson",
                "noord-brabant.geojson",
                "noord-brabant_2.geojson",
                "noord-holland.geojson",
                "noord-holland_2.geojson",
                "overijssel.geojson",
                "overijssel_2.geojson",
                "utrecht.geojson",
                "zeeland.geojson",
                "zuid-holland.geojson",
                "zuid-holland_2.geojson",
                "zuid-holland_3.geojson"
            };

            foreach (var province in list)
            {
                var busRoadList = new List<BusLineCoordinate>();
                using (StreamReader r = new StreamReader("D:/DataSources/" + province))
                {
                    var json = r.ReadToEnd();
                    var convertedResponse = JsonConvert.DeserializeObject<OSMRoot>(json);

                    var railGeometry = convertedResponse!.Features
                        .Where(f =>
                        f.Properties.highway == "bus_guideway"
                        || f.Properties.highway == "busway"
                        || f.Properties.highway == "bus_stop"
                        || f.Properties.bus == "*"
                        || f.Properties.bus == "designated"
                        || f.Properties.buslanes == "yes"
                        || f.Properties.buslanes == "|||yes"
                        || f.Properties.buslanes == "|yes"
                        || f.Properties.buslanes == "yes|"
                        || f.Properties.buslanes == "reversible"
                        || f.Properties.buslanes == "||yes"
                        || f.Properties.buslanes == "*"
                        || f.Properties.bus == "private"
                        || f.Properties.bus == "yes"
                        || f.Properties.busway == "yes"
                        || f.Properties.lanesbus == "1"
                        || f.Properties.route == "bus"
                        || f.Properties.psv == "yes"
                        | f.Properties.buslanes == "|designated"
                        )
                        .ToList();

                    foreach (var rail in railGeometry)
                    {
                        foreach (var coordinates in rail.Geometry.Coordinates)
                        {
                            busRoadList.Add(new BusLineCoordinate
                            {
                                Latitude = coordinates[1],
                                Longitude = coordinates[0]
                            });
                        }
                    }

                    await _database.BusLineCoordinates.AddRangeAsync(busRoadList);
                    await _database.SaveChangesAsync();
                }
            }

            return Ok();
        }


        [HttpGet]
        public async Task<IActionResult> ImportBicycleRoadFromGeoJson()
        {
            var list = new List<string> {
                "drenthe.geojson",
                "flevoland.geojson",
                "friesland.geojson",
                "gelderland.geojson",
                "gelderland_2.geojson",
                "groningen.geojson",
                "limburg.geojson",
                "noord-brabant.geojson",
                "noord-brabant_2.geojson",
                "noord-holland.geojson",
                "noord-holland_2.geojson",
                "overijssel.geojson",
                "overijssel_2.geojson",
                "utrecht.geojson",
                "zeeland.geojson",
                "zuid-holland.geojson",
                "zuid-holland_2.geojson",
                "zuid-holland_3.geojson"
            };

            foreach (var province in list)
            {
                var bicycleRoadList = new List<BicycleRoadsCoordinate>();
                using (StreamReader r = new StreamReader("D:/DataSources/" + province))
                {
                    var json = r.ReadToEnd();
                    var convertedResponse = JsonConvert.DeserializeObject<OSMRoot>(json);

                    var railGeometry = convertedResponse!.Features
                        .Where(f =>
                        f.Properties.highway == "cycleway"
                        || !string.IsNullOrEmpty(f.Properties.cyclestreet)
                        || !string.IsNullOrEmpty(f.Properties.bicycle)
                        || !string.IsNullOrEmpty(f.Properties.cycleway)
                        )
                        .ToList();

                    foreach (var rail in railGeometry)
                    {
                        foreach (var coordinates in rail.Geometry.Coordinates)
                        {
                            bicycleRoadList.Add(new BicycleRoadsCoordinate
                            {
                                Latitude = coordinates[1],
                                Longitude = coordinates[0]
                            });
                        }
                    }

                    await _database.BicycleRoadsCoordinates.AddRangeAsync(bicycleRoadList);
                    await _database.SaveChangesAsync();
                }
            }

            return Ok();
        }
    }
}
