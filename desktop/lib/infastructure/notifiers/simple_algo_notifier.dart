// import 'dart:math';

// import 'package:desktop/infastructure/repositories/database/database.dart';
// import 'package:desktop/infastructure/repositories/dtos/test_case_results_dto.dart';
// import 'package:desktop/infastructure/repositories/dtos/testcase_dto.dart';
// import 'package:desktop/infastructure/repositories/dtos/tracked_location_dto.dart';
// import 'package:desktop/infastructure/repositories/dtos/tracked_movement_dto.dart';
// import 'package:desktop/infastructure/services/algo_service.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:uuid/uuid.dart';

// import 'generic_notifier.dart';

// class SimpleAlgoNotifier extends StateNotifier<NotifierState> {
//   final AlgoService _algoService = AlgoService();
//   final TestCaseDTO _testCaseDTO;

//   SimpleAlgoNotifier(this._testCaseDTO) : super(const Initial()) {
//     calculateLocationsAsync(_testCaseDTO);
//   }

//   calculateLocationsAsync(TestCaseDTO testCaseDTO) async {
//     state = const Loading();
//     testCaseDTO.uuid = const Uuid().v1();

//     testCaseDTO.trackedDay.locations = testCaseDTO.trackedDay.locations != null
//         ? testCaseDTO.trackedDay.locations!
//         : [];

//     var generatedLocations =
//         await compute(_algoService.calculateLocationAsync, testCaseDTO);

//     var generatedMovements = <TrackedMovementDTO>[];
//     var validatedMovements = <TrackedMovementDTO>[];

//     for (var i = 0; i < generatedLocations.length; i++) {
//       generatedMovements.addAll(generatedLocations[i].movements!);
//     }

//     for (var i = 0; i < testCaseDTO.trackedDay.locations!.length; i++) {
//       validatedMovements
//           .addAll(testCaseDTO.trackedDay.locations![i].movements!);
//     }

//     state = Loaded<TestCaseResultsDTO>(TestCaseResultsDTO(
//         validatedTrackedLocations: testCaseDTO.trackedDay.locations!,
//         generatedTrackedLocations: generatedLocations,
//         mappedTrackedLocations: [],
//         validatedTrackedMovement: validatedMovements,
//         generatedTrackedMovement: generatedMovements,
//         mappedTrackedMovement: []));
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

//   double _calculateDistance(lat1, lon1, lat2, lon2) {
//     var p = 0.017453292519943295;
//     var c = cos;
//     var a = 0.5 -
//         c((lat2 - lat1) * p) / 2 +
//         c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;

//     return 12742 * asin(sqrt(a));
//   }
// }
