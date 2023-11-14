import 'package:drift/drift.dart';

import 'tracked_day_table.dart';

@DriftAccessor(tables: [TrackedDays])
class ClassifiedPeriods extends Table {
  IntColumn get id => integer().nullable().autoIncrement()();
  IntColumn? get trackedDayId => integer().nullable().references(TrackedDays, #id)();
  IntColumn get type => integer()();
  IntColumn get userId => integer()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  BoolColumn get confirmed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdOn => dateTime()();
  DateTimeColumn? get deletedOn => dateTime().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}
