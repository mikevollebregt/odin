import 'package:desktop/infastructure/repositories/dtos/location_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/location_map_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../repositories/dtos/user_test_day_data_dto.dart';
import 'generic_notifier.dart';

class TestCaseRawDetailNotifier extends StateNotifier<NotifierState> {
  TestCaseRawDetailNotifier() : super(const Initial());

  Future showOnMapAsync(UserTestDayDataDTO testCaseDTO) async {
    state = const Loading();

    var locationMapDTO = LocationMapDTO(_getMarkers(testCaseDTO.rawdata), []);

    state = Loaded<LocationMapDTO>(locationMapDTO);
  }

  LocationMapDTO getLocationMapDTO(UserTestDayDataDTO testCaseDTO) {
    var locationMapDTO = LocationMapDTO(_getMarkers(testCaseDTO.rawdata), []);

    return locationMapDTO;
  }

  List<Polyline> _getPolylines(List<LocationDTO> locations) {
    var latlngs = <Polyline>[];
    var polyline = Polyline(strokeWidth: 4.0, color: Colors.blue, points: []);
    for (var location in locations) {
      polyline.points.add(LatLng(location.lat, location.lon));
    }

    latlngs.add(polyline);

    return latlngs;
  }

  List<Marker> _getMarkers(List<LocationDTO> locations) {
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
}
