import 'package:desktop/infastructure/repositories/database/tables/tracked_movement_latlngs.dart';
import 'package:drift/drift.dart';

import '../../database.dart';

part 'tracked_movement_latlng_dao.g.dart';

@DriftAccessor(tables: [TrackedMovementLatLngs])
class TrackedMovementLatLngsDao extends DatabaseAccessor<Database>
    with _$TrackedMovementLatLngsDaoMixin {
  TrackedMovementLatLngsDao(Database db) : super(db);

  Future<List<TrackedMovementLatLng>> get() =>
      (select(trackedMovementLatLngs)..where((tm) => tm.deleted.isNull()))
          .get();

  Future<List<TrackedMovementLatLng>> getByMovementId(int movementId) =>
      (select(trackedMovementLatLngs)
            ..where((tm) => tm.movementId.equals(movementId))
            ..where((tm) => tm.deleted.isNull()))
          .get();

  Stream<List<TrackedMovementLatLng>> watchAllLatLons() =>
      select(trackedMovementLatLngs).watch();

  Future<int> insertAsync(String uuid, double lat, double lon, double altitude,
          DateTime mappedDate, int movementId) =>
      into(trackedMovementLatLngs).insert(
          TrackedMovementLatLngsCompanion.insert(
              uuid: uuid,
              lat: lat,
              lon: lon,
              altitude: altitude,
              mappedDate: mappedDate,
              movementId: movementId));

  Future updateTrackedMovement(TrackedMovementLatLng ll) async {
    var updatedMovementLatLng = TrackedMovementLatLng(
        id: ll.id,
        lat: ll.lat,
        lon: ll.lon,
        altitude: ll.altitude,
        mappedDate: ll.mappedDate,
        movementId: ll.movementId,
        uuid: ll.uuid,
        created: ll.created,
        updated: DateTime.now(),
        deleted: null);

    await update(trackedMovementLatLngs).replace(updatedMovementLatLng);
  }

  Future deleteTrackedMovement(TrackedMovementLatLng ll) async {
    var deletedMovementLatLng = TrackedMovementLatLng(
        id: ll.id,
        lat: ll.lat,
        lon: ll.lon,
        altitude: ll.altitude,
        mappedDate: ll.mappedDate,
        movementId: ll.movementId,
        uuid: ll.uuid,
        created: ll.created,
        updated: ll.mappedDate,
        deleted: DateTime.now());

    await update(trackedMovementLatLngs).replace(deletedMovementLatLng);
  }
}
