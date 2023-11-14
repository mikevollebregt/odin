import 'package:movement/infrastructure/repositories/stop_repository.dart';

import '../repositories/classified_period_repository.dart';
import '../repositories/database/database.dart';
import '../repositories/dtos/stop_dto.dart';
import '../repositories/reason_repository.dart';
import 'classified_period_notifier.dart';

class StopNotifier extends ClassifiedPeriodNotifier {
  final StopRepository _stopRepository;
  final ClassifiedPeriodRepository _classifiedPeriodRepository;
  final ReasonRepository _reasonRepository;

  StopDto _stopDto;
  StopDto get stopDto => _stopDto;

  bool _isModified = false;

  StopNotifier(this._stopRepository, this._classifiedPeriodRepository, this._reasonRepository, this._stopDto) : super(_stopDto, _classifiedPeriodRepository) {
    _listenToSensorLocationUpdates();
  }

  void _listenToSensorLocationUpdates() {
    _classifiedPeriodRepository.streamClassifiedPeriodDto(stopDto.classifiedPeriod.uuid).map((dto) => dto as StopDto?).listen(
      (dtoUpdate) {
        if (_isModified == false && dtoUpdate != null) _stopDto = stopDto.copyWith(sensorGeolocations: dtoUpdate.sensorGeolocations);
      },
    );
  }

  void updateStop({GoogleMapsData? googleMapsData, List<ManualGeolocation>? manualGeolocations, Reason? reason}) {
    _stopDto = stopDto.copyWith(googleMapsData: googleMapsData, manualGeolocations: manualGeolocations, reason: reason);
    _isModified = true;
    notifyListeners();
  }

  Future<void> save() async {
    if (_isModified || super.isModified)
      _stopRepository.update(stopDto.copyWith(classifiedPeriod: super.classifiedPeriodDto.classifiedPeriod.copyWith(confirmed: true)), stopDto);
  }

  void delete() => _stopRepository.remove(stopDto);

  Future<List<Reason>?> getStopReasons() => _reasonRepository.getReasons();
}
