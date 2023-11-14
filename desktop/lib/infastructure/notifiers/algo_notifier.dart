// import 'dart:math';

// import 'package:desktop/infastructure/classifier/is_moving_classifier.dart';
// import 'package:desktop/infastructure/repositories/database/database.dart';
// import 'package:desktop/infastructure/repositories/dtos/location_dto.dart';
// import 'package:desktop/infastructure/repositories/dtos/test_case_results_dto.dart';
// import 'package:desktop/infastructure/repositories/dtos/testcase_dto.dart';
// import 'package:desktop/infastructure/repositories/dtos/tracked_location_dto.dart';
// import 'package:desktop/infastructure/repositories/dtos/tracked_movement_dto.dart';
// import 'package:desktop/infastructure/repositories/dtos/tracked_movement_latlon_dto.dart';
// import 'package:desktop/infastructure/repositories/network/testcase_api.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:uuid/uuid.dart';

// import 'generic_notifier.dart';

// class AlgoNotifier extends StateNotifier<NotifierState> {
//   final Database _database = Database();
//   final IsMovingClassifier _isMovingClassifier;
//   final TestCaseDTO _testCaseDTO;

//   AlgoNotifier(this._isMovingClassifier, this._testCaseDTO)
//       : super(const Initial()) {
//     initAlgo(_testCaseDTO);
//   }

//   initAlgo(TestCaseDTO testCaseDTO) async {
//     state = const Loading();
//     await compute(calculateLocationsAsync, testCaseDTO);

//     var generatedLocations = await _database.trackedLocationsDao.getAsync();

//     var generatedMovements = await _database.trackedMovementsDao.get();
//     var validatedMovements = <TrackedMovementDTO>[];

//     for (var i = 0; i < generatedMovements.length; i++) {
//       var dto = TrackedMovementDTO.fromTrackedMovement(generatedMovements[i]);
//       var latlngs =
//           await _database.trackedMovementLatLngsDao.getByMovementId(dto.id!);

//       // dto.latlngs = TrackedMovementLatlngDTO.fromLatLon(tm)
//     }

//     for (var i = 0; i < testCaseDTO.trackedDay.locations!.length; i++) {
//       validatedMovements
//           .addAll(testCaseDTO.trackedDay.locations![i].movements!);
//     }

//     state = Loaded<TestCaseResultsDTO>(TestCaseResultsDTO(
//         validatedTrackedLocations: testCaseDTO.trackedDay.locations != null
//             ? testCaseDTO.trackedDay.locations!
//             : [],
//         generatedTrackedLocations: [],
//         mappedTrackedLocations: [],
//         generatedTrackedMovement: [],
//         mappedTrackedMovement: [],
//         validatedTrackedMovement: validatedMovements));
//   }

//   List<Map<int, int>> mapLocations(List<TrackedLocationDTO> generatedLocations,
//       List<TrackedLocationDTO> validatedLocations) {
//     var mappedLocations = <Map<int, int>>[];
//     var distanceMargin = 1000;
//     var timeMargin = 30 * 60 * 1000;

//     for (var i = 0; i < validatedLocations.length; i++) {
//       for (var j = 0; j < generatedLocations.length; j++) {
//         var distance = _calculateDistance(
//             validatedLocations[i].lat,
//             validatedLocations[i].lon,
//             generatedLocations[j].lat,
//             generatedLocations[j].lon);

//         if (validatedLocations[i].startTime! - timeMargin <=
//                 generatedLocations[j].startTime! &&
//             validatedLocations[i].startTime! + timeMargin >=
//                 generatedLocations[j].endTime!) {
//           if (distance <= distanceMargin) {
//             mappedLocations.add(<int, int>{
//               validatedLocations[i].id!: generatedLocations[j].id!
//             });
//           }
//         }
//       }
//     }

//     return mappedLocations;
//   }

//   List<Map<int, int>> mapMovements(List<TrackedMovementDTO> generatedMovements,
//       List<TrackedMovementDTO> validatedMovements) {
//     var mappedMovements = <Map<int, int>>[];
//     var distanceMargin = 1000;
//     var timeMargin = 30 * 60 * 1000;

//     for (var i = 0; i < validatedMovements.length; i++) {
//       for (var j = 0; j < generatedMovements.length; j++) {
//         if (validatedMovements[i].latlngs!.isEmpty ||
//             generatedMovements[j].latlngs!.isEmpty) {
//           continue;
//         }

//         if (validatedMovements[i].startTime! - timeMargin <=
//                 generatedMovements[j].startTime! &&
//             validatedMovements[i].startTime! + timeMargin >=
//                 generatedMovements[j].endTime!) {
//           var startDistance = _calculateDistance(
//               validatedMovements[i].latlngs!.first.lat,
//               validatedMovements[i].latlngs!.first.lon,
//               generatedMovements[j].latlngs!.first.lat,
//               generatedMovements[j].latlngs!.first.lon);

//           var endDistance = _calculateDistance(
//               validatedMovements[i].latlngs!.last.lat,
//               validatedMovements[i].latlngs!.last.lon,
//               generatedMovements[j].latlngs!.last.lat,
//               generatedMovements[j].latlngs!.last.lon);

//           if (startDistance <= distanceMargin &&
//               endDistance <= distanceMargin) {
//             mappedMovements.add(<int, int>{
//               validatedMovements[i].id!: generatedMovements[j].id!
//             });
//           }
//         }
//       }
//     }

//     return mappedMovements;
//   }

//   calculateLocationsAsync(TestCaseDTO testCaseDTO) async {
//     for (var i = 0; i < testCaseDTO.rawdata.length; i++) {
//       await calculateLocationAsync(testCaseDTO.rawdata[i], testCaseDTO.uuid!);
//     }
//   }

//   calculateLocationAsync(LocationDTO locationDTO, String uuid) async {
//     var locations =
//         await _database.locationsDao.getLastMeaningFullLocationsAsync(uuid);
//     var classifiedLocation =
//         _isMovingClassifier.classifyIfLocationIsMoving(locations, locationDTO);

//     classifiedLocation.uuid = uuid;

//     await _database.locationsDao.insertLocationDTOAsync(classifiedLocation);
//     checkIfNewLocationOrMovement(classifiedLocation, locations, uuid);
//   }

//   Future checkIfNewLocationOrMovement(
//       LocationDTO locationDTO, List<Location> locations, String uuid) async {
//     if (locations.isEmpty) {
//       return;
//     }

//     if (locationDTO.isMoving != locations.last.isMoving!) {
//       if (locations.last.isMoving!) {
//         var trackedLocationId = await _findTrackedLocationIdAsync(
//             DateTime.fromMillisecondsSinceEpoch(locations.first.date),
//             locations.first.lat,
//             locations.first.lon,
//             uuid);

//         var trackedMovement = TrackedMovement(
//             id: 0,
//             trackedLocationId: trackedLocationId,
//             startTime:
//                 DateTime.fromMillisecondsSinceEpoch(locations.first.date),
//             endTime: DateTime.fromMillisecondsSinceEpoch(locations.last.date),
//             confirmed: false,
//             uuid: uuid);

//         var trackedMovementId =
//             await _database.trackedMovementsDao.insertAsync(trackedMovement);

//         var timeDifference = 0;
//         var averagePoints = 0;
//         var totalLat = 0.0;
//         var totalLon = 0.0;

//         for (var m = 1; m < locations.length; m++) {
//           if ((locations.length - 2) == m) {
//             await _database.trackedMovementLatLngsDao.insertAsync(
//                 uuid,
//                 locations[m].lat,
//                 locations[m].lon,
//                 locations[m].altitude,
//                 DateTime.fromMillisecondsSinceEpoch(locations[m].date),
//                 trackedMovementId);

//             return;
//           }

//           var startBearing = _getBearing(locations[m - 1].lat,
//               locations[m - 1].lon, locations[m].lat, locations[m].lon);
//           var endBearing = _getBearing(locations[m + 1].lat,
//               locations[m + 1].lon, locations[m].lat, locations[m].lon);
//           var bearing = startBearing - endBearing;

//           timeDifference += locations[m].date - locations[m - 1].date;

//           if (bearing < 50 && bearing > -50) {
//             averagePoints++;
//             totalLat += locations[m].lat;
//             totalLon += locations[m].lon;

//             if (timeDifference > 30 * 1000) {
//               await _database.trackedMovementLatLngsDao.insertAsync(
//                   uuid,
//                   locations[m].lat,
//                   locations[m].lon,
//                   locations[m].altitude,
//                   DateTime.fromMillisecondsSinceEpoch(locations[m].date),
//                   trackedMovementId);

//               timeDifference = 0;
//               totalLat = 0;
//               totalLon = 0;
//               averagePoints = 0;
//             }
//           }
//         }
//       } else {
//         locations.sort((a, b) => a.lat.compareTo(b.lat));

//         var id = await _database.trackedLocationsDao.insertTrackedLocationAsync(
//             locations[locations.length ~/ 2].lat,
//             locations[locations.length ~/ 2].lon,
//             DateTime.fromMillisecondsSinceEpoch(locations.first.date),
//             DateTime.fromMillisecondsSinceEpoch(locations.last.date),
//             await _getTrackedDayIdAsync(uuid),
//             uuid);
//       }
//     }
//   }

//   Future<int> _getTrackedDayIdAsync(String uuid) async {
//     var trackedDay =
//         await _database.trackedDaysDao.findByDayAsync(DateTime.now().day, uuid);

//     if (trackedDay != null) {
//       return trackedDay.id;
//     }

//     var trackedDayId = await _database.trackedDaysDao
//         .insertTrackedDayAsync(false, 0, "", DateTime.now(), 0, 0, 0, uuid);

//     return trackedDayId;
//   }

//   double _calculateDistance(lat1, lon1, lat2, lon2) {
//     var p = 0.017453292519943295;
//     var c = cos;
//     var a = 0.5 -
//         c((lat2 - lat1) * p) / 2 +
//         c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;

//     return 12742 * asin(sqrt(a));
//   }

//   double _getBearing(startLat, startLng, destLat, destLng) {
//     startLat = _toRadians(startLat);
//     startLng = _toRadians(startLng);
//     destLat = _toRadians(destLat);
//     destLng = _toRadians(destLng);

//     var y = sin(destLng - startLng) * cos(destLat);
//     var x = cos(startLat) * sin(destLat) -
//         sin(startLat) * cos(destLat) * cos(destLng - startLng);
//     var brng = atan2(y, x);
//     brng = _toDegrees(brng);
//     return (brng + 360) % 360;
//   }

//   double _toRadians(double degrees) {
//     return degrees * pi / 180;
//   }

//   double _toDegrees(double radians) {
//     return radians * 180 / pi;
//   }

//   Future<int> _findTrackedLocationIdAsync(
//       DateTime date, double lon, double lat, String uuid) async {
//     var trackedLocation =
//         await _database.trackedLocationsDao.getByStarttimeAsync(date);

//     if (trackedLocation != null) {
//       return trackedLocation.id;
//     }

//     var trackedLocationId = await _database.trackedLocationsDao
//         .insertTrackedLocationAsync(
//             lat, lon, date, date, await _getTrackedDayIdAsync(uuid), uuid);

//     return trackedLocationId;
//   }
// }
