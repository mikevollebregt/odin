import 'package:drift/drift.dart';

import 'classified_period_table.dart';
import 'google_maps_table.dart';
import 'reason_table.dart';


@DriftAccessor(tables: [ClassifiedPeriods, Reasons, GoogleMapsDatas])
class Stops extends Table {
  IntColumn get id => integer().nullable().autoIncrement()();
  IntColumn get classifiedPeriodId => integer().references(ClassifiedPeriods, #id)();
  IntColumn? get reasonId => integer().nullable().references(Reasons, #id)();
  IntColumn? get googleMapsDataId => integer().nullable().references(GoogleMapsDatas, #id)();

}
