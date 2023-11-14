import 'package:latlong2/latlong.dart';
import 'package:movement/infrastructure/repositories/network/googlemaps_api.dart';

import 'database/cache/google_maps_cache.dart';
import 'database/database.dart';
import 'dtos/googlemaps_dto.dart';
import 'dtos/parsed_response.dart';

class GoogleMapsRepository {
  final Database _database;
  final GoogleMapsApi _googleMapsApi;
  final GoogleMapsCache _googleMapsCache;

  GoogleMapsRepository(this._database, this._googleMapsApi, this._googleMapsCache);

  Future<GoogleMapsDTO?> latLongSearch(LatLng latLng) async {
    var googleMapsDto = _googleMapsCache.get(latLng);
    if (googleMapsDto != null) return googleMapsDto;
    var responseList = await _googleMapsApi.latLongSearch(latLng.latitude, latLng.longitude);
    try {
      googleMapsDto = responseList!.payload!.first;
    } catch (e) {
      print(e);
    }
    if (googleMapsDto != null) _googleMapsCache.add(latLng, googleMapsDto);
    return googleMapsDto;
  }

  Future<ParsedResponse<List<GoogleMapsDTO>>> textSearch(String query) async => _googleMapsApi.textSearch(query);

  Future<ParsedResponse<List<GoogleMapsDTO>>> textLatLonSearch(String query, double lat, double lon) async =>
      _googleMapsApi.textLatLonSearch(query, lat, lon);

  Future<void> syncGoogleMapsData() async {
    final unsycnedGoogleMapsData = await _database.googleMapsDataDao.getUnsycnedGoogleMapsDatas();
    for (final unsynced in unsycnedGoogleMapsData) {
      final _response = await _googleMapsApi.sync(unsynced);
      if (_response.isOk) await _database.googleMapsDataDao.setSynced(unsynced);
    }
  }
}
