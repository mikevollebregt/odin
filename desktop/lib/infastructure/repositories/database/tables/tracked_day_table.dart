import 'package:drift/drift.dart';

class TrackedDays extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get confirmed => boolean().withDefault(const Constant(false))();
  IntColumn? get choiceId => integer().nullable()();
  TextColumn? get choiceText => text().nullable()();
}
