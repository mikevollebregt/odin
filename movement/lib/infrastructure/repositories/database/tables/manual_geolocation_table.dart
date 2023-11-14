import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'classified_period_table.dart';

@DriftAccessor(tables: [ClassifiedPeriods])
class ManualGeolocations extends Table {
  TextColumn get uuid => text().clientDefault(() => Uuid().v4())();
  TextColumn get classifiedPeriodUuid => text().references(ClassifiedPeriods, #uuid)();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  DateTimeColumn get createdOn => dateTime()();
  DateTimeColumn? get deletedOn => dateTime().nullable()();
  BoolColumn? get synced => boolean().nullable().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {uuid};
}
