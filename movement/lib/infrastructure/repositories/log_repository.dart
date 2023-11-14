import 'package:drift/drift.dart';

import '../../main.dart';
import '../../providers.dart';
import 'database/database.dart';
import 'device_repository.dart';
import 'dtos/enums/log_type.dart';
import 'dtos/log_dto.dart';
import 'network/log_api.dart';

class LogRepository {
  final int hourInMilliseconds = 900000;
  final LogApi _logApi;
  final Database _database;
  final DeviceRepository _deviceRepository;

  LogRepository(this._logApi, this._database, this._deviceRepository);

  Future postLogAsync(String message, String description, LogType type) async {
    await _deviceRepository.checkIfDeviceIsStored();
    final logDTO = LogDTO(
      message: message,
      description: description,
      type: type.toString(),
      datetime: DateTime.now().millisecondsSinceEpoch,
    );

    await _logApi.postLog(logDTO);
  }

  Future<void> syncLogs({int limit = 5000}) async {
    final unsyncedLogs = await _database.logsDao.getUnSyncedLogs(limit);
    if (unsyncedLogs.isNotEmpty) {
      final _response = await _logApi.postLogs(LogDTO.fromList(unsyncedLogs));
      if (_response.isOk) {
        final synced = unsyncedLogs.map((e) => e.copyWith(synced: Value(true)));
        _database.logsDao.replaceBulkLog(synced);
      }
    }
  }

  Future<int> getSyncedCount() async => _database.logsDao.getSyncedCount();

  Future<int> getUnsyncedCount() async => _database.logsDao.getUnsyncedCount();
}

Future<void> log(String message, dynamic description, LogType logType) async {
  final convertedDescripion = description is String ? description : '';
  final db = container.read(database);
  final log = Log(message: message, description: convertedDescripion, synced: false, type: logType.toString(), date: DateTime.now());

  await db.logsDao.insertLog(log);
}

Future<void> logAuth(String description) async {
  final api = container.read(logApi);

  await api.postLogs(LogDTO.fromList(
      [Log(message: 'AuthNotifier::authenticate', description: description, synced: false, type: LogType.Flow.toString(), date: DateTime.now())]));
}
