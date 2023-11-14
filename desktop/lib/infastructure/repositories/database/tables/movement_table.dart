import 'package:drift/drift.dart';

import 'classified_period_table.dart';
import 'vehicle_table.dart';

@DriftAccessor(tables: [ClassifiedPeriods, Vehicles])
class Movements extends Table {
  IntColumn get id => integer().nullable().autoIncrement()();
  IntColumn get classifiedPeriodId => integer().references(ClassifiedPeriods, #id)();
  IntColumn? get vehicleId => integer().nullable().references(Vehicles, #id)();
}
