import 'package:desktop/infastructure/repositories/dtos/sensor_geolocation_dto.dart';
import 'package:desktop/infastructure/repositories/network/google_api.dart';
import 'package:desktop/infastructure/repositories/network/pdok_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'generic_notifier.dart';

class GoogleDetailNotifier extends StateNotifier<NotifierState> {
  final GoogleApi _googleApi;
  final PDOKApi _pdokApi;

  GoogleDetailNotifier(this._googleApi, this._pdokApi) : super(const Initial());

  getDetails(SensorGeolocationDTO dto) async {
    state = const Loading();

    final response = await _pdokApi.getPointsOfInterest(dto.lat, dto.lon, 5);

    state = Loaded(response.payload!);
  }
}
