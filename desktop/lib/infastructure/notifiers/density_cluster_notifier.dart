import 'dart:math';

import 'package:desktop/infastructure/repositories/network/google_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../period_classifier/enums/transport_enum.dart';
import '../repositories/dtos/location_dto.dart';
import '../repositories/dtos/location_map_dto.dart';
import '../repositories/dtos/sensor_geolocation_dto.dart';
import 'cluster_notifier.dart';
import 'generic_notifier.dart';

class DensityClusterNotifier extends StateNotifier<NotifierState> {
  final GoogleApi _googleApi;

  DensityClusterNotifier(this._googleApi) : super(const Initial());

  //fused
  //normal
  //balanced
  Future createClusters(List<List<SensorGeolocationDTO>> data) async {
    state = const Loading();

    var bestLocationData = getBestSensor(data);
    var clusters = await createDensityCluster(bestLocationData);

    state = Loaded<List<List<DensityCluster>>>(clusters);
  }

  LocationMapDTO getLocationMap(List<List<DensityCluster>> clusters) {
    var markers = _getMarkers(clusters);

    return LocationMapDTO(markers, []);
  }

  Future<List<List<DensityCluster>>> createDensityCluster(List<SensorGeolocationDTO> data) async {
    if (data.length < 100) {
      return [];
    }

    final clusters = List<DensityCluster>.empty(growable: true);
    var averageDensity = _calculateAverageDensity(data);
    var counter = 0;

    //Create clusters
    for (var i = 3; i < data.length; i++) {
      var isAccurate = data[i].accuracy < 20;

      if (data[i].density > 3 && isAccurate) {
        var cluster = await distillCluster(data[i], clusters.isNotEmpty ? clusters.last : null);

        clusters.add(cluster);
        counter = i;
      }
    }

    var groupedClusters = List<List<DensityCluster>>.empty(growable: true);
    var group = List<DensityCluster>.empty(growable: true);
    var color = Colors.blue;

    //Group clusters
    for (var i = 0; i < clusters.length; i++) {
      if (clusters[i].distanceFromPreviousPoint < 100) {
        clusters[i].color = color;

        if (group.isEmpty) {
          //var response = await _googleApi.getPlaceRadiusDetails(clusters[i].location.lat, clusters[i].location.lon);
          //clusters[i].pointsOfInterest = response.payload!.pointsOfInterest.toSet().toList();
          //clusters[i].place = response.payload!.place;
        }

        group.add(clusters[i]);
      } else if (group.isNotEmpty) {
        groupedClusters.add(group.toList());
        group.clear();
        color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
      }
    }

    if (group.isNotEmpty) {
      groupedClusters.add(group.toList());
      group.clear();
    }

    return groupedClusters;
  }

  List<SensorGeolocationDTO> getBestSensor(List<List<SensorGeolocationDTO>> list) {
    if (list.isEmpty || list[0].isEmpty) {
      return [];
    }

    var firstDateInList = DateTime.fromMillisecondsSinceEpoch(list[0][0].createdOn);
    var days = List<List<int>>.empty(growable: true);
    var actualCounters = List<int>.empty(growable: true);
    var highest = 0;
    var index = 0;

    for (var i = 0; i < list.length; i++) {
      var date = DateTime(firstDateInList.year, firstDateInList.month, firstDateInList.day, 0);
      var counter = List<int>.empty(growable: true);
      var actualCount = 0;

      for (var h = 1; h <= 24; h++) {
        var itemsInHour = list[i]
            .where((element) => element.createdOn >= date.millisecondsSinceEpoch && element.createdOn <= date.millisecondsSinceEpoch + (3600 * 1000))
            .toList();

        counter.add(itemsInHour.length);
        date = date.add(const Duration(hours: 1));

        if (itemsInHour.length > 40) {
          actualCount++;
        }
      }

      actualCounters.add(actualCount);

      if (actualCount > highest) {
        highest = actualCount;
        index = i;
      }

      days.add(counter);
    }

    return list[index];
  }

  bool stoppedMoving(bool isMoving, bool moving) {
    return !isMoving && moving;
  }

  bool startedMoving(bool isMoving, bool moving) {
    return isMoving && !moving;
  }

  bool isMoving(int calculatedSpeed) {
    return calculatedSpeed > 0;
  }

  int getMedian(List<LocationDTO> locations) {
    locations.sort((a, b) => a.calculatedSpeed.compareTo(b.calculatedSpeed));
    var median = locations[2].calculatedSpeed;

    return median.toInt();
  }

  Future<DensityCluster> distillCluster(SensorGeolocationDTO data, DensityCluster? previousCluster) async {
    var distanceFromPreviousCluster =
        previousCluster != null ? _calculateDistance(data.lat, data.lon, previousCluster.location.lat, previousCluster.location.lon) : 0.0;
    //var response = await _googleApi.getPlaceDetails(data.lat, data.lon);
    var cluster = DensityCluster(distanceFromPreviousCluster, [], data, Colors.primaries[Random().nextInt(Colors.primaries.length)], "");

    return cluster;
  }

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
      var polyline = Polyline(strokeWidth: 4.0, color: randomGenerator(), points: []);

      for (var location in cluster.locations) {
        polyline.points.add(LatLng(location.lat, location.lon));
      }

      latlngs.add(polyline);
    }

    var locationMapDTO = LocationMapDTO(_getMarkers(clusters.isNotEmpty ? [] : []), latlngs);

    return locationMapDTO;
  }

  Color randomGenerator() {
    final List<Color> circleColors = [Colors.red, Colors.blue, Colors.green, Colors.purple, Colors.yellow, Colors.orange, Colors.brown];
    final color = circleColors[Random().nextInt(6)];

    return color;
  }

  List<Marker> _getMarkers(List<List<DensityCluster>> groupedClusters) {
    var markers = <Marker>[];

    for (var clusters in groupedClusters) {
      for (var cluster in clusters) {
        var marker = Marker(
            width: 5.0,
            height: 5.0,
            point: LatLng(cluster.location.lat, cluster.location.lon),
            builder: (ctx) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: cluster.color,
                  ),
                  alignment: Alignment.center,
                ));

        markers.add(marker);
      }
    }

    return markers;
  }

  double _calculateAverageDensity(List<SensorGeolocationDTO> locations) {
    var itemsInHour = locations;
    var densityList = <double>[];
    var densityAverage = 0.0;

    for (var i = 3; i < itemsInHour.length; i++) {
      var distance = _calculateDistance(locations[i - 3].lat, locations[i - 3].lon, locations[i].lat, locations[i].lon);
      var timeDifferenceInSeconds = (locations[i].createdOn - locations[i - 3].createdOn) / 1000 / 60;
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
}

class DensityCluster {
  double distanceFromPreviousPoint;
  List<String> pointsOfInterest;
  SensorGeolocationDTO location;
  String place;
  Color color;

  DensityCluster(this.distanceFromPreviousPoint, this.pointsOfInterest, this.location, this.color, this.place);
}
