import 'package:latlong2/latlong.dart';

import '../../repositories/database/database.dart';
import 'parameters.dart';

bool isStop(LatLng referenceLatLng, SensorGeolocation newGeolocation) {
  final newLatLng = LatLng(newGeolocation.latitude, newGeolocation.longitude);
  final distance = const Distance()(referenceLatLng, newLatLng);
  return distance <= distanceTreshholdInMeters;
}
