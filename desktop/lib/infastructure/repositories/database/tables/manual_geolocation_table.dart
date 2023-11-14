import 'package:drift/drift.dart';

import 'classified_period_table.dart';

@DriftAccessor(tables: [ClassifiedPeriods])
class ManualGeolocations extends Table {
  IntColumn get id => integer().nullable().autoIncrement()();
  IntColumn get classifiedPeriodId => integer().references(ClassifiedPeriods, #id)();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  DateTimeColumn get createdOn => dateTime()();
  DateTimeColumn? get deletedOn => dateTime().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}
