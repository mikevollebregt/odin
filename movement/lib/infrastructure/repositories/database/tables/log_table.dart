import 'package:drift/drift.dart';

class Logs extends Table {
  IntColumn? get id => integer().nullable().autoIncrement()();
  TextColumn? get message => text().nullable()();
  TextColumn? get description => text().nullable()();
  TextColumn? get type => text().nullable()();
  DateTimeColumn? get date => dateTime().nullable()();
  BoolColumn? get synced => boolean().nullable().withDefault(const Constant(false))();
}
