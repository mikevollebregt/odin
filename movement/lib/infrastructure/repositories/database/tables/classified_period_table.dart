import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'tracked_day_table.dart';

@DriftAccessor(tables: [TrackedDays])
class ClassifiedPeriods extends Table {
  TextColumn get uuid => text().clientDefault(() => Uuid().v4())();
  TextColumn? get trackedDayUuid => text().nullable().references(TrackedDays, #uuid)();
  TextColumn? get origin => text().nullable()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  BoolColumn get confirmed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdOn => dateTime()();
  DateTimeColumn? get deletedOn => dateTime().nullable()();
  BoolColumn? get synced => boolean().nullable().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {uuid};
}
