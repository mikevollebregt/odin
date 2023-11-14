import 'package:movement/infrastructure/repositories/movement_repository.dart';

import '../repositories/classified_period_repository.dart';
import '../repositories/database/database.dart';
import '../repositories/dtos/movement_dto.dart';
import '../repositories/vehicle_repository.dart';
import 'classified_period_notifier.dart';

class MovementNotifier extends ClassifiedPeriodNotifier {
  final MovementRepository _movementRepository;
  final ClassifiedPeriodRepository _classifiedPeriodRepository;
  final VehicleRepository _vehicleRepository;

  MovementDto _movementDto;
  MovementDto get movementDto => _movementDto;

  bool _isModified = false;

  MovementNotifier(this._movementRepository, this._classifiedPeriodRepository, this._vehicleRepository, this._movementDto)
      : super(_movementDto, _classifiedPeriodRepository) {
    _listenToSensorLocationUpdates();
  }

  void _listenToSensorLocationUpdates() {
    _classifiedPeriodRepository.streamClassifiedPeriodDto(movementDto.classifiedPeriod.uuid).map((dto) => dto as MovementDto?).listen(
      (dtoUpdate) {
        if (_isModified == false && dtoUpdate != null) _movementDto = movementDto.copyWith(sensorGeolocations: dtoUpdate.sensorGeolocations);
      },
    );
  }

  void updateMovement({Vehicle? vehicle}) {
    _movementDto = _movementDto.copyWith(vehicle: vehicle);
    _isModified = true;
    notifyListeners();
  }

  Future<void> save() async {
    if (_isModified || super.isModified)
      _movementRepository.update(movementDto.copyWith(classifiedPeriod: super.classifiedPeriodDto.classifiedPeriod.copyWith(confirmed: true)), movementDto);
  }

  void delete() => _movementRepository.remove(movementDto);

  Future<List<Vehicle>?> getVehicles() => _vehicleRepository.getVehicles();
}
