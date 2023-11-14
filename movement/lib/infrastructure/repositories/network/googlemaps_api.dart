import 'dart:async';

import 'package:latlong2/latlong.dart';

import '../database/database.dart';
import '../dtos/googlemaps_dto.dart';
import '../dtos/parsed_response.dart';
import 'base_api.dart';

class GoogleMapsApi extends BaseApi {
  GoogleMapsApi(Database database) : super('googlesearch/', database);

  Future<ParsedResponse<List<GoogleMapsDTO>>?> latLongSearch(double lat, double lon) async {
    if (_shouldThrottle(LatLng(lat, lon))) return null;
    return this.getParsedResponse<List<GoogleMapsDTO>, GoogleMapsDTO>('geosearch/$lat/$lon', GoogleMapsDTO.fromMap);
  }

  Future<ParsedResponse<List<GoogleMapsDTO>>> textSearch(String query) async {
    return this.getParsedResponse<List<GoogleMapsDTO>, GoogleMapsDTO>('textsearch/$query', GoogleMapsDTO.fromMap);
  }

  Future<ParsedResponse<List<GoogleMapsDTO>>> textLatLonSearch(String query, double lat, double lon) async {
    return this.getParsedResponse<List<GoogleMapsDTO>, GoogleMapsDTO>('textsearch/$query/$lat/$lon', GoogleMapsDTO.fromMap);
  }

  Future<ParsedResponse<GoogleMapsData?>> sync(GoogleMapsData googleMapsData) async => this.getParsedResponse<GoogleMapsData, GoogleMapsData>(
        'upsert',
        GoogleMapsData.fromJson,
        payload: googleMapsData,
      );

  final _throttleMap = <LatLng, DateTime>{};
  bool _shouldThrottle(LatLng key, [Duration duration = const Duration(microseconds: 1000)]) {
    _throttleMap.removeWhere((_, dateTime) => dateTime.isBefore(DateTime.now().subtract(duration)));
    if (_throttleMap.containsKey(key)) return true;
    _throttleMap[key] = DateTime.now();
    return false;
  }
}
