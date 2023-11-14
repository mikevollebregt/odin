// import 'dart:math';

// import 'package:desktop/infastructure/repositories/database/database.dart';
// import 'package:desktop/infastructure/repositories/dtos/testcase_dto.dart';
// import 'package:desktop/infastructure/repositories/dtos/tracked_location_dto.dart';
// import 'package:desktop/infastructure/repositories/dtos/tracked_movement_dto.dart';
// import 'package:desktop/infastructure/repositories/dtos/tracked_movement_latlon_dto.dart';

// class AlgoService {
//   final Database _database = Database();

//   Future<List<TrackedLocationDTO>> calculateLocationAsync(
//       TestCaseDTO testCaseDTO) async {
//     var state = await _getCurrentStateAsync();

//     var lastLocationIndex = state!.lastLocationIndex;
//     var lastMovingIndex = state.lastMovingIndex;
//     var minDistance = 0.2;
//     var minTime = 5 * 60 * 1000;
//     var timeNotMoving = state.timeNotMoving;
//     var isMoving = state.isMoving;
//     var medianList = <double>[];

//     var unknownLocations = testCaseDTO.rawdata;
//     var uuid = testCaseDTO.uuid!;

//     for (var i = 1; i < unknownLocations.length; i++) {
//       if (isMoving) {
//         //stop detectie

//         if (lastMovingIndex + 10 < i) {
//           medianList = [];

//           for (var j = lastMovingIndex; j < unknownLocations.length; j++) {
//             var distance = _calculateDistance(
//                 unknownLocations[j].lat,
//                 unknownLocations[j].lon,
//                 unknownLocations[i - 1].lat,
//                 unknownLocations[i - 1].lon);
//             medianList.add(distance);
//           }

//           getMedian(medianList);
//           var mediumDistance = _getMedian(medianList);

//           if (mediumDistance < 0.05) {
//             var timeDifference =
//                 unknownLocations[i].date - unknownLocations[i - 1].date;
//             timeNotMoving += timeDifference;
//           } else {
//             timeNotMoving = 0;
//           }

//           if (timeNotMoving > minTime) {
//             //phone stopped moving

//             //Check if tracked day and location exist, then make a tracked movement and convert the locations to movementlatlng
//             var trackedLocationId = await _findTrackedLocationIdAsync(
//                 DateTime.fromMillisecondsSinceEpoch(
//                     unknownLocations.first.date),
//                 unknownLocations.first.lat,
//                 unknownLocations.first.lon,
//                 uuid);

//             var trackedMovement = TrackedMovement(
//                 id: 0,
//                 uuid: uuid,
//                 trackedLocationId: trackedLocationId,
//                 startTime: DateTime.fromMillisecondsSinceEpoch(
//                     unknownLocations.first.date),
//                 endTime: DateTime.fromMillisecondsSinceEpoch(
//                     unknownLocations.last.date),
//                 confirmed: false);

//             var trackedMovementId = await _database.trackedMovementsDao
//                 .insertAsync(trackedMovement);

//             var timeDifference = 0;
//             var averagePoints = 0;
//             var totalLat = 0.0;
//             var totalLon = 0.0;

//             for (var m = lastLocationIndex; m < i; m++) {
//               if (lastLocationIndex == 0) {
//                 continue;
//               }

//               if ((i - 2) == m) {
//                 await _database.trackedMovementLatLngsDao.insertAsync(
//                     uuid,
//                     unknownLocations[m].lat,
//                     unknownLocations[m].lon,
//                     unknownLocations[m].altitude,
//                     DateTime.fromMillisecondsSinceEpoch(
//                         unknownLocations[m].date),
//                     trackedMovementId);
//               }

//               var startBearing = _getBearing(
//                   unknownLocations[m - 1].lat,
//                   unknownLocations[m - 1].lon,
//                   unknownLocations[m].lat,
//                   unknownLocations[m].lon);
//               var endBearing = _getBearing(
//                   unknownLocations[m + 1].lat,
//                   unknownLocations[m + 1].lon,
//                   unknownLocations[m].lat,
//                   unknownLocations[m].lon);
//               var bearing = startBearing - endBearing;

//               timeDifference +=
//                   unknownLocations[m].date - unknownLocations[m - 1].date;

//               if (bearing < 50 && bearing > -50) {
//                 averagePoints++;
//                 totalLat += unknownLocations[m].lat;
//                 totalLon += unknownLocations[m].lon;

//                 if (timeDifference > 30 * 1000) {
//                   var latlong = TrackedMovementLatLng(
//                     id: 0,
//                     uuid: uuid,
//                     lat: unknownLocations[m].lat,
//                     lon: unknownLocations[m].lon,
//                     altitude: unknownLocations[m].altitude,
//                     mappedDate: DateTime.fromMillisecondsSinceEpoch(
//                         unknownLocations[m].date),
//                     movementId: trackedMovementId,
//                   );

//                   await _database.trackedMovementLatLngsDao.insertAsync(
//                       uuid,
//                       unknownLocations[m].lat,
//                       unknownLocations[m].lon,
//                       unknownLocations[m].altitude,
//                       DateTime.fromMillisecondsSinceEpoch(
//                           unknownLocations[m].date),
//                       trackedMovementId);

//                   timeDifference = 0;
//                   totalLat = 0;
//                   totalLon = 0;
//                   averagePoints = 0;
//                 }
//               }
//             }

//             isMoving = false;
//             lastLocationIndex = i;

//             state = state!.copyWith(
//                 isMoving: isMoving, lastLocationIndex: lastLocationIndex);
//           }

//           lastMovingIndex = i;
//           state = state!.copyWith(lastMovingIndex: lastMovingIndex);
//         }
//       } else {
//         var distance = _calculateDistance(
//             unknownLocations[lastLocationIndex].lat,
//             unknownLocations[lastLocationIndex].lon,
//             unknownLocations[i].lat,
//             unknownLocations[i].lon);

//         //verplaatsing detectie
//         if (distance > minDistance) {
//           //phone started moving
//           isMoving = true;
//           timeNotMoving = 0;
//           lastMovingIndex = i;
//           await _database.algoStatesDao.updatePotentialStateAsync(state!
//               .copyWith(
//                   timeNotMoving: timeNotMoving,
//                   isMoving: isMoving,
//                   lastLocationIndex: lastLocationIndex));

//           //current index is a new location
//           var id = await _database.trackedLocationsDao
//               .insertTrackedLocationAsync(
//                   unknownLocations[lastLocationIndex].lat,
//                   unknownLocations[lastLocationIndex].lon,
//                   DateTime.fromMillisecondsSinceEpoch(
//                       unknownLocations.first.date),
//                   DateTime.fromMillisecondsSinceEpoch(
//                       unknownLocations.last.date),
//                   await _getTrackedDayIdAsync(uuid),
//                   uuid);
//         }
//       }
//     }

//     var trackedLocations = await _database.trackedLocationsDao.getAsync();
//     var trackedLocationsDTO = <TrackedLocationDTO>[];

//     for (var i = 0; i < trackedLocations.length; i++) {
//       var locationDTO =
//           TrackedLocationDTO.fromTrackedLocation(trackedLocations[i]);
//       locationDTO.movements = <TrackedMovementDTO>[];

//       var trackedMovements = await _database.trackedMovementsDao
//           .getByLocationId(trackedLocations[i].id);

//       for (var j = 0; j < trackedMovements.length; j++) {
//         var movementDTO =
//             TrackedMovementDTO.fromTrackedMovement(trackedMovements[j]);

//         var trackedLatlngs = await _database.trackedMovementLatLngsDao
//             .getByMovementId(trackedMovements[j].id);

//         movementDTO.latlngs =
//             TrackedMovementLatlngDTO.fromTableList(trackedLatlngs);
//         locationDTO.movements!.add(movementDTO);
//       }

//       trackedLocationsDTO.add(locationDTO);
//     }

//     return trackedLocationsDTO;
//   }

//   Future<AlgoState?> _getCurrentStateAsync() async {
//     try {
//       var currentState = await _database.algoStatesDao.getAsync();

//       if (currentState == null) {
//         currentState = AlgoState(
//             id: 0,
//             isMoving: false,
//             lastLocationIndex: 0,
//             lastMovingIndex: 0,
//             timeNotMoving: 0);

//         var id = await _database.algoStatesDao
//             .insertPotentialStateAsync(currentState);
//         currentState = currentState.copyWith(id: id);
//       }

//       return currentState;
//     } catch (error) {
//       print(error);
//     }
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

//   double _getMedian(List<double> list) {
//     list.sort((a, b) => a.compareTo(b));

//     double median;

//     int middle = list.length ~/ 2;
//     if (list.length % 2 == 1) {
//       median = list[middle];
//     } else {
//       median = ((list[middle - 1] + list[middle]) / 2.0);
//     }

//     return median;
//   }

//   double _toRadians(double degrees) {
//     return degrees * pi / 180;
//   }

//   double _toDegrees(double radians) {
//     return radians * 180 / pi;
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

//   double getMedian(List<double> list) {
//     list.sort((a, b) => a.compareTo(b));

//     double median;

//     int middle = list.length ~/ 2;
//     if (list.length % 2 == 1) {
//       median = list[middle];
//     } else {
//       median = ((list[middle - 1]) + (list[middle]) / 2);
//     }

//     return median;
//   }
// }
