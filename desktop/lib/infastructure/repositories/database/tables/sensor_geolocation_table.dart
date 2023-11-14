import 'package:drift/drift.dart';
class SensorGeolocations extends Table {
  IntColumn get id => integer().nullable().autoIncrement()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get altitude => real()();
  RealColumn get bearing => real()();
  RealColumn get accuracy => real()();
  RealColumn get speed => real()();
  TextColumn get sensorType => text()();
  TextColumn get provider => text()();
  BoolColumn get isNoise => boolean()();
  DateTimeColumn get createdOn => dateTime()();
  DateTimeColumn? get deletedOn => dateTime().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}
