using core_backend.Data;
using core_backend.Models.DTOs;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace core_backend.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class VehicleClassifierController : ControllerBase
    {
        private readonly ApplicationDbContext _database;
        public VehicleClassifierController(ApplicationDbContext database)
        {
            _database = database;
        }

        [HttpPost]
        public async Task<IActionResult> ClassifyWalkingCluster([FromBody] VehicleClusterDTO vehicleClusterDTO)
        {
            var classifiedCluster = await ClassifyWalking(vehicleClusterDTO);

            return Ok(classifiedCluster);
        }

        [HttpPost]
        public async Task<IActionResult> ClassifyBicycleCluster([FromBody] VehicleClusterDTO vehicleClusterDTO)
        {
            var classifiedCluster = await ClassifyBicycle(vehicleClusterDTO);

            return Ok(classifiedCluster);
        }

        [HttpPost]
        public async Task<IActionResult> ClassifyTramCluster([FromBody] VehicleClusterDTO vehicleClusterDTO)
        {
            var classifiedCluster = await ClassifyTram(vehicleClusterDTO);

            return Ok(classifiedCluster);
        }

        [HttpPost]
        public async Task<IActionResult> ClassifyMetroCluster([FromBody] VehicleClusterDTO vehicleClusterDTO)
        {
            var classifiedCluster = await ClassifyMetro(vehicleClusterDTO);

            return Ok(classifiedCluster);
        }

        [HttpPost]
        public async Task<IActionResult> ClassifyTrainCluster([FromBody] VehicleClusterDTO vehicleClusterDTO)
        {
            var classifiedCluster = await ClassifyTrain(vehicleClusterDTO);

            return Ok(classifiedCluster);
        }

        [HttpPost]
        public async Task<IActionResult> ClassifyBusCluster([FromBody] VehicleClusterDTO vehicleClusterDTO)
        {
            var classifiedCluster = await ClassifyBus(vehicleClusterDTO);

            return Ok(classifiedCluster);
        }

        [HttpPost]
        public async Task<IActionResult> ClassifyCarCluster([FromBody] VehicleClusterDTO vehicleClusterDTO)
        {
            var classifiedCluster = await ClassifyCar(vehicleClusterDTO);

            return Ok(classifiedCluster);
        }

        private async Task<ClassifiedVehicleClusterDTO> ClassifyTrain(VehicleClusterDTO vehicleClusterDTO)
        {
            var coordinateCounter = 0;
            var extraLocationsDataList = new List<ExtraLocationsDataDTO>();
            var trainStops = new List<ExtraLocationsDataDTO>();

            for (var i = 0; i < vehicleClusterDTO.Locations.Count; i ++)
            {
                var cluster = vehicleClusterDTO.Locations[i];

                var coordinates = await _database.TrainRailCoordinates.FromSqlRaw($"select * from TrainRailCoordinates where dbo.udf_Haversine(latitude, longitude, {cluster.Latitude}, {cluster.Longitude}) < {cluster.Accuracy / 100}").ToListAsync();
                var stations = await _database.TrainStops.FromSqlRaw($"select * from TrainStops where dbo.udf_Haversine(latitude, longitude, {cluster.Latitude}, {cluster.Longitude}) < 0.1").ToListAsync();

                extraLocationsDataList.Add(new ExtraLocationsDataDTO
                {
                    Latitude = cluster.Latitude,
                    Longitude = cluster.Longitude,
                    Station = "",
                    TrainRailCloseBy = coordinates.Count > 0
                });

                if (stations.Any())
                {
                    trainStops.Add(new ExtraLocationsDataDTO
                    {
                        Latitude = cluster.Latitude,
                        Longitude = cluster.Longitude,
                        Station = stations.First().Name,
                        TrainRailCloseBy = coordinates.Count > 0,
                        CreatedOn = cluster.CreatedOn
                    });
                }

                if(coordinates.Count > 0)
                {
                    coordinateCounter++;
                }
            }

            var trainMatch = (((double)coordinateCounter / (double)vehicleClusterDTO.Locations.Count)) * 100;

            var classifiedVehicle = new ClassifiedVehicleClusterDTO
            {
                ProbableTransports = new List<ProbableTransportDTO> {
                    new ProbableTransportDTO
                    {
                        Transport = "Train",
                        Probalitity = trainMatch
                    }
                },
                ExtraLocationsDataDTOs = extraLocationsDataList,
                TrainStopsDTOs = trainStops.DistinctBy(s => s.Station).ToList()
            };

            return classifiedVehicle;
        }

        private async Task<ClassifiedVehicleClusterDTO> ClassifyMetro(VehicleClusterDTO vehicleClusterDTO)
        {
            var coordinateCounter = 0;
            var extraLocationsDataList = new List<ExtraLocationsDataDTO>();
            var subwayStops = new List<ExtraLocationsDataDTO>();


            for (var i = 0; i < vehicleClusterDTO.Locations.Count; i ++)
            {
                var cluster = vehicleClusterDTO.Locations[i];

                if(cluster.Accuracy > 500)
                {
                    continue;
                }

                var coordinates = await _database.SubwayRailCoordinates.FromSqlRaw($"select * from SubwayRailCoordinates where dbo.udf_Haversine(latitude, longitude, {cluster.Latitude}, {cluster.Longitude}) < {cluster.Accuracy / 100}").ToListAsync();
                //var stations = await _database.TrainStops.FromSqlRaw($"select * from TrainStops where dbo.udf_Haversine(latitude, longitude, {cluster.Latitude}, {cluster.Longitude}) < 0.01").ToListAsync();

                extraLocationsDataList.Add(new ExtraLocationsDataDTO
                {
                    Latitude = cluster.Latitude,
                    Longitude = cluster.Longitude,
                    Station = "",
                    TrainRailCloseBy = coordinates.Count > 0
                });

                //if (stations.Any())
                //{
                //    trainStops.Add(new ExtraLocationsDataDTO
                //    {
                //        Latitude = cluster.Latitude,
                //        Longitude = cluster.Longitude,
                //        Station = stations.First().Name,
                //        TrainRailCloseBy = coordinates.Count > 0,
                //        CreatedOn = cluster.CreatedOn
                //    });
                //}

                if (coordinates.Count > 0)
                {
                    coordinateCounter++;
                }

            }

            var subwayMatch = (((double)coordinateCounter / (double)vehicleClusterDTO.Locations.Count)) * 100;
            var classifiedVehicle = new ClassifiedVehicleClusterDTO
            {
                ProbableTransports = new List<ProbableTransportDTO> {
                    new ProbableTransportDTO
                    {
                        Transport = "Subway",
                        Probalitity = subwayMatch
                    }
                },
                ExtraLocationsDataDTOs = extraLocationsDataList,
                //TrainStopsDTOs = trainStops.DistinctBy(s => s.Station).ToList()
            };

            return classifiedVehicle;
        }

        private async Task<ClassifiedVehicleClusterDTO> ClassifyTram(VehicleClusterDTO vehicleClusterDTO)
        {
            var coordinateCounter = 0;
            var extraLocationsDataList = new List<ExtraLocationsDataDTO>();
            var tramStops = new List<ExtraLocationsDataDTO>();


            for (var i = 0; i < vehicleClusterDTO.Locations.Count; i ++)
            {
                var cluster = vehicleClusterDTO.Locations[i];

                if (cluster.Accuracy > 500)
                {
                    continue;
                }

                var coordinates = await _database.TramRailCoordinates.FromSqlRaw($"select * from TramRailCoordinates where dbo.udf_Haversine(latitude, longitude, {cluster.Latitude}, {cluster.Longitude}) < {cluster.Accuracy / 100}").ToListAsync();
                //var stations = await _database.TrainStops.FromSqlRaw($"select * from TrainStops where dbo.udf_Haversine(latitude, longitude, {cluster.Latitude}, {cluster.Longitude}) < 0.01").ToListAsync();

                extraLocationsDataList.Add(new ExtraLocationsDataDTO
                {
                    Latitude = cluster.Latitude,
                    Longitude = cluster.Longitude,
                    Station = "",
                    TrainRailCloseBy = coordinates.Count > 0
                });

                //if (stations.Any())
                //{
                //    trainStops.Add(new ExtraLocationsDataDTO
                //    {
                //        Latitude = cluster.Latitude,
                //        Longitude = cluster.Longitude,
                //        Station = stations.First().Name,
                //        TrainRailCloseBy = coordinates.Count > 0,
                //        CreatedOn = cluster.CreatedOn
                //    });
                //}

                if (coordinates.Count > 0)
                {
                    coordinateCounter++;
                }
            }

            var tramMatch = (((double)coordinateCounter / (double)vehicleClusterDTO.Locations.Count)) * 100;

            var classifiedVehicle = new ClassifiedVehicleClusterDTO
            {
                ProbableTransports = new List<ProbableTransportDTO> {
                    new ProbableTransportDTO
                    {
                        Transport = "Tram",
                        Probalitity = tramMatch
                    }
                },
                ExtraLocationsDataDTOs = extraLocationsDataList,
                //TrainStopsDTOs = trainStops.DistinctBy(s => s.Station).ToList()
            };

            return classifiedVehicle;
        }

        private async Task<ClassifiedVehicleClusterDTO> ClassifyBus(VehicleClusterDTO vehicleClusterDTO)
        {
            double coordinateCounter = 0;
            var extraLocationsDataList = new List<ExtraLocationsDataDTO>();
            var busStops = new List<ExtraLocationsDataDTO>();


            for (var i = 0; i < vehicleClusterDTO.Locations.Count; i ++)
            {
                var cluster = vehicleClusterDTO.Locations[i];

                if (cluster.Accuracy > 500)
                {
                    continue;
                }

                var coordinates = await _database.BusLineCoordinates.FromSqlRaw($"select * from BusLineCoordinates where dbo.udf_Haversine(latitude, longitude, {cluster.Latitude}, {cluster.Longitude}) < {cluster.Accuracy / 100}").ToListAsync();
                //var stations = await _database.TrainStops.FromSqlRaw($"select * from TrainStops where dbo.udf_Haversine(latitude, longitude, {cluster.Latitude}, {cluster.Longitude}) < 0.01").ToListAsync();

                extraLocationsDataList.Add(new ExtraLocationsDataDTO
                {
                    Latitude = cluster.Latitude,
                    Longitude = cluster.Longitude,
                    Station = "",
                    TrainRailCloseBy = coordinates.Count > 0
                });

                //if (stations.Any())
                //{
                //    trainStops.Add(new ExtraLocationsDataDTO
                //    {
                //        Latitude = cluster.Latitude,
                //        Longitude = cluster.Longitude,
                //        Station = stations.First().Name,
                //        TrainRailCloseBy = coordinates.Count > 0,
                //        CreatedOn = cluster.CreatedOn
                //    });
                //}

                if (coordinates.Count > 0)
                {
                    coordinateCounter++;
                }
            }

            var busMatch = (((double)coordinateCounter / (double)vehicleClusterDTO.Locations.Count)) * 100;

            var classifiedVehicle = new ClassifiedVehicleClusterDTO
            {
                ProbableTransports = new List<ProbableTransportDTO> {
                    new ProbableTransportDTO
                    {
                        Transport = "Bus",
                        Probalitity = busMatch
                    }
                },
                ExtraLocationsDataDTOs = extraLocationsDataList,
                //TrainStopsDTOs = trainStops.DistinctBy(s => s.Station).ToList()
            };

            return classifiedVehicle;
        }

        private async Task<ClassifiedVehicleClusterDTO> ClassifyCar(VehicleClusterDTO vehicleClusterDTO)
        {
            var coordinateCounter = 0;
            var extraLocationsDataList = new List<ExtraLocationsDataDTO>();
            var carStops = new List<ExtraLocationsDataDTO>();

            for (var i = 0; i < vehicleClusterDTO.Locations.Count; i += 10)
            {
                var cluster = vehicleClusterDTO.Locations[i];

                if (cluster.Accuracy > 500)
                {
                    continue;
                }

                var coordinates = await _database.CarRoadCoordinates.FromSqlRaw($"select * from CarRoadCoordinates where dbo.udf_Haversine(latitude, longitude, {cluster.Latitude}, {cluster.Longitude}) < {cluster.Accuracy / 100}").ToListAsync();
                //var stations = await _database.TrainStops.FromSqlRaw($"select * from TrainStops where dbo.udf_Haversine(latitude, longitude, {cluster.Latitude}, {cluster.Longitude}) < 0.01").ToListAsync();

                extraLocationsDataList.Add(new ExtraLocationsDataDTO
                {
                    Latitude = cluster.Latitude,
                    Longitude = cluster.Longitude,
                    Station = "",
                    TrainRailCloseBy = coordinates.Count > 0
                });

                //if (stations.Any())
                //{
                //    trainStops.Add(new ExtraLocationsDataDTO
                //    {
                //        Latitude = cluster.Latitude,
                //        Longitude = cluster.Longitude,
                //        Station = stations.First().Name,
                //        TrainRailCloseBy = coordinates.Count > 0,
                //        CreatedOn = cluster.CreatedOn
                //    });
                //}

                coordinateCounter += coordinates.Count;
            }

            var match = (((double)coordinateCounter / (double)vehicleClusterDTO.Locations.Count)) * 100;

            var classifiedVehicle = new ClassifiedVehicleClusterDTO
            {
                ProbableTransports = new List<ProbableTransportDTO> {
                    new ProbableTransportDTO
                    {
                        Transport = "Car",
                        Probalitity = match
                    }
                },
                ExtraLocationsDataDTOs = extraLocationsDataList,
                //TrainStopsDTOs = trainStops.DistinctBy(s => s.Station).ToList()
            };

            return classifiedVehicle;
        }

        private async Task<ClassifiedVehicleClusterDTO> ClassifyBicycle(VehicleClusterDTO vehicleClusterDTO)
        {
            var coordinateCounter = 0;
            var extraLocationsDataList = new List<ExtraLocationsDataDTO>();
            var stops = new List<ExtraLocationsDataDTO>();

            for (var i = 0; i < vehicleClusterDTO.Locations.Count; i += 10)
            {
                var cluster = vehicleClusterDTO.Locations[i];
                var coordinates = await _database.BicycleRoadsCoordinates.FromSqlRaw($"select * from BicycleRoadsCoordinates where dbo.udf_Haversine(latitude, longitude, {cluster.Latitude}, {cluster.Longitude}) < {cluster.Accuracy / 100}").ToListAsync();
                //var stations = await _database.TrainStops.FromSqlRaw($"select * from TrainStops where dbo.udf_Haversine(latitude, longitude, {cluster.Latitude}, {cluster.Longitude}) < 0.01").ToListAsync();

                extraLocationsDataList.Add(new ExtraLocationsDataDTO
                {
                    Latitude = cluster.Latitude,
                    Longitude = cluster.Longitude,
                    Station = "",
                    TrainRailCloseBy = coordinates.Count > 0
                });

                //if (stations.Any())
                //{
                //    trainStops.Add(new ExtraLocationsDataDTO
                //    {
                //        Latitude = cluster.Latitude,
                //        Longitude = cluster.Longitude,
                //        Station = stations.First().Name,
                //        TrainRailCloseBy = coordinates.Count > 0,
                //        CreatedOn = cluster.CreatedOn
                //    });
                //}

                coordinateCounter += coordinates.Count;
            }

            var match = (((double)coordinateCounter / (double)vehicleClusterDTO.Locations.Count)) * 100;

            var classifiedVehicle = new ClassifiedVehicleClusterDTO
            {
                ProbableTransports = new List<ProbableTransportDTO> {
                    new ProbableTransportDTO
                    {
                        Transport = "Bicycle",
                        Probalitity = match
                    }
                },
                ExtraLocationsDataDTOs = extraLocationsDataList,
                //TrainStopsDTOs = trainStops.DistinctBy(s => s.Station).ToList()
            };

            return classifiedVehicle;
        }

        private async Task<ClassifiedVehicleClusterDTO> ClassifyWalking(VehicleClusterDTO vehicleClusterDTO)
        {
            var coordinateCounter = 0;
            var extraLocationsDataList = new List<ExtraLocationsDataDTO>();
            var stops = new List<ExtraLocationsDataDTO>();

            for (var i = 0; i < vehicleClusterDTO.Locations.Count; i += 10)
            {
                var cluster = vehicleClusterDTO.Locations[i];
                var coordinates = await _database.WalkingPathCoordinates.FromSqlRaw($"select * from WalkingPathCoordinates where dbo.udf_Haversine(latitude, longitude, {cluster.Latitude}, {cluster.Longitude}) < {cluster.Accuracy / 100}").ToListAsync();
                //var stations = await _database.TrainStops.FromSqlRaw($"select * from TrainStops where dbo.udf_Haversine(latitude, longitude, {cluster.Latitude}, {cluster.Longitude}) < 0.01").ToListAsync();

                extraLocationsDataList.Add(new ExtraLocationsDataDTO
                {
                    Latitude = cluster.Latitude,
                    Longitude = cluster.Longitude,
                    Station = "",
                    TrainRailCloseBy = coordinates.Count > 0
                });

                //if (stations.Any())
                //{
                //    trainStops.Add(new ExtraLocationsDataDTO
                //    {
                //        Latitude = cluster.Latitude,
                //        Longitude = cluster.Longitude,
                //        Station = stations.First().Name,
                //        TrainRailCloseBy = coordinates.Count > 0,
                //        CreatedOn = cluster.CreatedOn
                //    });
                //}

                coordinateCounter += coordinates.Count;
            }

            var match = (((double)coordinateCounter / (double)vehicleClusterDTO.Locations.Count)) * 100;

            var classifiedVehicle = new ClassifiedVehicleClusterDTO
            {
                ProbableTransports = new List<ProbableTransportDTO> {
                    new ProbableTransportDTO
                    {
                        Transport = "Walking",
                        Probalitity = match
                    }
                },
                ExtraLocationsDataDTOs = extraLocationsDataList,
                //TrainStopsDTOs = trainStops.DistinctBy(s => s.Station).ToList()
            };

            return classifiedVehicle;
        }
    }
}
