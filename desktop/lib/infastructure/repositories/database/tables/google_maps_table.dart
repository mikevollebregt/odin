import 'package:drift/drift.dart';


class GoogleMapsDatas extends Table {
  IntColumn get id => integer().nullable().autoIncrement()();
  TextColumn? get googleId => text().nullable()();
  TextColumn? get address => text().nullable()();
  TextColumn? get city => text().nullable()();
  TextColumn? get postcode => text().nullable()();
  TextColumn? get country => text().nullable()();
  TextColumn? get name => text().nullable()();
}
