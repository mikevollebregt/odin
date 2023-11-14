import 'package:uuid/uuid.dart';

import '../repositories/classified_period_repository.dart';
import '../repositories/database/database.dart';
import '../repositories/sensor_repository.dart';
import '../services/stop_classifier/noise_classifier.dart';
import '../services/stop_classifier/stop_classifier.dart';

class StopClassifierNotifier {
  final SensorRepository _sensorRepository;
  final ClassifiedPeriodRepository _classifierRepository;

  StopClassifierNotifier(this._sensorRepository, this._classifierRepository);

  Future<void> addSensorGeolocation(
      {required double latitude,
      required double longitude,
      required double accuracy,
      required double altitude,
      required double bearing,
      required double speed,
      required String sensorType,
      required String provider,
      required int batteryLevel}) async {
    var sensorGeolocation = SensorGeolocation(
        uuid: Uuid().v4(),
        latitude: latitude,
        longitude: longitude,
        accuracy: accuracy,
        altitude: altitude,
        bearing: bearing,
        speed: speed,
        sensorType: sensorType,
        provider: provider,
        isNoise: false,
        createdOn: DateTime.now(),
        synced: false,
        batteryLevel: batteryLevel);

    final lastValidSensorGeolocation = await _classifierRepository.getLastValidSensorGeolocation();
    if (isNoiseUsingLastValidSensorGeolocation(accuracy, latitude, longitude, lastValidSensorGeolocation)) {
      await _sensorRepository.insertSensorGeolocation(sensorGeolocation.copyWith(isNoise: true));
      return;
    }
    final referenceLatLng = await _classifierRepository.getReferenceLatLng();
    sensorGeolocation = sensorGeolocation.copyWith(isNoise: isNoise(accuracy, latitude, longitude, referenceLatLng));
    await _sensorRepository.insertSensorGeolocation(sensorGeolocation);
    if (sensorGeolocation.isNoise == false) {
      if (referenceLatLng != null) {
        await _classifierRepository.upsertClassifiedPeriod(
          isStop(referenceLatLng.latLng, sensorGeolocation),
          sensorGeolocation,
        );
      }
    }
  }
}
