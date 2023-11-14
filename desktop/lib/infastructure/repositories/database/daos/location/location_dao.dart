import 'package:desktop/infastructure/repositories/database/tables/location_table.dart';
import 'package:desktop/infastructure/repositories/dtos/location_dto.dart';
import 'package:drift/drift.dart';

import '../../database.dart';

part 'location_dao.g.dart';

@DriftAccessor(tables: [Locations])
class LocationsDao extends DatabaseAccessor<Database> with _$LocationsDaoMixin {
  LocationsDao(Database db) : super(db);

  Future<Location?> getLastLocationAsync(String uuid) => (select(locations)
        ..where((tbl) => tbl.uuid.equals(uuid))
        ..orderBy(
            [(l) => OrderingTerm(expression: l.date, mode: OrderingMode.desc)])
        ..limit(1))
      .getSingleOrNull();

  Future<List<Location>> getLastMeaningFullLocationsAsync(String uuid) async {
    var foundLocations = <Location>[];
    var location = await getLastLocationAsync(uuid);

    if (location == null) {
      return foundLocations;
    }

    var l = await (select(locations)
          ..where((tbl) => tbl.uuid.equals(uuid))
          ..where((tbl) => tbl.trackedLocationId.isNull())
          ..where((tbl) => tbl.trackedMovementId.isNull())
          ..orderBy([
            (l) => OrderingTerm(expression: l.date, mode: OrderingMode.desc)
          ]))
        .get();

    foundLocations.addAll(l);

    return foundLocations;
  }

  Future<List<Location?>> getUnknownLocationsAsync() => (select(locations)
        ..where((l) => l.trackedLocationId.isNull())
        ..where((l) => l.trackedMovementId.isNull())
        ..orderBy(
            [(l) => OrderingTerm(expression: l.date, mode: OrderingMode.asc)]))
      .get();

  Future<List<Location>> getLocationsAsync() => select(locations).get();
  Future<List<Location>> getNotSyncedLocationsAsync() =>
      (select(locations)..where((tbl) => tbl.synced.not())).get();
  Future<List<Location>> getLocationsOrderedAsync() => (select(locations)
        ..orderBy(
            [(l) => OrderingTerm(expression: l.date, mode: OrderingMode.desc)])
        ..limit(10))
      .get();

  Stream<List<Location>> watchAllLocationsAsync() => select(locations).watch();

  Future insertLocationDTOAsync(LocationDTO dto) =>
      into(locations).insert(LocationsCompanion.insert(
          lon: dto.lon,
          lat: dto.lat,
          altitude: dto.altitude,
          sensorType: dto.sensorType,
          date: dto.date,
          uuid: dto.uuid!,
          isMoving: Value.ofNullable(dto.isMoving)));

  Future insertLocationAsync(Location location) =>
      into(locations).insert(location);
  Future updateLocationAsync(Location location) =>
      update(locations).replace(location);
  Future deleteLocationAsync(Location location) =>
      delete(locations).delete(location);
}
