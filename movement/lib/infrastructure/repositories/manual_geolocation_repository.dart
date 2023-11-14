import 'package:movement/infrastructure/repositories/network/manual_geolocation_api.dart';

import 'database/database.dart';

class ManualGeolocationRepository {
  final Database _database;
  final ManualGeolocationApi _manualGeolocationApi;

  ManualGeolocationRepository(this._database, this._manualGeolocationApi);

  Future<void> syncManualGeolocation() async {
    final unsycnedStops = await _database.manualGeolocationDao.getUnsycnedManualGeolocations();
    for (final unsynced in unsycnedStops) {
      final _response = await _manualGeolocationApi.sync(unsynced);
      if (_response.isOk) await _database.manualGeolocationDao.setSynced(unsynced);
    }
  }
}
