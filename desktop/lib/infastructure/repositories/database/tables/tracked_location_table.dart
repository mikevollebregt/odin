import 'package:drift/drift.dart';

class TrackedLocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().nullable()();
  IntColumn get reasonId => integer().nullable()();
  IntColumn get trackedDayId => integer()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  BoolColumn get confirmed => boolean().withDefault(const Constant(false))();
  RealColumn get lat => real()();
  RealColumn get lon => real()();
  TextColumn get uuid => text()();
  DateTimeColumn get created => dateTime().nullable()();
  DateTimeColumn get updated => dateTime().nullable()();
  DateTimeColumn get deleted => dateTime().nullable()();
}
