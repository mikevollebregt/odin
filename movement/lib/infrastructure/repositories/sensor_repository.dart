import 'package:drift/drift.dart';

import 'database/database.dart';
import 'dtos/sensor_stats_dto.dart';
import 'network/sensor_geolocation_api.dart';

class SensorRepository {
  final Database _database;
  final SensorGeolocationApi _sensorGeolocationApi;

  SensorRepository(this._database, this._sensorGeolocationApi);

  Future<int> insertSensorGeolocation(SensorGeolocation sensorGeolocation) async => _database.sensorGeolocationDao.insertSensorGeolocation(sensorGeolocation);

  Future<int> getSensorGeolocationCount() async => _database.sensorGeolocationDao.getSensorGeolocationCount();

  Future<void> syncSensorGeolocations({int limit = 5000}) async {
    final unsycnedSensorGeolocations = await _database.sensorGeolocationDao.getUnsycnedSensorGeolocations(limit);
    if (unsycnedSensorGeolocations.isNotEmpty) {
      final _response = await _sensorGeolocationApi.syncSensorGeolocation(unsycnedSensorGeolocations);
      if (_response.isOk) {
        final synced = unsycnedSensorGeolocations.map((e) => e.copyWith(synced: Value(true)));
        _database.sensorGeolocationDao.replaceBulkSensorGeolocation(synced);
      }
    }
  }

  Future<int> getSyncedCount() async => _database.sensorGeolocationDao.getSyncedCount();

  Future<int> getUnsyncedCount() async => _database.sensorGeolocationDao.getUnsyncedCount();

  Future<List<SensorStatsDto>> getSensorStats() async => _database.sensorGeolocationDao.getSensorStats();

  Future<SensorGeolocation?> getLastBackgroundSensorGeolocation() async => _database.sensorGeolocationDao.getLastBackgroundSensorGeolocation();
}
