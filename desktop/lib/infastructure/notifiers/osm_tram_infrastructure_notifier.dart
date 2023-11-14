import 'package:desktop/infastructure/repositories/network/osm_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../repositories/dtos/location_map_dto.dart';
import '../repositories/dtos/osm_coordinates_dto.dart';
import 'generic_notifier.dart';

class OSMTramInfrastructureNotifier extends StateNotifier<NotifierState> {
  final OSMApi _osmApi;

  OSMTramInfrastructureNotifier(this._osmApi) : super(const Initial()) {
    getDetails();
  }

  getDetails() async {
    state = const Loading();

    final response = await _osmApi.getTramInfastructure();
    var markers = getRawLocationMapDTO(response.payload!);

    state = Loaded(markers);
  }

  LocationMapDTO getRawLocationMapDTO(OSMCoordinatesDTO data) {
    var locationMapDTO = LocationMapDTO(_getRawMarkers(data), []);

    return locationMapDTO;
  }

  List<Marker> _getRawMarkers(OSMCoordinatesDTO data) {
    var markers = <Marker>[];

    for (var i = 0; i < data.coordinates.length; i += 10) {
      var dto = data.coordinates[i];

      var marker = Marker(
          width: 5.0,
          height: 5.0,
          point: LatLng(dto.latitude, dto.longitude),
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
