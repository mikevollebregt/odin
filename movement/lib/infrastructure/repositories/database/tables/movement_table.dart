import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'classified_period_table.dart';
import 'vehicle_table.dart';

@DriftAccessor(tables: [ClassifiedPeriods, Vehicles])
class Movements extends Table {
  TextColumn get uuid => text().clientDefault(() => Uuid().v4())();
  TextColumn get classifiedPeriodUuid => text().references(ClassifiedPeriods, #uuid)();
  IntColumn? get vehicleId => integer().nullable().references(Vehicles, #id)();
  BoolColumn? get synced => boolean().nullable().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {uuid};
}
