import 'dart:math';

import 'package:desktop/infastructure/period_classifier/accuracy_classifier.dart';
import 'package:desktop/infastructure/period_classifier/density_threshold_classifier.dart';
import 'package:desktop/infastructure/period_classifier/enums/transport_enum.dart';
import 'package:desktop/infastructure/period_classifier/poi_classifier.dart';
import 'package:desktop/infastructure/period_classifier/reason_classifier.dart';
import 'package:desktop/infastructure/period_classifier/sensor_classifier.dart';
import 'package:desktop/infastructure/repositories/database/database.dart';
import 'package:desktop/infastructure/repositories/dtos/classified_period_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/movement_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/stop_dto.dart';
import 'package:desktop/infastructure/repositories/network/google_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../presentation/theme/icon_mapper.dart';
import '../period_classifier/vehicle_classifier.dart';
import '../repositories/dtos/location_map_dto.dart';
import '../repositories/dtos/sensor_geolocation_dto.dart';
import 'cluster_notifier.dart';
import 'density_cluster_notifier.dart';
import 'generic_notifier.dart';

class ClassifierNotifier extends StateNotifier<NotifierState> {
  final SensorClassifier _sensorClassifier;
  final AccuracyClassifier _accuracyClassifier;
  final VehicleClassifier _vehicleClassifier;
  final ReasonClassifier _reasonClassifier;
  final GoogleApi _googleApi;
  final POIClassifier _poiClassifier;
  final DensityThresholdClassifier _densityThresholdClassifier;

  ClassifierNotifier(this._sensorClassifier, this._accuracyClassifier, this._vehicleClassifier, this._reasonClassifier, this._googleApi, this._poiClassifier,
      this._densityThresholdClassifier)
      : super(const Initial());

  classify(List<List<SensorGeolocationDTO>> data) async {
    //final densityClusters = List<DensityCluster>.empty(growable: true);
    final classifiedPeriods = <ClassifiedPeriodDto>[];
    final sensorGeoLocationDataFromBestSensor = _sensorClassifier.getBestSensor(data);
    final averageDensity = _calculateAverageDensity(sensorGeoLocationDataFromBestSensor);
    final accuracyThreshold = _accuracyClassifier.getAccuracyThreshold(sensorGeoLocationDataFromBestSensor);
    final groupedClusters = List<List<DensityCluster>>.empty(growable: true);
    final group = List<DensityCluster>.empty(growable: true);
    final movementClusters = List<Cluster>.empty(growable: true);
    var movementCounter = 0;
    var moving = false;
    var color = Colors.blue;
    var densityCounter = 0;

    sensorGeoLocationDataFromBestSensor.removeWhere((element) => element.accuracy > accuracyThreshold);

    for (var i = 1; i < sensorGeoLocationDataFromBestSensor.length; i++) {
      //calculate fundamental properties like speed and density
      var distance = _calculateDistance(sensorGeoLocationDataFromBestSensor[i - 1].lat, sensorGeoLocationDataFromBestSensor[i - 1].lon,
          sensorGeoLocationDataFromBestSensor[i].lat, sensorGeoLocationDataFromBestSensor[i].lon);
      sensorGeoLocationDataFromBestSensor[i].calculatedSpeed =
          _calculateSpeed(sensorGeoLocationDataFromBestSensor[i - 1].createdOn, sensorGeoLocationDataFromBestSensor[i].createdOn, distance);

      if (i < 3) {
        continue;
      }

      sensorGeoLocationDataFromBestSensor[i].density =
          _calculateDensity(sensorGeoLocationDataFromBestSensor[i], sensorGeoLocationDataFromBestSensor[i - 3], distance);

      //distill density clusters
      var isAccurate = sensorGeoLocationDataFromBestSensor[i].accuracy < 20; //TODO:: accuracyThreshold should be calculated

      //Here we calculate a stop based on density points and clusters
      //TODO:: densityTreshold should be calculated
      if (sensorGeoLocationDataFromBestSensor[i].density > 10 && isAccurate) {
        var cluster = await distillCluster(sensorGeoLocationDataFromBestSensor[i], group.isNotEmpty ? group.last : null);

        //Check if the new cluster is no longer part of the current cluster group
        if (group.isNotEmpty && cluster.distanceFromPreviousPoint > 200) {
          //Create a new classified stop period to the list from the current group
          //var response = await _googleApi.getPlaceRadiusDetails(group.first.location.lat, group.first.location.lon);
          final reason = _reasonClassifier.getPossibleReason(group.expand((g) => g.pointsOfInterest).toList());
          //final isGroupInteresting = _poiClassifier.IsClusterInteresting(response.payload!.pointsOfInterest);

          //if (isGroupInteresting) {
          final googleMapsData = GoogleMapsData(address: "", city: "", name: "Onbekend", postcode: "");
          final startDate = DateTime.fromMillisecondsSinceEpoch(group.first.location.createdOn);
          final endDate = DateTime.fromMillisecondsSinceEpoch(group.last.location.createdOn);
          final classifiedPeriod =
              ClassifiedPeriod(startDate: startDate, endDate: endDate, confirmed: false, createdOn: DateTime.now(), synced: false, type: 0, userId: 0);
          final sensorGeolocations = group.map((g) => g.location).toList();
          final stopDTO = StopDto(
              stopId: 0,
              reason: reason,
              googleMapsData: googleMapsData,
              classifiedPeriod: classifiedPeriod,
              manualGeolocations: [],
              sensorGeolocations: sensorGeolocations,
              color: color);

          classifiedPeriods.add(stopDTO);
          //}

          //reset the group
          group.clear();
          color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
        } else {
          //Group the clusters that are within a certain distance - currently 100 meters

          cluster.color = color;

          //the cluster is still part of the group. Gather relevant data like points of interest
          //var response = await _googleApi.getPlaceRadiusDetails(clusters[i].location.lat, clusters[i].location.lon);
          //clusters[i].pointsOfInterest = response.payload!.pointsOfInterest.toSet().toList();
          //clusters[i].place = response.payload!.place;

          group.add(cluster);
        }

        //group.add(cluster);
        densityCounter = i;
      }

      //Here we calculate a movement
      if (i % 5 == 0) {
        //get the median speed of the last 5 sensor geolocation points
        var medianSpeed = getMedian(sensorGeoLocationDataFromBestSensor.sublist(i - 5, i));
        for (var j = 0; j < 5; j++) {
          //through the median speed we calculate if a phone has stopped moving
          var isMoving = this.isMoving(medianSpeed, sensorGeoLocationDataFromBestSensor.first.sensorType);
          var stoppedMoving = this.stoppedMoving(isMoving, moving);
          var counterIsBigEnough = i + j - movementCounter > 30;

          if (stoppedMoving) {
            var movementCluster = distillMovementCluster(sensorGeoLocationDataFromBestSensor.sublist(movementCounter, i + j));

            if (movementClusters.isNotEmpty) {
              if (movementClusters.last.transport == movementCluster.transport) {
                movementClusters.add(movementCluster);
              } else {
                final startDate = DateTime.fromMillisecondsSinceEpoch(movementClusters.expand((c) => c.locations).first.createdOn);
                final endDate = DateTime.fromMillisecondsSinceEpoch(movementClusters.expand((c) => c.locations).last.createdOn);
                final classifiedPeriod =
                    ClassifiedPeriod(startDate: startDate, endDate: endDate, confirmed: false, createdOn: DateTime.now(), synced: false, type: 0, userId: 0);
                final vehicle = _vehicleClassifier.getPossibleVehicle(movementClusters.first);
                final sensorGeolocations = movementClusters.expand((c) => c.locations).toList();
                final movementDto = MovementDto(
                    movementId: 0, vehicle: vehicle, classifiedPeriod: classifiedPeriod, manualGeolocations: [], sensorGeolocations: sensorGeolocations);

                classifiedPeriods.add(movementDto);

                movementClusters.clear();
                movementClusters.add(movementCluster);
              }
            } else {
              movementClusters.add(movementCluster);
            }
          }

          if (startedMoving(isMoving, moving)) {
            movementCounter = i + j;
          }

          moving = isMoving;
        }
      }
    }

    //clear movementClusters
    if (movementClusters.isNotEmpty) {
      final startDate = DateTime.fromMillisecondsSinceEpoch(movementClusters.expand((c) => c.locations).first.createdOn);
      final endDate = DateTime.fromMillisecondsSinceEpoch(movementClusters.expand((c) => c.locations).last.createdOn);
      final classifiedPeriod =
          ClassifiedPeriod(startDate: startDate, endDate: endDate, confirmed: false, createdOn: DateTime.now(), synced: false, type: 0, userId: 0);
      final vehicle = _vehicleClassifier.getPossibleVehicle(movementClusters.first);
      final sensorGeolocations = movementClusters.expand((c) => c.locations).toList();
      final movementDto =
          MovementDto(movementId: 0, vehicle: vehicle, classifiedPeriod: classifiedPeriod, manualGeolocations: [], sensorGeolocations: sensorGeolocations);

      classifiedPeriods.add(movementDto);
      movementClusters.clear();
    }

    //clear densityClusters
    if (group.isNotEmpty) {
      var response = await _googleApi.getPlaceRadiusDetails(group.first.location.lat, group.first.location.lon);
      final reason = _reasonClassifier.getPossibleReason(group.expand((g) => g.pointsOfInterest).toList());
      final isGroupInteresting = _poiClassifier.IsClusterInteresting(response.payload!.pointsOfInterest);

      if (isGroupInteresting) {
        final googleMapsData = GoogleMapsData(address: "", city: "", name: response.payload!.place, postcode: "");
        final startDate = DateTime.fromMillisecondsSinceEpoch(group.first.location.createdOn);
        final endDate = DateTime.fromMillisecondsSinceEpoch(group.last.location.createdOn);
        final classifiedPeriod =
            ClassifiedPeriod(startDate: startDate, endDate: endDate, confirmed: false, createdOn: DateTime.now(), synced: false, type: 0, userId: 0);
        final sensorGeolocations = group.map((g) => g.location).toList();
        final stopDTO = StopDto(
            stopId: 0,
            reason: reason,
            googleMapsData: googleMapsData,
            classifiedPeriod: classifiedPeriod,
            manualGeolocations: [],
            sensorGeolocations: sensorGeolocations,
            color: color);

        classifiedPeriods.add(stopDTO);
      }

      group.clear();
    }

    state = Loaded<List<ClassifiedPeriodDto>>(classifiedPeriods);
  }

  classifyAllSensors(List<List<SensorGeolocationDTO>> data) async {
    //final densityClusters = List<DensityCluster>.empty(growable: true);
    final allClassifiedPeriods = <List<ClassifiedPeriodDto>>[];

    for (var sensorGeoLocationDataFromBestSensor in data) {
      if (sensorGeoLocationDataFromBestSensor.isEmpty) {
        allClassifiedPeriods.add([]);
        continue;
      }

      final classifiedPeriods = <ClassifiedPeriodDto>[];
      final tempStops = <StopDto>[];
      final averageDensity = _calculateAverageDensity(sensorGeoLocationDataFromBestSensor);
      final accuracyThreshold = _accuracyClassifier.getAccuracyThreshold(sensorGeoLocationDataFromBestSensor);
      var densityThreshold = _densityThresholdClassifier.calculateDensityThreshhold(sensorGeoLocationDataFromBestSensor.first.sensorType);
      final groupedClusters = List<List<DensityCluster>>.empty(growable: true);
      final group = List<DensityCluster>.empty(growable: true);
      final movementClusters = List<Cluster>.empty(growable: true);
      var movementCounter = 0;
      var moving = false;
      var color = Colors.blue;
      var densityCounter = 0;

      sensorGeoLocationDataFromBestSensor.removeWhere((element) => element.accuracy > accuracyThreshold);

      for (var i = 1; i < sensorGeoLocationDataFromBestSensor.length; i++) {
        //calculate fundamental properties like speed and density
        var distance = _calculateDistance(sensorGeoLocationDataFromBestSensor[i - 1].lat, sensorGeoLocationDataFromBestSensor[i - 1].lon,
            sensorGeoLocationDataFromBestSensor[i].lat, sensorGeoLocationDataFromBestSensor[i].lon);
        sensorGeoLocationDataFromBestSensor[i].calculatedSpeed =
            _calculateSpeed(sensorGeoLocationDataFromBestSensor[i - 1].createdOn, sensorGeoLocationDataFromBestSensor[i].createdOn, distance);

        if (i < 3) {
          continue;
        }

        sensorGeoLocationDataFromBestSensor[i].density =
            _calculateDensity(sensorGeoLocationDataFromBestSensor[i], sensorGeoLocationDataFromBestSensor[i - 3], distance);

        //distill density clusters
        var isAccurate = sensorGeoLocationDataFromBestSensor[i].accuracy < 20; //TODO:: accuracyThreshold should be calculated

        //Here we calculate a stop based on density points and clusters
        //TODO:: densityTreshold should be calculated
        if (sensorGeoLocationDataFromBestSensor[i].density > densityThreshold && isAccurate) {
          var cluster = await distillCluster(sensorGeoLocationDataFromBestSensor[i], group.isNotEmpty ? group.last : null);

          //Check if the new cluster is no longer part of the current cluster group
          if (group.isNotEmpty && cluster.distanceFromPreviousPoint > 200) {
            //Create a new classified stop period to the list from the current group
            //var response = await _googleApi.getPlaceRadiusDetails(group.first.location.lat, group.first.location.lon);
            final reason = _reasonClassifier.getPossibleReason(group.expand((g) => g.pointsOfInterest).toList());
            //final isGroupInteresting = _poiClassifier.IsClusterInteresting(response.payload!.pointsOfInterest);

            //if (isGroupInteresting) {
            final googleMapsData = GoogleMapsData(address: "", city: "", name: "Onbekend", postcode: "");
            final startDate = DateTime.fromMillisecondsSinceEpoch(group.first.location.createdOn);
            final endDate = DateTime.fromMillisecondsSinceEpoch(group.last.location.createdOn);
            final classifiedPeriod =
                ClassifiedPeriod(startDate: startDate, endDate: endDate, confirmed: false, createdOn: DateTime.now(), synced: false, type: 0, userId: 0);
            final sensorGeolocations = group.map((g) => g.location).toList();
            final stopDTO = StopDto(
                stopId: 0,
                reason: reason,
                googleMapsData: googleMapsData,
                classifiedPeriod: classifiedPeriod,
                manualGeolocations: [],
                sensorGeolocations: sensorGeolocations,
                color: color);

            tempStops.add(stopDTO);
            //}

            //reset the group
            group.clear();
            color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
          } else {
            //Group the clusters that are within a certain distance - currently 100 meters

            cluster.color = color;

            //the cluster is still part of the group. Gather relevant data like points of interest
            //var response = await _googleApi.getPlaceRadiusDetails(clusters[i].location.lat, clusters[i].location.lon);
            //clusters[i].pointsOfInterest = response.payload!.pointsOfInterest.toSet().toList();
            //clusters[i].place = response.payload!.place;

            group.add(cluster);
          }

          //group.add(cluster);
          densityCounter = i;
        }

        //Here we calculate a movement
        if (i % 5 == 0) {
          //get the median speed of the last 5 sensor geolocation points
          var medianSpeed = getMedian(sensorGeoLocationDataFromBestSensor.sublist(i - 5, i));
          for (var j = 0; j < 5; j++) {
            //through the median speed we calculate if a phone has stopped moving
            var isMoving = this.isMoving(medianSpeed, sensorGeoLocationDataFromBestSensor.first.sensorType);
            var stoppedMoving = this.stoppedMoving(isMoving, moving);
            var counterIsBigEnough = i + j - movementCounter > 30;

            if (stoppedMoving) {
              var movementCluster = distillMovementCluster(sensorGeoLocationDataFromBestSensor.sublist(movementCounter, i + j));

              if (movementClusters.isNotEmpty) {
                if (movementCluster.transport == Transport.Walking) {
                  classifiedPeriods.addAll(tempStops);
                }
                tempStops.clear();

                if (movementClusters.last.transport == movementCluster.transport) {
                  movementClusters.add(movementCluster);
                } else {
                  final startDate = DateTime.fromMillisecondsSinceEpoch(movementClusters.expand((c) => c.locations).first.createdOn);
                  final endDate = DateTime.fromMillisecondsSinceEpoch(movementClusters.expand((c) => c.locations).last.createdOn);
                  final classifiedPeriod =
                      ClassifiedPeriod(startDate: startDate, endDate: endDate, confirmed: false, createdOn: DateTime.now(), synced: false, type: 0, userId: 0);
                  final vehicle = _vehicleClassifier.getPossibleVehicle(movementClusters.last);
                  final sensorGeolocations = movementClusters.expand((c) => c.locations).toList();
                  final color = getColorBasedOnVehicleProbability(movementClusters.first, sensorGeoLocationDataFromBestSensor.first.sensorType);
                  final movementDto = MovementDto(
                      movementId: 0,
                      vehicle: vehicle,
                      classifiedPeriod: classifiedPeriod,
                      manualGeolocations: [],
                      sensorGeolocations: sensorGeolocations,
                      color: color);

                  classifiedPeriods.add(movementDto);

                  movementClusters.clear();
                  movementClusters.add(movementCluster);
                }
              } else {
                movementClusters.add(movementCluster);
              }
            }

            if (startedMoving(isMoving, moving)) {
              movementCounter = i + j;
            }

            moving = isMoving;
          }
        }
      }

      //clear movementClusters
      if (movementClusters.isNotEmpty) {
        final startDate = DateTime.fromMillisecondsSinceEpoch(movementClusters.expand((c) => c.locations).first.createdOn);
        final endDate = DateTime.fromMillisecondsSinceEpoch(movementClusters.expand((c) => c.locations).last.createdOn);
        final classifiedPeriod =
            ClassifiedPeriod(startDate: startDate, endDate: endDate, confirmed: false, createdOn: DateTime.now(), synced: false, type: 0, userId: 0);
        final vehicle = _vehicleClassifier.getPossibleVehicle(movementClusters.first);
        final sensorGeolocations = movementClusters.expand((c) => c.locations).toList();
        final color = getColorBasedOnVehicleProbability(movementClusters.first, sensorGeoLocationDataFromBestSensor.first.sensorType);
        final movementDto = MovementDto(
            movementId: 0, vehicle: vehicle, classifiedPeriod: classifiedPeriod, manualGeolocations: [], sensorGeolocations: sensorGeolocations, color: color);

        classifiedPeriods.add(movementDto);
        movementClusters.clear();
      }

      //clear densityClusters
      if (group.isNotEmpty) {
        var response = await _googleApi.getPlaceRadiusDetails(group.first.location.lat, group.first.location.lon);
        final reason = _reasonClassifier.getPossibleReason(group.expand((g) => g.pointsOfInterest).toList());
        final isGroupInteresting = _poiClassifier.IsClusterInteresting([]);

        if (isGroupInteresting) {
          final googleMapsData = GoogleMapsData(address: "", city: "", name: response.payload!.place, postcode: "");
          final startDate = DateTime.fromMillisecondsSinceEpoch(group.first.location.createdOn);
          final endDate = DateTime.fromMillisecondsSinceEpoch(group.last.location.createdOn);
          final classifiedPeriod =
              ClassifiedPeriod(startDate: startDate, endDate: endDate, confirmed: false, createdOn: DateTime.now(), synced: false, type: 0, userId: 0);
          final sensorGeolocations = group.map((g) => g.location).toList();
          final stopDTO = StopDto(
              stopId: 0,
              reason: reason,
              googleMapsData: googleMapsData,
              classifiedPeriod: classifiedPeriod,
              manualGeolocations: [],
              sensorGeolocations: sensorGeolocations,
              color: color);

          classifiedPeriods.add(stopDTO);
        }

        group.clear();
      }

      allClassifiedPeriods.add(classifiedPeriods);
    }

    state = Loaded<List<List<ClassifiedPeriodDto>>>(allClassifiedPeriods);
  }

  List<Cluster> createCalculatedSpeedCluster(List<SensorGeolocationDTO> data) {
    final clusters = List<Cluster>.empty(growable: true);
    var movementCounter = 0;
    var moving = false;

    data.removeWhere((element) => element.accuracy > 30);

    for (var i = 0; i < data.length - 5; i += 5) {
      var medianSpeed = getMedian(data.sublist(i, i + 5));
      for (var j = 0; j < 5; j++) {
        var isMoving = this.isMoving(medianSpeed, data.first.sensorType);
        var stoppedMoving = this.stoppedMoving(isMoving, moving);
        var counterIsBigEnough = i + j - movementCounter > 30;

        if (stoppedMoving) {
          var cluster = distillMovementCluster(data.sublist(movementCounter, i + j));

          clusters.add(cluster);
        }

        if (startedMoving(isMoving, moving)) {
          movementCounter = i + j;
        }

        moving = isMoving;
      }
    }

    return clusters;
  }

  double _calculateDensity(SensorGeolocationDTO currentLocation, SensorGeolocationDTO previousLocation, double distance) {
    var timeDifferenceInSeconds = (currentLocation.createdOn - previousLocation.createdOn) / 1000 / 60;
    var density = distance * timeDifferenceInSeconds;

    return density;
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

  double _calculateSpeed(int startTime, int endTime, double distance) {
    var startDate = DateTime.fromMillisecondsSinceEpoch(startTime);
    var endDate = DateTime.fromMillisecondsSinceEpoch(endTime);

    var timeDifferenceInSeconds = (endTime - startTime) / 1000;
    var speed = distance / timeDifferenceInSeconds;

    return speed * 3.6;
  }

  bool stoppedMoving(bool isMoving, bool moving) {
    return !isMoving && moving;
  }

  bool startedMoving(bool isMoving, bool moving) {
    return isMoving && !moving;
  }

  bool isMoving(int calculatedSpeed, String sensor) {
    final isMovingThreshold = _accuracyClassifier.getMovingThreshold(sensor);
    return calculatedSpeed > isMovingThreshold;
  }

  int getMedian(List<SensorGeolocationDTO> locations) {
    locations.sort((a, b) => a.calculatedSpeed.compareTo(b.calculatedSpeed));
    var median = locations[2].calculatedSpeed;

    return median.isNaN || median.isInfinite ? 0 : median.toInt();
  }

  Cluster distillMovementCluster(List<SensorGeolocationDTO> data) {
    var aSpeed = data.map((m) => m.calculatedSpeed).reduce((a, b) => a + b) / data.length;
    var aAccuracy = data.map((m) => m.accuracy).reduce((a, b) => a + b) / data.length;
    var mSpeed = data.map((d) => d.calculatedSpeed).reduce(max);

    var averageSpeed = aSpeed.isNaN || aSpeed.isInfinite ? 0 : aSpeed.toInt();
    var averageAccuracy = aAccuracy.isNaN || aAccuracy.isInfinite ? 0 : aAccuracy.toInt();
    var maxSpeed = mSpeed.isNaN || mSpeed.isInfinite ? 0 : mSpeed.toInt();
    var amountOfTime = (data.last.createdOn - data.first.createdOn) / 1000;
    var probableTransport = _vehicleClassifier.getProbableTransport(averageSpeed.toInt(), data.first.sensorType);
    var cluster = Cluster([""], DateTime.now(), DateTime.now(), averageSpeed.toInt(), amountOfTime.toInt(), data.length, data, maxSpeed.toInt(), [], [],
        probableTransport, Colors.black, [], averageAccuracy / 1);

    return cluster;
  }

  LocationMapDTO getClassifiedMapDTO(List<ClassifiedPeriodDto> data) {
    var locationMapDTO = LocationMapDTO(_getMarkers(data), _getPolylines(data));

    return locationMapDTO;
  }

  List<Polyline> _getPolylines(List<ClassifiedPeriodDto> data) {
    var latlngs = <Polyline>[];

    for (var period in data) {
      if (period is MovementDto) {
        var polyline = Polyline(strokeWidth: 2.0, color: period.color!, points: []);
        for (var location in period.sensorGeolocations) {
          polyline.points.add(LatLng(location.lat, location.lon));
        }
        latlngs.add(polyline);
      }
    }

    return latlngs;
  }

  List<Marker> _getMarkers(List<ClassifiedPeriodDto> data) {
    var markers = <Marker>[];

    for (var period in data) {
      if (period is StopDto) {
        var marker = Marker(
            width: 30.0,
            height: 30.0,
            point: LatLng(period.centroid.latitude, period.centroid.longitude),
            builder: (ctx) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.white,
                  ),
                  alignment: Alignment.center,
                  child: FaIconMapper.getFaIcon(null),
                ));

        markers.add(marker);
      }
    }

    return markers;
  }

  getColorBasedOnVehicleProbability(Cluster cluster, String sensor) {
    final transport = _vehicleClassifier.getProbableTransport(cluster.averageSpeed, sensor);

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
}
