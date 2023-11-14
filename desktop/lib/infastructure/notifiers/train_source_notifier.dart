import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../repositories/dtos/location_map_dto.dart';
import '../repositories/dtos/train_properties_dto.dart';
import '../repositories/network/train_source_api.dart';
import 'generic_notifier.dart';

class TrainSourceNotifier extends StateNotifier<NotifierState> {
  final TrainSourceApi _trainSourceApi;

  TrainSourceNotifier(this._trainSourceApi) : super(const Initial()) {
    loadTrainSource();
  }

  loadTrainSource() async {
    state = const Loading();

    final response = await _trainSourceApi.getPolylineTrainInfrastructureAsync();

    state = Loaded(response.payload!);
  }

  LocationMapDTO getRawLocationMapDTO(List<TrainPropertyDTO> data) {
    var locationMapDTO = LocationMapDTO(_getRawMarkers(data), []);

    return locationMapDTO;
  }

  List<Marker> _getRawMarkers(List<TrainPropertyDTO> locations) {
    var markers = <Marker>[];

    for (var i = 0; i < locations.length; i++) {
      var dto = locations[i];

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
