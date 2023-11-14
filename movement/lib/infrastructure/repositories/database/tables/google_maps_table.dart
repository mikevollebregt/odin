import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class GoogleMapsDatas extends Table {
  TextColumn get uuid => text().clientDefault(() => Uuid().v4())();
  TextColumn? get googleId => text().nullable()();
  TextColumn? get address => text().nullable()();
  TextColumn? get city => text().nullable()();
  TextColumn? get postcode => text().nullable()();
  TextColumn? get country => text().nullable()();
  TextColumn? get name => text().nullable()();
  BoolColumn? get synced => boolean().nullable().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {uuid};
}
