import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'classified_period_table.dart';
import 'google_maps_table.dart';
import 'reason_table.dart';

@DriftAccessor(tables: [ClassifiedPeriods, Reasons, GoogleMapsDatas])
class Stops extends Table {
  TextColumn get uuid => text().clientDefault(() => Uuid().v4())();
  TextColumn get classifiedPeriodUuid => text().references(ClassifiedPeriods, #uuid)();
  IntColumn? get reasonId => integer().nullable().references(Reasons, #id)();
  TextColumn? get googleMapsDataUuid => text().nullable().references(GoogleMapsDatas, #uuid)();
  BoolColumn? get synced => boolean().nullable().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {uuid};
}
