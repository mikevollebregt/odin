import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../dtos/movement_dto.dart';
import '../database.dart';
import '../tables/classified_period_table.dart';
import '../tables/google_maps_table.dart';
import '../tables/manual_geolocation_table.dart';
import '../tables/movement_table.dart';
import '../tables/reason_table.dart';
import '../tables/stop_table.dart';
import '../tables/vehicle_table.dart';

part 'movement_dao.g.dart';

@DriftAccessor(tables: [ClassifiedPeriods, Movements, Stops, Reasons, GoogleMapsDatas, ManualGeolocations, Vehicles])
class MovementDao extends DatabaseAccessor<Database> with _$MovementDaoMixin {
  MovementDao(Database db) : super(db);

  Future<void> removeMovement(MovementDto movementDto) async => db.classifiedPeriodDao.removeClassifiedPeriods([movementDto.classifiedPeriod]);

  Future<void> addMovement(MovementDto movementDto) async {
    return transaction(
      () async {
        final classifiedPeriodUuid = await db.classifiedPeriodDtoDao.addClassifiedPeriod(movementDto);
        await into(movements).insert(
          MovementsCompanion.insert(
            classifiedPeriodUuid: classifiedPeriodUuid,
            vehicleId: movementDto.vehicle != null ? Value(movementDto.vehicle!.id) : Value.absent(),
          ),
        );
      },
    );
  }

  void updateMovement(MovementDto movementDto, MovementDto oldMovementDto) {
    final _c = movementDto.classifiedPeriod;
    removeMovement(oldMovementDto);
    addMovement(movementDto.copyWith(classifiedPeriod: _c.copyWith(uuid: Uuid().v4(), origin: Value(_c.uuid))));
  }

  Future<List<Movement>> getUnsycnedMovements() async => (select(movements)..where((c) => c.synced.equals(false))).get();

  Future<void> setSynced(Movement movement) async => await update(movements).replace(movement.copyWith(synced: Value(true)));
}
