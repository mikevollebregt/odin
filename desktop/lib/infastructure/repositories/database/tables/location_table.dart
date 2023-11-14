import 'package:drift/drift.dart';

class Locations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get trackedLocationId => integer().nullable()();
  IntColumn get trackedMovementId => integer().nullable()();
  RealColumn get lon => real()();
  RealColumn get lat => real()();
  RealColumn get altitude => real()();
  TextColumn get sensorType => text()();
  TextColumn get uuid => text()();
  IntColumn get date => integer()();
  BoolColumn get isMoving => boolean().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}
