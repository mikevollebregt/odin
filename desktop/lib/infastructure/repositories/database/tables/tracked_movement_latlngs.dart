import 'package:drift/drift.dart';

class TrackedMovementLatLngs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get movementId => integer()();
  RealColumn get lat => real()();
  RealColumn get lon => real()();
  RealColumn get altitude => real()();
  TextColumn get uuid => text()();
  DateTimeColumn get mappedDate => dateTime()();
  DateTimeColumn get created => dateTime().nullable()();
  DateTimeColumn get updated => dateTime().nullable()();
  DateTimeColumn get deleted => dateTime().nullable()();
}
