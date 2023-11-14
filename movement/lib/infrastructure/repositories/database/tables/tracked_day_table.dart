import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class TrackedDays extends Table {
  TextColumn get uuid => text().clientDefault(() => Uuid().v4())();
  DateTimeColumn get date => dateTime()();
  BoolColumn get confirmed => boolean().withDefault(const Constant(false))();
  IntColumn? get choiceId => integer().nullable()();
  TextColumn? get choiceText => text().nullable()();
  BoolColumn? get synced => boolean().nullable().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {uuid};
}
