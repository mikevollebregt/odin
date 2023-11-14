import 'dart:math';

import 'package:desktop/infastructure/period_classifier/vehicle_classifier.dart';
import 'package:desktop/infastructure/repositories/dtos/sensor_geolocation_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../period_classifier/enums/transport_enum.dart';
import '../repositories/dtos/location_dto.dart';
import '../repositories/dtos/location_map_dto.dart';
import 'generic_notifier.dart';
import 'dart:math' as math;

import 'movement_notifier.dart';

class ClusterNotifier extends StateNotifier<NotifierState> {
  final VehicleClassifier _vehicleClassifier;

  ClusterNotifier(this._vehicleClassifier) : super(const Initial());

  //fused
  //normal
  //balanced
  Future createClusters(List<SensorGeolocationDTO> data) async {
    state = const Loading();

    final clusters = List<List<Cluster>>.empty(growable: true);

    var fusedCluster = <Cluster>[]; //await createCalculatedSpeedCluster(data[0]);
    var normalCluster = await createCalculatedSpeedCluster(data);
    var balancedCluster = <Cluster>[]; //await createCalculatedSpeedCluster(data[2]);

    clusters.addAll([fusedCluster, normalCluster, balancedCluster]);

    state = Loaded<List<List<Cluster>>>(clusters);
  }

  Future<List<Cluster>> createCalculatedSpeedCluster(List<SensorGeolocationDTO> data) async {
    final clusters = List<Cluster>.empty(growable: true);
    var counter = 0;
    var moving = false;

    //data.removeWhere((element) => element.accuracy > 30);

    for (var i = 0; i < data.length - 5; i += 5) {
      var medianSpeed = getMedian(data.sublist(i, i + 5));
      for (var j = 0; j < 5; j++) {
        var isMoving = this.isMoving(medianSpeed);
        var stoppedMoving = this.stoppedMoving(isMoving, moving);
        var counterIsBigEnough = i + j - counter > 30;

        if (stoppedMoving) {
          var cluster = await distillCluster(data.sublist(counter, i + j));

          clusters.add(cluster);

          //just for fast testing
          // if (cluster.probableTransports.isNotEmpty) {
          //   return clusters;
          // }
        }

        if (startedMoving(isMoving, moving)) {
          counter = i + j;
        }

        moving = isMoving;
      }
    }

    return clusters;
  }

  bool stoppedMoving(bool isMoving, bool moving) {
    return !isMoving && moving;
  }

  bool startedMoving(bool isMoving, bool moving) {
    return isMoving && !moving;
  }

  bool isMoving(int calculatedSpeed) {
    return calculatedSpeed > 3;
  }

  int getMedian(List<SensorGeolocationDTO> locations) {
    locations.sort((a, b) => a.calculatedSpeed.compareTo(b.calculatedSpeed));
    var median = locations[2].calculatedSpeed;

    return median.isNaN || median.isInfinite ? 0 : median.toInt();
  }

  Future<Cluster> distillCluster(List<SensorGeolocationDTO> data) async {
    if (data.isEmpty) {
      return Cluster([""], DateTime.now(), DateTime.now(), 0, 0, data.length, data, 0, [], [], Transport.Unknown,
          Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0), [], 0);
    }

    var aSpeed = data.map((m) => m.calculatedSpeed).reduce((a, b) => a + b) / data.length;
    var aAccuracy = data.map((m) => m.accuracy).reduce((a, b) => a + b) / data.length;
    var averageAccuracy = data.map((m) => m.accuracy).reduce((a, b) => a + b) / data.length;
    var averageSpeed = aSpeed.isInfinite ? 0 : aSpeed.toInt();
    var mSpeed = data.map((d) => d.calculatedSpeed).reduce(max);
    var maxSpeed = mSpeed.isInfinite ? 0 : mSpeed.toInt();
    var amountOfTime = (data.last.createdOn - data.first.createdOn) / 1000;

    var cluster = Cluster(
        [""],
        DateTime.fromMillisecondsSinceEpoch(data.first.createdOn),
        DateTime.fromMillisecondsSinceEpoch(data.last.createdOn),
        averageSpeed.toInt(),
        amountOfTime.toInt(),
        data.length,
        data,
        maxSpeed.toInt(),
        [],
        [],
        Transport.Unknown,
        averageSpeed > 5 ? Colors.green : Colors.red,
        [],
        averageAccuracy);

    if (cluster.averageSpeed > 9 || cluster.averageAccuracy > 400) {
      var classification = await _vehicleClassifier.getClassifierFromServer(cluster);
      cluster.classifiedVehicles = classification;
    }

    return cluster;
  }

  //create movements from cluster
  double _calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;

    return 12742 * asin(sqrt(a)) * 1000;
  }

  int _calculateSpeed(DateTime startTime, DateTime endTime, double distance) {
    var timeDifferenceInSeconds = (endTime.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch) * 1000;
    var speed = distance / timeDifferenceInSeconds;

    return speed.toInt();
  }

  LocationMapDTO createLocationMap(List<Cluster> clusters) {
    var latlngs = <Polyline>[];

    for (var cluster in clusters) {
      var polyline = Polyline(strokeWidth: 4.0, color: getColorBasedOnCalculatedSpeed(cluster.maxSpeed), points: []);

      for (var location in cluster.locations) {
        polyline.points.add(LatLng(location.lat, location.lon));
      }

      latlngs.add(polyline);
    }

    var locationMapDTO = LocationMapDTO(_getMarkers(clusters.isNotEmpty ? [clusters[0].locations[0]] : []), latlngs);

    return locationMapDTO;
  }

  List<Marker> doMarkers(Cluster cluster, Color color) {
    var markers = <Marker>[];
    for (var location in cluster.locations) {
      var marker = Marker(
          width: 5.0,
          height: 5.0,
          point: LatLng(location.lat, location.lon),
          builder: (ctx) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: color,
                ),
                alignment: Alignment.center,
              ));

      markers.add(marker);
    }

    return markers;
  }

  LocationMapDTO createVehicleMap(List<Cluster> clusters, String sensor) {
    var markers = <Marker>[];

    for (var cluster in clusters) {
      if (cluster.averageSpeed > 20) {
        var bestClassifiedVehicle = cluster.classifiedVehicles.reduce((classifiedVehicle, nextClassifiedVehicle) =>
            classifiedVehicle.probableTransports.first.probability > nextClassifiedVehicle.probableTransports.first.probability
                ? classifiedVehicle
                : nextClassifiedVehicle);

        if (bestClassifiedVehicle.probableTransports.first.probability == 0) {
          markers.addAll(doMarkers(cluster, Colors.green));
        } else if (bestClassifiedVehicle.probableTransports.first.transport == Transport.Tram) {
          markers.addAll(doMarkers(cluster, Colors.orange));
        } else if (bestClassifiedVehicle.probableTransports.first.transport == Transport.Train) {
          markers.addAll(doMarkers(cluster, Colors.yellow));
        } else if (bestClassifiedVehicle.probableTransports.first.transport == Transport.Subway) {
          markers.addAll(doMarkers(cluster, Colors.purple));
        } else if (bestClassifiedVehicle.probableTransports.first.transport == Transport.Bus) {
          markers.addAll(doMarkers(cluster, Colors.blue));
        }
      } else {
        for (var location in cluster.locations) {
          var marker = Marker(
              width: 5.0,
              height: 5.0,
              point: LatLng(location.lat, location.lon),
              builder: (ctx) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.red,
                    ),
                    alignment: Alignment.center,
                  ));

          markers.add(marker);
        }
      }
    }

    var locationMapDTO = LocationMapDTO(markers, []);

    return locationMapDTO;
  }

  LocationMapDTO createRandomColorMap(List<Cluster> clusters, String sensor) {
    var latlngs = <Polyline>[];

    for (var cluster in clusters) {
      var polyline = Polyline(strokeWidth: 4.0, color: cluster.randomColor, points: []);

      for (var location in cluster.locations) {
        polyline.points.add(LatLng(location.lat, location.lon));
      }

      latlngs.add(polyline);
    }

    var locationMapDTO = LocationMapDTO(_getMarkers(clusters.isNotEmpty ? [clusters[0].locations[0]] : []), latlngs);

    return locationMapDTO;
  }

  LocationMapDTO createTrainMap(List<Cluster> clusters, String sensor) {
    var latlngs = <Polyline>[];
    var markers = <Marker>[];

    for (var cluster in clusters) {
      var polyline = Polyline(strokeWidth: 4.0, color: Colors.green, points: []);

      if (cluster.classifiedVehicles.isEmpty) {
        for (var location in cluster.locations) {
          var marker = Marker(
              width: 5.0,
              height: 5.0,
              point: LatLng(location.lat, location.lon),
              builder: (ctx) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.red,
                    ),
                    alignment: Alignment.center,
                  ));

          markers.add(marker);
        }
        continue;
      }

      var trainCluster = cluster.classifiedVehicles.firstWhere((element) => element.probableTransports.first.transport == Transport.Train);

      for (var location in trainCluster.extraLocationsDataDTOs) {
        if (location.trainRailCloseBy == true) {
          var marker = Marker(
              width: 5.0,
              height: 5.0,
              point: LatLng(location.latitude, location.longitude),
              builder: (ctx) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.yellow,
                    ),
                    alignment: Alignment.center,
                  ));

          markers.add(marker);
        } else {
          var marker = Marker(
              width: 5.0,
              height: 5.0,
              point: LatLng(location.latitude, location.longitude),
              builder: (ctx) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.green,
                    ),
                    alignment: Alignment.center,
                  ));

          markers.add(marker);
        }
      }

      latlngs.add(polyline);

      // for (var location in trainCluster.trainStopsDTOs) {
      //   var marker = Marker(
      //       width: 30.0,
      //       height: 30.0,
      //       point: LatLng(location.latitude, location.longitude),
      //       builder: (ctx) => Container(
      //             decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(40),
      //               color: Colors.white,
      //             ),
      //             alignment: Alignment.center,
      //             child: FaIconMapper.getFaIcon(null),
      //           ));

      //   markers.add(marker);
      // }
    }

    var locationMapDTO = LocationMapDTO(markers, latlngs);

    return locationMapDTO;
  }

  LocationMapDTO createTramMap(List<Cluster> clusters, String sensor) {
    var latlngs = <Polyline>[];
    var markers = <Marker>[];

    for (var cluster in clusters) {
      var polyline = Polyline(strokeWidth: 4.0, color: Colors.green, points: []);

      if (cluster.classifiedVehicles.isEmpty) {
        for (var location in cluster.locations) {
          var marker = Marker(
              width: 5.0,
              height: 5.0,
              point: LatLng(location.lat, location.lon),
              builder: (ctx) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.red,
                    ),
                    alignment: Alignment.center,
                  ));

          markers.add(marker);
        }
        continue;
      }

      var tramCluster = cluster.classifiedVehicles.firstWhere((element) => element.probableTransports.first.transport == Transport.Tram);

      for (var location in tramCluster.extraLocationsDataDTOs) {
        if (location.trainRailCloseBy == true) {
          var marker = Marker(
              width: 5.0,
              height: 5.0,
              point: LatLng(location.latitude, location.longitude),
              builder: (ctx) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.orange,
                    ),
                    alignment: Alignment.center,
                  ));

          markers.add(marker);
        } else {
          var marker = Marker(
              width: 5.0,
              height: 5.0,
              point: LatLng(location.latitude, location.longitude),
              builder: (ctx) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.green,
                    ),
                    alignment: Alignment.center,
                  ));

          markers.add(marker);
        }
      }

      latlngs.add(polyline);

      // for (var location in trainCluster.trainStopsDTOs) {
      //   var marker = Marker(
      //       width: 30.0,
      //       height: 30.0,
      //       point: LatLng(location.latitude, location.longitude),
      //       builder: (ctx) => Container(
      //             decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(40),
      //               color: Colors.white,
      //             ),
      //             alignment: Alignment.center,
      //             child: FaIconMapper.getFaIcon(null),
      //           ));

      //   markers.add(marker);
      // }
    }

    var locationMapDTO = LocationMapDTO(markers, latlngs);

    return locationMapDTO;
  }

  LocationMapDTO createBusMap(List<Cluster> clusters, String sensor) {
    var latlngs = <Polyline>[];
    var markers = <Marker>[];

    for (var cluster in clusters) {
      var polyline = Polyline(strokeWidth: 4.0, color: Colors.green, points: []);

      if (cluster.classifiedVehicles.isEmpty) {
        for (var location in cluster.locations) {
          var marker = Marker(
              width: 5.0,
              height: 5.0,
              point: LatLng(location.lat, location.lon),
              builder: (ctx) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.red,
                    ),
                    alignment: Alignment.center,
                  ));

          markers.add(marker);
        }
        continue;
      }

      var busCluster = cluster.classifiedVehicles.firstWhere((element) => element.probableTransports.first.transport == Transport.Bus);

      for (var location in busCluster.extraLocationsDataDTOs) {
        if (location.trainRailCloseBy == true) {
          var marker = Marker(
              width: 5.0,
              height: 5.0,
              point: LatLng(location.latitude, location.longitude),
              builder: (ctx) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.blue,
                    ),
                    alignment: Alignment.center,
                  ));

          markers.add(marker);
        } else {
          var marker = Marker(
              width: 5.0,
              height: 5.0,
              point: LatLng(location.latitude, location.longitude),
              builder: (ctx) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.green,
                    ),
                    alignment: Alignment.center,
                  ));

          markers.add(marker);
        }
      }

      latlngs.add(polyline);

      // for (var location in trainCluster.trainStopsDTOs) {
      //   var marker = Marker(
      //       width: 30.0,
      //       height: 30.0,
      //       point: LatLng(location.latitude, location.longitude),
      //       builder: (ctx) => Container(
      //             decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(40),
      //               color: Colors.white,
      //             ),
      //             alignment: Alignment.center,
      //             child: FaIconMapper.getFaIcon(null),
      //           ));

      //   markers.add(marker);
      // }
    }

    var locationMapDTO = LocationMapDTO(markers, latlngs);

    return locationMapDTO;
  }

  LocationMapDTO createSubwayMap(List<Cluster> clusters, String sensor) {
    var latlngs = <Polyline>[];
    var markers = <Marker>[];

    for (var cluster in clusters) {
      var polyline = Polyline(strokeWidth: 4.0, color: Colors.green, points: []);

      if (cluster.classifiedVehicles.isEmpty) {
        for (var location in cluster.locations) {
          var marker = Marker(
              width: 5.0,
              height: 5.0,
              point: LatLng(location.lat, location.lon),
              builder: (ctx) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.red,
                    ),
                    alignment: Alignment.center,
                  ));

          markers.add(marker);
        }
        continue;
      }

      var subwayCluster = cluster.classifiedVehicles.firstWhere((element) => element.probableTransports.first.transport == Transport.Subway);

      for (var location in subwayCluster.extraLocationsDataDTOs) {
        if (location.trainRailCloseBy == true) {
          var marker = Marker(
              width: 5.0,
              height: 5.0,
              point: LatLng(location.latitude, location.longitude),
              builder: (ctx) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.purple,
                    ),
                    alignment: Alignment.center,
                  ));

          markers.add(marker);
        } else {
          var marker = Marker(
              width: 5.0,
              height: 5.0,
              point: LatLng(location.latitude, location.longitude),
              builder: (ctx) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.green,
                    ),
                    alignment: Alignment.center,
                  ));

          markers.add(marker);
        }
      }

      latlngs.add(polyline);

      // for (var location in trainCluster.trainStopsDTOs) {
      //   var marker = Marker(
      //       width: 30.0,
      //       height: 30.0,
      //       point: LatLng(location.latitude, location.longitude),
      //       builder: (ctx) => Container(
      //             decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(40),
      //               color: Colors.white,
      //             ),
      //             alignment: Alignment.center,
      //             child: FaIconMapper.getFaIcon(null),
      //           ));

      //   markers.add(marker);
      // }
    }

    var locationMapDTO = LocationMapDTO(markers, latlngs);

    return locationMapDTO;
  }

  LocationMapDTO createCarMap(List<Cluster> clusters, String sensor) {
    var latlngs = <Polyline>[];
    var markers = <Marker>[];

    for (var cluster in clusters) {
      var polyline = Polyline(strokeWidth: 4.0, color: Colors.green, points: []);

      if (cluster.classifiedVehicles.isEmpty) {
        continue;
      }

      var carCluster = cluster.classifiedVehicles.firstWhere((element) => element.probableTransports.first.transport == Transport.Car);

      latlngs.add(polyline);
    }

    var locationMapDTO = LocationMapDTO(markers, latlngs);

    return locationMapDTO;
  }

  Color randomGenerator() {
    final List<Color> circleColors = [Colors.red, Colors.blue, Colors.green, Colors.purple, Colors.yellow, Colors.orange, Colors.brown];
    final color = circleColors[Random().nextInt(6)];

    return color;
  }

  List<Marker> _getMarkers(List<SensorGeolocationDTO> locations) {
    var markers = <Marker>[];

    for (var dto in locations) {
      var marker = Marker(
          width: 5.0,
          height: 5.0,
          point: LatLng(dto.lat, dto.lon),
          builder: (ctx) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.blue,
                ),
                alignment: Alignment.center,
              ));

      markers.add(marker);
    }

    return markers;
  }

  double _calculateAverageDensity(List<LocationDTO> locations) {
    var itemsInHour = locations.sublist(0, 100);
    var densityList = <double>[];
    var densityAverage = 0.0;

    for (var i = 3; i < itemsInHour.length; i++) {
      var distance = _calculateDistance(locations[i - 3].lat, locations[i - 3].lon, locations[i].lat, locations[i].lon);
      var timeDifferenceInSeconds = (locations[i].date - locations[i - 3].date) / 1000 / 60;
      var density = distance * timeDifferenceInSeconds;
      densityList.add(density);
    }

    densityAverage = densityList.reduce((a, b) => a + b) / densityList.length;

    return densityAverage;
  }

  List<ProbableTransport> calculateProbableTransports(int maxSpeed, int averageSpeed) {
    if (maxSpeed > 50 && averageSpeed < 60 && averageSpeed > 10) {
      return createProbability(car: 80, tram: 20, walking: 0, bicycle: 0, unknown: 0);
    }

    if (maxSpeed > 50) {
      return createProbability(car: 20, tram: 80, walking: 0, bicycle: 0, unknown: 0);
    }

    if (maxSpeed < 30 && averageSpeed > 10) {
      return createProbability(car: 0, tram: 0, walking: 0, bicycle: 100, unknown: 0);
    }

    if (maxSpeed < 15) {
      return createProbability(car: 0, tram: 0, walking: 100, bicycle: 0, unknown: 0);
    }

    return createProbability(car: 0, tram: 0, walking: 0, bicycle: 0, unknown: 100);
  }

  List<ProbableTransport> createProbability(
      {required double car, required double tram, required double walking, required double bicycle, required double unknown}) {
    return <ProbableTransport>[
      ProbableTransport(transport: Transport.Car, probability: car),
      ProbableTransport(transport: Transport.Tram, probability: tram),
      ProbableTransport(transport: Transport.Walking, probability: walking),
      ProbableTransport(transport: Transport.Bicycle, probability: bicycle),
      ProbableTransport(transport: Transport.Unknown, probability: unknown),
    ];
  }

  getColorBasedOnCalculatedSpeed(int speed) {
    if (speed == 0) {
      return Colors.white;
    }

    if (speed == 1) {
      return Colors.grey[100];
    }

    if (speed == 2) {
      return Colors.grey[200];
    }

    if (speed == 3) {
      return Colors.grey[600];
    }

    if (speed == 4) {
      return Colors.grey[900];
    }

    if (speed == 5) {
      return Colors.black;
    }

    if (speed > 5 && speed <= 10) {
      return Colors.blue;
    }

    if (speed > 10 && speed <= 30) {
      return Colors.green;
    }

    if (speed > 30 && speed <= 50) {
      return Colors.yellow;
    }

    if (speed > 50 && speed <= 80) {
      return Colors.orange;
    }

    if (speed > 80) {
      return Colors.red;
    }
  }

  getColorBasedOnVehicleProbability(Cluster cluster, String sensor) {
    final transport = _vehicleClassifier.getProbableTransport(cluster.maxSpeed, sensor);

    if (transport == Transport.Car) {
      return Colors.blue;
    }

    if (transport == Transport.Tram) {
      return Colors.green;
    }

    if (transport == Transport.Walking) {
      return Colors.yellow;
    }

    if (transport == Transport.Bicycle) {
      return Colors.orange;
    }

    if (transport == Transport.Unknown) {
      return Colors.black;
    }
  }

  buildMovementFromCluster(List<Cluster> clusters) {
    var clusterList = List<Cluster>.empty(growable: true);
    var classified = List<ClassifiedMovement>.empty(growable: true);

    for (var cluster in clusters) {
      if (clusterList.isEmpty) {
        cluster.transport = getHighestProbabilityByCluster(cluster);
        clusterList.add(cluster);
        continue;
      }

      var previousCluster = clusterList.length > 2 ? clusterList[clusterList.length - 2] : clusterList[clusterList.length - 1];
      if (getHighestProbability(clusterList.last, previousCluster) == getHighestProbability(cluster, clusterList.last)) {
        var transport = getHighestProbability(cluster, clusterList.last);
        cluster.transport = transport;
        clusterList.add(cluster);
      } else {
        var transport = getHighestProbability(clusterList.last, clusterList[clusterList.length - 1]);

        cluster.transport = transport;

        if (classified.length > 1 &&
            classified[classified.length - 2].transport == transport &&
            classified.last.transport == Transport.Walking &&
            classified.last.endDate.difference(classified.last.startDate).inMinutes < 10) {
          var locations = clusterList.expand((element) => element.locations).toList();
          locations.addAll(classified[classified.length - 2].locations);
          locations.addAll(classified[classified.length - 1].locations);

          var movement = ClassifiedMovement(
              startDate: classified[classified.length - 2].startDate,
              endDate: clusterList.last.endtime,
              transport: transport,
              locations: locations,
              clusterCount: clusterList.length + classified[classified.length - 2].clusterCount + classified[classified.length - 1].clusterCount);

          classified.removeLast();
          classified.removeLast();

          classified.add(movement);
        } else {
          if (clusterList.length == 1 && clusterList.first.endtime.difference(clusterList.first.starttime).inMinutes < 5) {
            transport = Transport.Walking;
            cluster.transport = transport;
          }

          if (classified.length > 1 && classified.last.transport == Transport.Walking && transport == Transport.Walking) {
            classified.last.endDate = clusterList.last.endtime;
            classified.last.locations.addAll(clusterList.expand((element) => element.locations).toList());
            classified.last.clusterCount += clusterList.length;
          } else {
            var movement = ClassifiedMovement(
                startDate: clusterList.first.starttime,
                endDate: clusterList.last.endtime,
                transport: transport,
                locations: clusterList.expand((element) => element.locations).toList(),
                clusterCount: clusterList.length);

            classified.add(movement);
          }
        }

        clusterList.clear();
        clusterList.add(cluster);
      }
    }

    if (clusterList.isNotEmpty) {
      var difference = classified.last.endDate.difference(classified.last.startDate);
      var transport = getHighestProbability(clusterList.last, clusterList[clusterList.length - 1]);

      if (classified.length > 1 &&
          classified[classified.length - 2].transport == transport &&
          classified.last.transport == Transport.Walking &&
          difference.inMinutes < 10) {
        var locations = clusterList.expand((element) => element.locations).toList();
        locations.addAll(classified[classified.length - 2].locations);
        locations.addAll(classified[classified.length - 1].locations);

        var movement = ClassifiedMovement(
            startDate: classified[classified.length - 2].startDate,
            endDate: clusterList.last.endtime,
            transport: transport,
            locations: locations,
            clusterCount: clusterList.length + classified[classified.length - 2].clusterCount + classified[classified.length - 1].clusterCount);

        classified.removeLast();
        classified.removeLast();

        classified.add(movement);
      } else {
        var movement = ClassifiedMovement(
            startDate: clusterList.first.starttime,
            endDate: clusterList.last.endtime,
            transport: transport,
            locations: clusterList.expand((element) => element.locations).toList(),
            clusterCount: clusterList.length);

        classified.add(movement);
      }
    }

    return classified;
  }

  Transport getHighestProbability(Cluster cluster, Cluster previousCluster) {
    if (cluster.classifiedVehicles.isEmpty) {
      return Transport.Walking;
    }

    var list = List<ProbableTransport>.empty(growable: true);
    var highestProbality = 0.0;

    for (var probableTransport in cluster.classifiedVehicles) {
      if (probableTransport.probableTransports.first.probability > highestProbality) {
        highestProbality = probableTransport.probableTransports.first.probability;
        list.clear();
        list.add(probableTransport.probableTransports.first);
        continue;
      }

      if (probableTransport.probableTransports.first.probability == highestProbality) {
        list.add(probableTransport.probableTransports.first);
      }
    }

    if (list.length == 1) {
      return list.first.transport;
    }

    var biasedTransportIndex = list.indexWhere((element) => element.transport == previousCluster.transport);

    if (biasedTransportIndex != -1) {
      return list[biasedTransportIndex].transport;
    }

    return list.first.transport;
  }

  Transport getHighestProbabilityByCluster(Cluster cluster) {
    if (cluster.classifiedVehicles.isEmpty) {
      return Transport.Walking;
    }

    var list = List<ProbableTransport>.empty(growable: true);
    var highestProbality = 0.0;

    for (var probableTransport in cluster.classifiedVehicles) {
      if (probableTransport.probableTransports.first.probability > highestProbality) {
        highestProbality = probableTransport.probableTransports.first.probability;
        list.clear();
        list.add(probableTransport.probableTransports.first);
        continue;
      }

      if (probableTransport.probableTransports.first.probability == highestProbality) {
        list.add(probableTransport.probableTransports.first);
      }
    }

    if (list.length == 1) {
      return list.first.transport;
    }

    return list.first.transport;
  }

  LocationMapDTO createMovementVehicleMap(List<ClassifiedMovement> movements) {
    var markers = <Marker>[];

    for (var movement in movements) {
      if (movement.transport == Transport.Walking) {
        markers.addAll(doMovementMarkers(movement.locations, Colors.green));
      } else if (movement.transport == Transport.Tram) {
        markers.addAll(doMovementMarkers(movement.locations, Colors.orange));
      } else if (movement.transport == Transport.Train) {
        markers.addAll(doMovementMarkers(movement.locations, Colors.yellow));
      } else if (movement.transport == Transport.Subway) {
        markers.addAll(doMovementMarkers(movement.locations, Colors.purple));
      } else if (movement.transport == Transport.Bus) {
        markers.addAll(doMovementMarkers(movement.locations, Colors.blue));
      }
    }

    var locationMapDTO = LocationMapDTO(markers, []);

    return locationMapDTO;
  }

  List<Marker> doMovementMarkers(List<SensorGeolocationDTO> locations, Color color) {
    var markers = <Marker>[];
    for (var location in locations) {
      var marker = Marker(
          width: 5.0,
          height: 5.0,
          point: LatLng(location.lat, location.lon),
          builder: (ctx) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: color,
                ),
                alignment: Alignment.center,
              ));

      markers.add(marker);
    }

    return markers;
  }
}

class Cluster {
  List<SensorGeolocationDTO> locations;
  List<String> potentialTransport;
  DateTime starttime, endtime;
  int averageSpeed, amountOfTime, amountOfPoints, maxSpeed;
  double averageAccuracy;
  List<ProbableTransport> probableTransports;
  //List<ExtraLocationsDataDTO> extraLocationsDataDTOs, trainStopsDTOs;
  Transport transport;
  List<String> pointsOfInterest;
  Color randomColor;
  List<ClassifiedVehicleClusterDTO> classifiedVehicles;

  Cluster(this.potentialTransport, this.starttime, this.endtime, this.averageSpeed, this.amountOfTime, this.amountOfPoints, this.locations, this.maxSpeed,
      this.probableTransports, this.pointsOfInterest, this.transport, this.randomColor, this.classifiedVehicles, this.averageAccuracy);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Locations'] = locations.map((e) => e.toJson()).toList();
    data['AverageSpeed'] = averageSpeed;
    data['AmountOfTime'] = amountOfTime;
    data['AmountOfPoints'] = averageSpeed;
    data['MaxSpeed'] = maxSpeed;

    return data;
  }
}

class ClassifiedVehicleClusterDTO {
  List<ProbableTransport> probableTransports;
  List<ExtraLocationsDataDTO> extraLocationsDataDTOs;
  List<ExtraLocationsDataDTO> trainStopsDTOs;

  ClassifiedVehicleClusterDTO({required this.probableTransports, required this.extraLocationsDataDTOs, required this.trainStopsDTOs});

  factory ClassifiedVehicleClusterDTO.fromMap(Map<String, dynamic> json) => ClassifiedVehicleClusterDTO(
      probableTransports: ProbableTransport.fromList(json["probableTransports"]),
      extraLocationsDataDTOs: ExtraLocationsDataDTO.fromList(json["extraLocationsDataDTOs"]),
      trainStopsDTOs: ExtraLocationsDataDTO.fromList(json["trainStopsDTOs"] ?? []));
}

class ProbableTransport {
  Transport transport;
  double probability;

  ProbableTransport({required this.transport, required this.probability});

  static List<ProbableTransport> fromList(List<dynamic> list) {
    return list.map((item) => ProbableTransport.fromMap(item as Map<String, dynamic>)).toList();
  }

  factory ProbableTransport.fromMap(Map<String, dynamic> json) =>
      ProbableTransport(transport: enumFromString(Transport.values, json["transport"]), probability: json["probalitity"] / 1);
}

Transport enumFromString(List<Transport> values, String value) {
  return values.firstWhere((v) => v.toString().split('.')[1] == value, orElse: () => Transport.Unknown);
}

class ExtraLocationsDataDTO {
  double latitude, longitude;
  String station;
  bool trainRailCloseBy;
  int createdOn;

  ExtraLocationsDataDTO({required this.latitude, required this.longitude, required this.station, required this.trainRailCloseBy, required this.createdOn});

  static List<ExtraLocationsDataDTO> fromList(List<dynamic> list) {
    return list.map((item) => ExtraLocationsDataDTO.fromMap(item as Map<String, dynamic>)).toList();
  }

  factory ExtraLocationsDataDTO.fromMap(Map<String, dynamic> json) => ExtraLocationsDataDTO(
      latitude: json["latitude"],
      longitude: json["longitude"],
      station: json["station"],
      trainRailCloseBy: json["trainRailCloseBy"],
      createdOn: json["createdOn"]);
}
