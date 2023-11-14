import 'package:drift/drift.dart';
import 'package:movement/infrastructure/repositories/network/stop_api.dart';

import 'database/database.dart';
import 'dtos/stop_dto.dart';

class StopRepository {
  final Database _database;
  final StopApi _stopApi;

  StopRepository(this._database, this._stopApi);

  void add(StopDto stopDto) => _database.stopDao.addStop(stopDto);

  void remove(StopDto stopDto) => _database.stopDao.removeStop(stopDto);

  void update(StopDto stopDto, StopDto oldStopDto) => _database.stopDao.updateStop(stopDto, oldStopDto);

  Future<void> syncStops() async {
    final unsycnedStops = await _database.stopDao.getUnsycnedStops();
    for (var unsynced in unsycnedStops) {
      final _response = await _stopApi.sync(unsynced.copyWith(reasonId: Value(unsynced.reasonId ?? -1)));
      if (_response.isOk) await _database.stopDao.setSynced(unsynced);
    }
  }
}
