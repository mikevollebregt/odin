import 'package:drift/drift.dart';

class Devices extends Table {
  IntColumn get id => integer().nullable().autoIncrement()();
  TextColumn get device => text().nullable().withLength(min: 1, max: 150)();
  TextColumn get version => text().nullable().withLength(min: 1, max: 150)();
  TextColumn get product => text().nullable().withLength(min: 1, max: 150)();
  TextColumn get model => text().nullable().withLength(min: 1, max: 150)();
  TextColumn get brand => text().nullable().withLength(min: 1, max: 150)();
  TextColumn get androidId => text().nullable().withLength(min: 1, max: 150)();
  TextColumn get secureId => text().nullable().withLength(min: 1, max: 150)();
  TextColumn get sdk => text().nullable().withLength(min: 1, max: 150)();
  RealColumn get width => real().nullable()();
  RealColumn get height => real().nullable()();
  RealColumn get widthLogical => real().nullable()();
  RealColumn get heightLogical => real().nullable()();
  BoolColumn get sensorLock => boolean().withDefault(const Constant(false))();
  BoolColumn get logLock => boolean().withDefault(const Constant(false))();
}
