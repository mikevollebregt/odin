import 'package:drift/drift.dart';

class AlgoStates extends Table {
  IntColumn get id => integer().autoIncrement()();
  BoolColumn get isMoving => boolean()();
  IntColumn get lastLocationIndex => integer()();
  IntColumn get lastMovingIndex => integer()();
  IntColumn get timeNotMoving => integer()();
}
