import 'dart:math';

import 'package:latlong2/latlong.dart';

import '../../repositories/database/database.dart';
import '../../repositories/dtos/reference_latlng_dto.dart';

bool _addsTooLittleData(SensorGeolocation lastValidSensorGeolocation) {
  final secondsAgo = DateTime.now().difference(lastValidSensorGeolocation.createdOn).inSeconds;
  if (secondsAgo <= 3 && lastValidSensorGeolocation.accuracy <= 15) return true;
  return false;
}

bool _hasInsufficientAccuracy(double accuracy, DateTime referenceDateTime) {
  final secondsAgo = DateTime.now().difference(referenceDateTime).inSeconds;
  if (secondsAgo <= 20) return accuracy > 20;
  if (secondsAgo <= 45) return accuracy > 35;
  if (secondsAgo <= 180) return accuracy > 50;
  return accuracy > 65;
}

bool _hasUnrealisticSpeed(LatLng sensor, LatLng reference, DateTime referenceDateTime) {
  final secondsAgo = DateTime.now().difference(referenceDateTime).inSeconds;
  const _maxKilometerPerHour = 200;
  const _treshHoldInMetersPerSecond = 1000 / 3600 * _maxKilometerPerHour;
  final distanceInMeters = Distance()(sensor, reference);
  final speedInMeterPerSecond = distanceInMeters / max(secondsAgo, 1);
  return speedInMeterPerSecond > _treshHoldInMetersPerSecond;
}

bool isNoiseUsingLastValidSensorGeolocation(double accuracy, double latitude, double longitude, SensorGeolocation? lastValidSensorGeolocation) {
  if (lastValidSensorGeolocation == null) return accuracy > 50;
  if (_addsTooLittleData(lastValidSensorGeolocation)) return true;
  if (_hasInsufficientAccuracy(accuracy, lastValidSensorGeolocation.createdOn)) return true;
  if (_hasUnrealisticSpeed(
    LatLng(latitude, longitude),
    LatLng(lastValidSensorGeolocation.latitude, lastValidSensorGeolocation.longitude),
    lastValidSensorGeolocation.createdOn,
  )) return true;
  return false;
}

bool isNoise(double accuracy, double latitude, double longitude, ReferenceLatLngDto? referenceLatLngDto) {
  if (referenceLatLngDto == null) return accuracy > 50;
  if (_hasUnrealisticSpeed(
    LatLng(latitude, longitude),
    referenceLatLngDto.latLng,
    referenceLatLngDto.date,
  )) return true;
  return false;
}
