import 'package:desktop/infastructure/repositories/database/tables/tracked_day_table.dart';
import 'package:desktop/infastructure/repositories/database/tables/tracked_location_table.dart';
import 'package:drift/drift.dart';

import '../../database.dart';

part 'tracked_location_dao.g.dart';

@DriftAccessor(tables: [TrackedLocations, TrackedDays])
class TrackedLocationsDao extends DatabaseAccessor<Database> with _$TrackedLocationsDaoMixin {
  TrackedLocationsDao(Database db) : super(db);

  Future<List<TrackedLocation>> getAsync() => (select(trackedLocations)..where((tm) => tm.deleted.isNull())).get();

  Future<List<TrackedLocation>> getByTrackedIdAsync(int trackedDayId) => (select(trackedLocations)
        ..where((tm) => tm.deleted.isNull())
        ..where((tm) => tm.trackedDayId.equals(trackedDayId)))
      .get();

  Future<int> getSecondsByCategoryId(int categoryId) async {
    var locations = await (select(trackedLocations)
          //..where((tm) => tm.locationCategoryId.equals(categoryId))
          ..where((tm) => tm.deleted.isNull()))
        .map((row) => row.endTime.millisecondsSinceEpoch - row.startTime.millisecondsSinceEpoch)
        .get();

    var total = 0.0;
    for (var location in locations) {
      total += location * 0.001;
    }

    return total.round();
  }

  Future<int> getSecondsByCategoryIdAndDay(int categoryId, int day) async {
    // var locations = await (select(trackedDays)
    //       ..where((tm) => tm..day.equals(day))
    //       ..where((tm) => tm.deleted.isNull()))
    //     .join([
    //       innerJoin(
    //           trackedLocations,
    //           trackedDays.id.equalsExp(trackedLocations.trackedDayId) &
    //               //trackedLocations.locationCategoryId.equals(categoryId) &
    //               trackedLocations.deleted.isNull()),
    //     ])
    //     .map((rows) =>
    //         rows.readTable(trackedLocations).endTime.millisecondsSinceEpoch -
    //         rows.readTable(trackedLocations).startTime.millisecondsSinceEpoch)
    //     .get();

    // var total = 0.0;
    // for (var location in locations) {
    //   total += location * 0.001;
    // }

    return 0;
  }

  Future<TrackedLocation?> getByStarttimeAsync(DateTime startTime) => (select(trackedLocations)
        ..where((tm) => tm.endTime.isSmallerOrEqualValue(startTime))
        ..where((tm) => tm.deleted.isNull())
        ..orderBy([(t) => OrderingTerm(expression: t.endTime, mode: OrderingMode.desc)])
        ..limit(1))
      .getSingleOrNull();

  Future<TrackedLocation?> getByMovementStarttimeAsync(DateTime startTime) => (select(trackedLocations)
        ..where((tm) => tm.startTime.isSmallerOrEqualValue(startTime))
        ..where((tm) => tm.deleted.isNull())
        ..orderBy([(t) => OrderingTerm(expression: t.endTime, mode: OrderingMode.desc)])
        ..limit(1))
      .getSingleOrNull();

  Future<List<TrackedLocation>> getTrackedLocationAsync(DateTime startTime, DateTime endTime) => (select(trackedLocations)
        ..where((tm) => tm.deleted.isNull())
        ..where((tm) => tm.startTime.day.equals(startTime.day))
        ..orderBy([(t) => OrderingTerm(expression: t.startTime)]))
      .get();

  Stream<List<TrackedLocation>> watchAllTrackedLocations() => select(trackedLocations).watch();

  Future<int> insertTrackedLocationAsync(double lat, double lon, DateTime startTime, DateTime endTime, int trackedDayId, String uuid) async {
    var newTrackedLocation =
        TrackedLocationsCompanion.insert(trackedDayId: trackedDayId, startTime: startTime, endTime: endTime, lat: lat, lon: lon, uuid: uuid);

    var id = await into(trackedLocations).insert(newTrackedLocation);

    return id;
  }

  Future updateTrackedLocationAsync(TrackedLocation tl) async {
    var updatedTrackedLocation = TrackedLocation(
        id: tl.id,
        trackedDayId: tl.trackedDayId,
        reasonId: tl.reasonId,
        startTime: tl.startTime,
        endTime: tl.endTime,
        confirmed: tl.confirmed,
        lat: tl.lat,
        lon: tl.lon,
        name: tl.name,
        uuid: tl.uuid,
        created: tl.created,
        deleted: tl.deleted,
        updated: DateTime.now());

    await update(trackedLocations).replace(updatedTrackedLocation);
  }

  Future deleteTrackedLocationAsync(TrackedLocation tl) async {
    var deletedTrackedLocation = TrackedLocation(
        id: tl.id,
        reasonId: tl.reasonId,
        trackedDayId: tl.trackedDayId,
        startTime: tl.startTime,
        endTime: tl.endTime,
        confirmed: tl.confirmed,
        lat: tl.lat,
        lon: tl.lon,
        name: tl.name,
        uuid: tl.uuid,
        created: tl.created,
        deleted: DateTime.now(),
        updated: tl.updated);

    await update(trackedLocations).replace(deletedTrackedLocation);
  }

  Future deleteTrackedLocationByIdAsync(int id) async {
    var tl = await (select(trackedLocations)..where((tm) => tm.id.equals(id))).getSingleOrNull();

    if (tl == null) {
      return;
    }

    var deletedTrackedLocation = TrackedLocation(
        id: tl.id,
        uuid: tl.uuid,
        reasonId: tl.reasonId,
        trackedDayId: tl.trackedDayId,
        startTime: tl.startTime,
        endTime: tl.endTime,
        confirmed: tl.confirmed,
        lat: tl.lat,
        lon: tl.lon,
        name: tl.name,
        created: tl.created,
        deleted: DateTime.now(),
        updated: tl.updated);

    await update(trackedLocations).replace(deletedTrackedLocation);
  }
}
