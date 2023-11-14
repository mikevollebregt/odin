// import 'package:desktop/infastructure/repositories/dtos/location_map_dto.dart';
// import 'package:desktop/infastructure/repositories/dtos/testcase_dto.dart';
// import 'package:desktop/infastructure/repositories/dtos/tracked_location_dto.dart';
// import 'package:desktop/infastructure/services/algo_service.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:uuid/uuid.dart';

// import 'generic_notifier.dart';

// class TestCaseAlgoDetailNotifier extends StateNotifier<NotifierState> {
//   final AlgoService _algoService;

//   TestCaseAlgoDetailNotifier(this._algoService) : super(const Initial());

//   Future showOnMapAsync(TestCaseDTO testCaseDTO) async {
//     state = const Loading();
//     testCaseDTO.uuid = const Uuid().v1();
//     var locations =
//         await compute(_algoService.calculateLocationAsync, testCaseDTO);
//     var locationMapDTO =
//         LocationMapDTO(_getMarkers(locations), _getPolylines(locations));

//     state = Loaded<LocationMapDTO>(locationMapDTO);
//   }

//   List<Polyline> _getPolylines(List<TrackedLocationDTO> locations) {
//     var latlngs = <Polyline>[];

//     for (var location in locations) {
//       for (var movement in location.movements!) {
//         var polyline =
//             Polyline(strokeWidth: 4.0, color: Colors.blue, points: []);
//         for (var latlon in movement.latlngs!) {
//           polyline.points.add(LatLng(latlon.lat!, latlon.lon!));
//         }
//         latlngs.add(polyline);
//       }
//     }

//     return latlngs;
//   }

//   List<Marker> _getMarkers(List<TrackedLocationDTO> locations) {
//     var markers = <Marker>[];

//     for (var dto in locations) {
//       var marker = Marker(
//           width: 40.0,
//           height: 40.0,
//           point: LatLng(dto.lat!, dto.lon!),
//           builder: (ctx) => Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(40),
//                 color: const Color(0xFFE9EAEE),
//               ),
//               alignment: Alignment.center,
//               child: const Icon(
//                 Icons.location_pin,
//                 color: Colors.blue,
//                 size: 24.0,
//               )));

//       markers.add(marker);
//     }

//     return markers;
//   }
// }
