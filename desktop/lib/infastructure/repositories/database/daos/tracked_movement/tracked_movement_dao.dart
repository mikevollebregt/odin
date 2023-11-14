import 'package:desktop/infastructure/repositories/database/tables/tracked_movement_table.dart';
import 'package:drift/drift.dart';

import '../../database.dart';

part 'tracked_movement_dao.g.dart';

@DriftAccessor(tables: [TrackedMovements])
class TrackedMovementsDao extends DatabaseAccessor<Database>
    with _$TrackedMovementsDaoMixin {
  TrackedMovementsDao(Database db) : super(db);

  Future<List<TrackedMovement>> get() =>
      (select(trackedMovements)..where((tm) => tm.deleted.isNull())).get();

  Future<List<TrackedMovement>> getByLocationId(int locationId) =>
      (select(trackedMovements)
            ..where((tm) => tm.trackedLocationId.equals(locationId))
            ..where((tm) => tm.deleted.isNull())
            ..orderBy([(t) => OrderingTerm(expression: t.startTime)]))
          .get();

  Future<TrackedMovement?> getByIdAsync(int id) => (select(trackedMovements)
        ..where((tm) => tm.id.equals(id))
        ..where((tm) => tm.deleted.isNull()))
      .getSingleOrNull();

  Stream<List<TrackedMovement>> watchAllTrackedMovements() =>
      select(trackedMovements).watch();

  Future<int> insertAsync(TrackedMovement movement) =>
      into(trackedMovements).insert(TrackedMovementsCompanion.insert(
          uuid: movement.uuid,
          trackedLocationId: movement.trackedLocationId,
          startTime: movement.startTime,
          endTime: movement.endTime));

  Future updateTrackedMovement(TrackedMovement tm) async {
    var updatedTrackedMovement = TrackedMovement(
        id: tm.id,
        uuid: tm.uuid,
        trackedLocationId: tm.trackedLocationId,
        movementCategoryId: tm.movementCategoryId,
        confirmed: tm.confirmed,
        startTime: tm.startTime,
        endTime: tm.endTime,
        created: tm.created,
        updated: DateTime.now(),
        deleted: tm.deleted);

    await update(trackedMovements).replace(updatedTrackedMovement);
  }

  Future deleteTrackedMovement(TrackedMovement tm) async {
    var deletedTrackedMovement = TrackedMovement(
        id: tm.id,
        uuid: tm.uuid,
        trackedLocationId: tm.trackedLocationId,
        movementCategoryId: tm.movementCategoryId,
        confirmed: tm.confirmed,
        startTime: tm.startTime,
        endTime: tm.endTime,
        created: tm.created,
        updated: tm.updated,
        deleted: DateTime.now());

    await update(trackedMovements).replace(deletedTrackedMovement);
  }

  Future<List<TrackedMovement>> getTrackedMovementAsync(
          DateTime startTime, DateTime endTime) =>
      (select(trackedMovements)
            ..where((tm) => tm.deleted.isNull())
            ..where((tm) => tm.startTime.day.equals(startTime.day)))
          .get();

  Future deleteTrackedMovementByIdAsync(int id) async {
    var tm = await (select(trackedMovements)..where((tm) => tm.id.equals(id)))
        .getSingleOrNull();

    if (tm == null) {
      return;
    }

    var deletedTrackedMovement = TrackedMovement(
        id: tm.id,
        uuid: tm.uuid,
        trackedLocationId: tm.trackedLocationId,
        movementCategoryId: tm.movementCategoryId,
        confirmed: tm.confirmed,
        startTime: tm.startTime,
        endTime: tm.endTime,
        created: tm.created,
        updated: tm.updated,
        deleted: DateTime.now());

    await update(trackedMovements).replace(deletedTrackedMovement);
  }
}
