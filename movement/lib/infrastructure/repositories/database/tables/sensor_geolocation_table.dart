import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class SensorGeolocations extends Table {
  TextColumn get uuid => text().clientDefault(() => Uuid().v4())();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get altitude => real()();
  RealColumn get bearing => real()();
  RealColumn get accuracy => real()();
  RealColumn get speed => real()();
  TextColumn get sensorType => text()();
  TextColumn get provider => text()();
  BoolColumn get isNoise => boolean()();
  IntColumn get batteryLevel => integer()();
  DateTimeColumn get createdOn => dateTime()();
  DateTimeColumn? get deletedOn => dateTime().nullable()();
  BoolColumn? get synced => boolean().nullable().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {uuid};
}
