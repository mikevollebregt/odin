import 'package:latlong2/latlong.dart';

import '../../dtos/googlemaps_dto.dart';

class GoogleMapsCache {
  final _googleMapsDtoCache = <LatLng, GoogleMapsDTO>{};

  GoogleMapsDTO? get(LatLng latLng) => _googleMapsDtoCache.containsKey(latLng) ? _googleMapsDtoCache[latLng] : null;

  void add(LatLng latLng, GoogleMapsDTO googleMapsDto) => _googleMapsDtoCache[latLng] = googleMapsDto;
}
