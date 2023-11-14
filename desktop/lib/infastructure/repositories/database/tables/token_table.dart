import 'package:drift/drift.dart';

class Tokens extends Table {
  IntColumn? get id => integer().nullable().autoIncrement()();
  TextColumn get authToken => text()();
}
