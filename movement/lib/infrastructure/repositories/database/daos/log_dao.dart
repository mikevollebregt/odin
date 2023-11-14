import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/log_table.dart';

part 'log_dao.g.dart';

@DriftAccessor(tables: [Logs])
class LogsDao extends DatabaseAccessor<Database> with _$LogsDaoMixin {
  LogsDao(Database db) : super(db);

  Future<List<Log>> get() => select(logs).get();

  Future<List<Log>> getUnSyncedLogs(limit) => (select(logs)
        ..where((l) => l.synced.equals(false))
        ..limit(limit))
      .get();

  Stream<List<Log>> watchAllLogs() => select(logs).watch();
  Future insertLog(Log log) => into(logs).insert(log);
  Future updateLog(Log log) => update(logs).replace(log);
  Future deleteLog(Log log) => delete(logs).delete(log);

  Future<void> replaceBulkLog(Iterable<Log> logList) async {
    await batch((batch) {
      batch.replaceAll(logs, logList);
    });
  }

  Future<int> getSyncedCount() async => (await (select(logs)..where((l) => l.synced.equals(true))).get()).length;

  Future<int> getUnsyncedCount() async => (await (select(logs)..where((l) => l.synced.equals(false))).get()).length;
}
