import 'dart:math';

import 'package:desktop/infastructure/notifiers/sensor_data.dart';
import 'package:desktop/infastructure/notifiers/sensor_data_repository.dart';
import 'package:desktop/infastructure/notifiers/tom_classification_notifier.dart';
import 'package:desktop/infastructure/repositories/dtos/tracked_movement_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/dtos/test_case_results_dto.dart';
import '../repositories/dtos/tracked_location_dto.dart';
import '../repositories/dtos/tracked_movement_latlon_dto.dart';
import '../repositories/dtos/user_test_day_data_dto.dart';
import 'generic_notifier.dart';
import 'mock_database.dart';

class TomCompareNotifier extends StateNotifier<NotifierState> {
  late MockDatabase mockDatabase;
  late SensorDataRepository sensorDataRepository;
  late ClassificationNotifier classificationNotifier;

  List<TrackedLocationDTO> results = [];

  TomCompareNotifier() : super(const Initial()) {
    mockDatabase = MockDatabase();
    sensorDataRepository = SensorDataRepository(mockDatabase);
    classificationNotifier = ClassificationNotifier(sensorDataRepository);
  }

  calculateLocationsAsync(UserTestDayDataDTO testCaseDTO) async {
    state = const Loading();

    var generatedLocations = <TrackedLocationDTO>[];

    for (final locationDTO in testCaseDTO.rawdata) {
      final _sensorData = SensorData.fromLocationDTO(locationDTO);
      await classificationNotifier.classify(_sensorData);
    }

    final _rawResults = mockDatabase.getResults();
    bool? isStop;

    for (var i = _rawResults.length - 1; i >= 0; i--) {
      if (isStop == null && _rawResults[i].isClassifiedStop == null) continue;
      if (_rawResults[i].isClassifiedStop != null) {
        isStop = _rawResults[i].isClassifiedStop!;
      } else {
        _rawResults[i].isClassifiedStop = isStop;
      }
    }

    if (_rawResults.isEmpty || _rawResults.first.isClassifiedStop == null) {
      state = Loaded<TestCaseResultsDTO>(TestCaseResultsDTO(
          validatedTrackedLocations: [],
          generatedTrackedLocations: generatedLocations,
          mappedTrackedLocations: mapLocations(generatedLocations, []),
          validatedTrackedMovement: [],
          generatedTrackedMovement: [],
          mappedTrackedMovement: mapMovements([], [])));
      return;
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

    var validatedLocations = testCaseDTO.trackedDay.locations != null ? testCaseDTO.trackedDay.locations! : <TrackedLocationDTO>[];

    var generatedMovements = <TrackedMovementDTO>[];
    var validatedMovements = <TrackedMovementDTO>[];

    for (var i = 0; i < generatedLocations.length; i++) {
      generatedMovements.addAll(generatedLocations[i].movements!);
    }

    for (var i = 0; i < testCaseDTO.trackedDay.locations!.length; i++) {
      validatedMovements.addAll(testCaseDTO.trackedDay.locations![i].movements!);
    }

    state = Loaded<TestCaseResultsDTO>(TestCaseResultsDTO(
        validatedTrackedLocations: validatedLocations,
        generatedTrackedLocations: generatedLocations,
        mappedTrackedLocations: mapLocations(generatedLocations, validatedLocations),
        validatedTrackedMovement: validatedMovements,
        generatedTrackedMovement: generatedMovements,
        mappedTrackedMovement: mapMovements(generatedMovements, validatedMovements)));
  }

  List<Map<TrackedLocationDTO, TrackedLocationDTO>> mapLocations(List<TrackedLocationDTO> generatedLocations, List<TrackedLocationDTO> validatedLocations) {
    var mappedLocations = <Map<TrackedLocationDTO, TrackedLocationDTO>>[];
    var distanceMargin = 1000;
    var timeMargin = 30 * 60 * 1000;

    for (var i = 0; i < validatedLocations.length; i++) {
      for (var j = 0; j < generatedLocations.length; j++) {
        var distance = _calculateDistance(validatedLocations[i].lat, validatedLocations[i].lon, generatedLocations[j].lat, generatedLocations[j].lon);

        if (validatedLocations[i].startTime! - timeMargin <= generatedLocations[j].startTime! &&
            validatedLocations[i].startTime! + timeMargin >= generatedLocations[j].endTime!) {
          if (distance <= distanceMargin) {
            mappedLocations.add(<TrackedLocationDTO, TrackedLocationDTO>{validatedLocations[i]: generatedLocations[j]});
          }
        }
      }
    }

    return mappedLocations;
  }

  List<Map<TrackedMovementDTO, TrackedMovementDTO>> mapMovements(List<TrackedMovementDTO> generatedMovements, List<TrackedMovementDTO> validatedMovements) {
    var mappedMovements = <Map<TrackedMovementDTO, TrackedMovementDTO>>[];
    var distanceMargin = 1000;
    var timeMargin = 30 * 60 * 1000;

    for (var i = 0; i < validatedMovements.length; i++) {
      for (var j = 0; j < generatedMovements.length; j++) {
        if (validatedMovements[i].latlngs!.isEmpty || generatedMovements[j].latlngs!.isEmpty) {
          continue;
        }

        if (validatedMovements[i].startTime! - timeMargin <= generatedMovements[j].startTime! &&
            validatedMovements[i].startTime! + timeMargin >= generatedMovements[j].endTime!) {
          var startDistance = _calculateDistance(validatedMovements[i].latlngs!.first.lat, validatedMovements[i].latlngs!.first.lon,
              generatedMovements[j].latlngs!.first.lat, generatedMovements[j].latlngs!.first.lon);

          var endDistance = _calculateDistance(validatedMovements[i].latlngs!.last.lat, validatedMovements[i].latlngs!.last.lon,
              generatedMovements[j].latlngs!.last.lat, generatedMovements[j].latlngs!.last.lon);

          if (startDistance <= distanceMargin && endDistance <= distanceMargin) {
            mappedMovements.add(<TrackedMovementDTO, TrackedMovementDTO>{validatedMovements[i]: generatedMovements[j]});
          }
        }
      }
    }

    return mappedMovements;
  }

  double _calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;

    return 12742 * asin(sqrt(a));
  }
}
