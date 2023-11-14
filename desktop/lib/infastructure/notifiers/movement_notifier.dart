import 'package:desktop/infastructure/repositories/dtos/sensor_geolocation_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../period_classifier/enums/transport_enum.dart';
import '../repositories/dtos/location_map_dto.dart';
import 'cluster_notifier.dart';
import 'generic_notifier.dart';

class MovementNotifier extends StateNotifier<NotifierState> {
  MovementNotifier() : super(const Initial());

  buildMovementFromCluster(List<Cluster> clusters) {
    var clusterList = List<Cluster>.empty(growable: true);
    var classified = List<ClassifiedBase>.empty(growable: true);

    for (var cluster in clusters) {
      if (clusterList.isEmpty || getHighestProbability(clusterList.last) == getHighestProbability(cluster)) {
        clusterList.add(cluster);
      } else {
        var movement = ClassifiedMovement(
            startDate: clusterList.first.starttime,
            endDate: clusterList.last.endtime,
            transport: getHighestProbability(clusterList.last),
            locations: clusterList.expand((element) => element.locations).toList(),
            clusterCount: clusterList.length);

        classified.add(movement);
        clusterList.clear();
      }
    }

    // var movement = ClassifiedMovement(
    //     startDate: DateTime.fromMillisecondsSinceEpoch(sublist.first.createdOn),
    //     endDate: DateTime.fromMillisecondsSinceEpoch(sublist.last.createdOn),
    //     transport: Transport.Train,
    //     locations: sublist,
    //     clusterCount: groupedClusters.length);

    // var movement = ClassifiedMovement(
    //     startDate: DateTime.fromMillisecondsSinceEpoch(locations.first.createdOn),
    //     endDate: DateTime.fromMillisecondsSinceEpoch(locations.last.createdOn),
    //     transport: Transport.Train,
    //     locations: locations,
    //     clusterCount: groupedClusters.length);

    state = Loaded<List<ClassifiedBase>>(classified);
  }

  Transport getHighestProbability(Cluster cluster) {
    if (cluster.classifiedVehicles.isEmpty) {
      return Transport.Walking;
    }

    var vehicle =
        cluster.classifiedVehicles.reduce((curr, next) => curr.probableTransports.first.probability > next.probableTransports.first.probability ? curr : next);
    var transport = vehicle.probableTransports.first.transport;

    return transport;
  }

  LocationMapDTO createVehicleMap(List<ClassifiedMovement> movements) {
    var markers = <Marker>[];

    for (var movement in movements) {
      if (movement.transport == Transport.Walking) {
        markers.addAll(doMarkers(movement.locations, Colors.green));
      } else if (movement.transport == Transport.Tram) {
        markers.addAll(doMarkers(movement.locations, Colors.orange));
      } else if (movement.transport == Transport.Train) {
        markers.addAll(doMarkers(movement.locations, Colors.yellow));
      } else if (movement.transport == Transport.Subway) {
        markers.addAll(doMarkers(movement.locations, Colors.purple));
      } else if (movement.transport == Transport.Bus) {
        markers.addAll(doMarkers(movement.locations, Colors.blue));
      }
    }

    var locationMapDTO = LocationMapDTO(markers, []);

    return locationMapDTO;
  }

  List<Marker> doMarkers(List<SensorGeolocationDTO> locations, Color color) {
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

class ClassifiedMovement extends ClassifiedBase {
  Transport transport;
  int clusterCount;
  List<SensorGeolocationDTO> locations;

  ClassifiedMovement({required this.locations, required this.clusterCount, required this.transport, required super.startDate, required super.endDate})
      : super();
}

class ClassifiedStop extends ClassifiedBase {
  String name;
  double lat, lon;

  ClassifiedStop({required this.name, required this.lat, required this.lon, required super.startDate, required super.endDate}) : super();
}

class ClassifiedBase {
  DateTime startDate, endDate;

  ClassifiedBase({required this.startDate, required this.endDate});
}
