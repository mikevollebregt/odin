import 'package:flutter/material.dart';
import 'package:movement/infrastructure/repositories/sensor_repository.dart';

import '../../main.dart';
import '../../providers.dart';

DateTime? _lastSync;

class SyncNotifier extends ChangeNotifier {
  final SensorRepository _sensorRepository;

  double syncPrecentage = 0.0;
  bool isSyncing = false;

  SyncNotifier(this._sensorRepository);

  Future<void> updateSyncPercentage() async {
    final syncCount = await this._sensorRepository.getSyncedCount() * 1.0;
    final unsyncCount = await this._sensorRepository.getUnsyncedCount() * 1.0;

    if (syncCount + unsyncCount != 0) syncPrecentage = syncCount / (syncCount + unsyncCount) * 100;
    isSyncing = false;

    notifyListeners();
  }

  Future<void> refreshSyncPercentage() async {
    final syncCount = await this._sensorRepository.getSyncedCount() * 1.0;
    final unsyncCount = await this._sensorRepository.getUnsyncedCount() * 1.0;

    if (syncCount + unsyncCount != 0) syncPrecentage = syncCount / (syncCount + unsyncCount) * 100;
    isSyncing = false;
  }

  void setSynced(bool sync) {
    isSyncing = sync;
    notifyListeners();
  }

  Future<void> sync({bool throttle = true, int iterations = 1}) async {
    if (throttle) if (_lastSync != null) if (DateTime.now().difference(_lastSync!).inSeconds < 20) return;
    _lastSync = DateTime.now();

    print('Syncing all... ${DateTime.now()}');

    for (int i = 0; i <= iterations; i++) {
      await container.read(sensorRepository).syncSensorGeolocations();
      await container.read(classifiedPeriodRepository).syncClassifiedPeriods();
      await container.read(stopRepository).syncStops();
      await container.read(movementRepository).syncMovements();
      await container.read(manualGeolocationRepository).syncManualGeolocation();
      await container.read(googleMapsRepository).syncGoogleMapsData();
      await container.read(logRepository).syncLogs();
    }
  }
}
