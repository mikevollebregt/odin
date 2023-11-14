// ignore_for_file: use_setters_to_change_properties
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

import '../repositories/dtos/enums/log_type.dart';
import '../repositories/dtos/googlemaps_dto.dart';
import '../repositories/dtos/parsed_response.dart';
import '../repositories/google_maps_repository.dart';
import '../repositories/log_repository.dart';
import '../services/device_service.dart';
import 'generic_notifier.dart';

class LocationSearchPageNotifier extends StateNotifier<NotifierState> {
  final GoogleMapsRepository _googleMapsRepository;
  final DeviceService _deviceService;
  final SimpleAnimation _animationController = SimpleAnimation('Animation 1', autoplay: false);
  String _query = '';

  LocationSearchPageNotifier(this._googleMapsRepository, this._deviceService) : super(const Initial());

  RiveAnimationController getController() {
    return _animationController;
  }

  void setPlaying(bool playing) {
    _animationController.isActive = playing;
  }

  void resetAnimation() {
    setPlaying(false);
    _animationController.reset();
  }

  String getSearchText() {
    return this._query;
  }

  void setSearchText(String text) {
    this._query = text;
  }

  Future<void> searchQuery(String query) async {
    try {
      state = const Loading();
      final latlon = await _deviceService.getCurrentLocationAsync();
      final search = await _googleMapsRepository.textLatLonSearch(query, latlon!.first, latlon.last);
      state = Loaded<ParsedResponse<List<GoogleMapsDTO>>>(search);
    } catch (error) {
      await log('LocationCategoryPageNotifier::initPage Error', '', LogType.Error);
      state = const Error('Error');
    }
  }
}
