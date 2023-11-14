import 'package:desktop/infastructure/notifiers/mock_database.dart';
import 'package:desktop/infastructure/notifiers/sensor_data.dart';
import 'package:desktop/infastructure/notifiers/sensor_data_repository.dart';
import 'package:desktop/infastructure/notifiers/tom_classification_notifier.dart';
import 'package:desktop/infastructure/repositories/dtos/tracked_location_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/tracked_movement_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/tracked_movement_latlon_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../repositories/dtos/location_map_dto.dart';
import '../repositories/dtos/user_test_day_data_dto.dart';
import 'generic_notifier.dart';

class TestCaseTomAlgoDetailNotifier extends StateNotifier<NotifierState> {
  late MockDatabase mockDatabase;
  late SensorDataRepository sensorDataRepository;
  late ClassificationNotifier classificationNotifier;

  List<TrackedLocationDTO> results = [];

  TestCaseTomAlgoDetailNotifier() : super(const Initial()) {
    mockDatabase = MockDatabase();
    sensorDataRepository = SensorDataRepository(mockDatabase);
    classificationNotifier = ClassificationNotifier(sensorDataRepository);
  }

  Future showOnMapAsync(UserTestDayDataDTO testCaseDTO) async {
    state = const Loading();
    var generatedLocations = <TrackedLocationDTO>[];

    for (final locationDTO in testCaseDTO.rawdata) {
      var _sensorData = SensorData.fromLocationDTO(locationDTO);
      await classificationNotifier.classify(_sensorData);
    }

    var _rawResults = mockDatabase.getResults();
    bool? isStop;

    for (var i = _rawResults.length - 1; i >= 0; i--) {
      if (isStop == null && _rawResults[i].isClassifiedStop == null) continue;
      if (_rawResults[i].isClassifiedStop != null) {
        isStop = _rawResults[i].isClassifiedStop!;
      } else {
        _rawResults[i].isClassifiedStop = isStop;
      }
    }

    bool trackedStop = _rawResults.first.isClassifiedStop!;
    var counter = 0;

    for (var i = 0; i < _rawResults.length; i++) {
      if (_rawResults[i].isClassifiedStop == null) continue;

      if (_rawResults[i].isClassifiedStop! != trackedStop) {
        if (_rawResults[i - 1].isClassifiedStop!) {
          //Location
          var list = _rawResults.sublist(counter, i);
          var median = list.length == 1 ? 0 : (list.length / 2).round();
          var dto = TrackedLocationDTO(
              id: null,
              movements: [],
              startTime: list.first.datetime.millisecondsSinceEpoch,
              endTime: list.last.datetime.millisecondsSinceEpoch,
              lat: list[median].location.latitude,
              lon: list[median].location.longitude);

          generatedLocations.add(dto);

          trackedStop = !trackedStop;
          counter = i;
        } else {
          //Movement
          var list = _rawResults.sublist(counter, i);

          if (generatedLocations.isEmpty) {
            var dto = TrackedLocationDTO(
                id: null,
                movements: [],
                startTime: list.first.datetime.millisecondsSinceEpoch,
                endTime: list.first.datetime.millisecondsSinceEpoch,
                lat: list.first.location.latitude,
                lon: list.first.location.longitude);

            generatedLocations.add(dto);
          }

          var movement = TrackedMovementDTO(
              id: 0,
              trackedLocationId: 0,
              startTime: list.first.datetime.millisecondsSinceEpoch,
              endTime: list.last.datetime.millisecondsSinceEpoch,
              confirmed: false,
              latlngs: []);

          for (var i = 0; i < list.length; i++) {
            var latlng = TrackedMovementLatlngDTO(lat: list[i].location.latitude, lon: list[i].location.longitude);
            movement.latlngs!.add(latlng);
          }

          generatedLocations[generatedLocations.length - 1].movements!.add(movement);

          trackedStop = !trackedStop;
          counter = i;
        }
      }
    }

    var locationMapDTO = LocationMapDTO(_getMarkers(generatedLocations), _getPolylines(generatedLocations));

    state = Loaded<LocationMapDTO>(locationMapDTO);
  }

  List<Polyline> _getPolylines(List<TrackedLocationDTO> locations) {
    var latlngs = <Polyline>[];

    for (var location in locations) {
      for (var movement in location.movements!) {
        var polyline = Polyline(strokeWidth: 4.0, color: Colors.blue, points: []);
        for (var latlon in movement.latlngs!) {
          polyline.points.add(LatLng(latlon.lat!, latlon.lon!));
        }
        latlngs.add(polyline);
      }
    }

    return latlngs;
  }

  List<Marker> _getMarkers(List<TrackedLocationDTO> locations) {
    var markers = <Marker>[];

    for (var dto in locations) {
      var marker = Marker(
          width: 40.0,
          height: 40.0,
          point: LatLng(dto.lat!, dto.lon!),
          builder: (ctx) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: const Color(0xFFE9EAEE),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.location_pin,
                color: Colors.blue,
                size: 24.0,
              )));

      markers.add(marker);

      // for (var movement in dto.movements!) {
      //   for (var latlon in movement.latlngs!) {
      //     var marker = Marker(
      //         width: 5.0,
      //         height: 5.0,
      //         point: LatLng(latlon.lat!, latlon.lon!),
      //         builder: (ctx) => Container(
      //               decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(40),
      //                 color: Colors.red,
      //               ),
      //               alignment: Alignment.center,
      //             ));
      //     markers.add(marker);
      //   }
      // }
    }

    return markers;
  }
}
