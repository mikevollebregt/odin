import 'package:drift/drift.dart';
import 'package:movement/infrastructure/repositories/network/movement_api.dart';

import 'database/database.dart';
import 'dtos/movement_dto.dart';

class MovementRepository {
  final Database _database;
  final MovementApi _movementApi;

  MovementRepository(this._database, this._movementApi);

  void add(MovementDto movementDto) => _database.movementDao.addMovement(movementDto);

  void remove(MovementDto movementDto) => _database.movementDao.removeMovement(movementDto);

  void update(MovementDto movementDto, MovementDto oldMovementDto) => _database.movementDao.updateMovement(movementDto, oldMovementDto);

  Future<void> syncMovements() async {
    final unsycnedMovements = await _database.movementDao.getUnsycnedMovements();
    for (var unsynced in unsycnedMovements) {
      final _response = await _movementApi.sync(unsynced.copyWith(vehicleId: Value(unsynced.vehicleId ?? -1)));
      if (_response.isOk) await _database.movementDao.setSynced(unsynced);
    }
  }
}
