import 'package:desktop/infastructure/period_classifier/vehicle_classifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../repositories/dtos/location_map_dto.dart';
import '../repositories/dtos/sensor_geolocation_dto.dart';
import 'cluster_notifier.dart';
import 'generic_notifier.dart';

class VehicleNotifier extends StateNotifier<NotifierState> {
  final VehicleClassifier _vehicleClassifier;

  VehicleNotifier(this._vehicleClassifier) : super(const Initial());

  LocationMapDTO createLocationMap(List<Cluster> clusters) {
    var latlngs = <Polyline>[];

    for (var cluster in clusters) {
      var polyline = Polyline(strokeWidth: 4.0, color: getColorBasedOnCalculatedSpeed(cluster.averageSpeed), points: []);

      for (var location in cluster.locations) {
        polyline.points.add(LatLng(location.lat, location.lon));
      }

      latlngs.add(polyline);
    }

    var locationMapDTO = LocationMapDTO(_getMarkers(clusters.isNotEmpty ? [clusters[0].locations[0]] : []), latlngs);

    return locationMapDTO;
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
}
