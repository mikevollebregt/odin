import 'package:drift/drift.dart';

class TrackedMovements extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get trackedLocationId => integer()();
  IntColumn get movementCategoryId => integer().nullable()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  BoolColumn get confirmed => boolean().withDefault(const Constant(false))();
  TextColumn get uuid => text()();
  DateTimeColumn get created => dateTime().nullable()();
  DateTimeColumn get updated => dateTime().nullable()();
  DateTimeColumn get deleted => dateTime().nullable()();
}
