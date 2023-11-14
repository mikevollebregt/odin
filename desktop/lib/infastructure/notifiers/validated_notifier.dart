import 'package:desktop/infastructure/repositories/dtos/classified_period_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/movement_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/reason_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/stop_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/vehicle_dto.dart';
import 'package:desktop/infastructure/repositories/network/classified_period_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../period_classifier/enums/stop_enum.dart';
import '../period_classifier/enums/transport_enum.dart';
import '../repositories/database/database.dart';
import 'generic_notifier.dart';

class ValidatedNotifier extends StateNotifier<NotifierState> {
  final List<ClassifiedPeriodDto> periods = <ClassifiedPeriodDto>[];
  final ClassifiedPeriodApi _classifiedPeriodApi;
  int userId = 0;
  DateTime date = DateTime.now();
  MovementDto movement = MovementDto(
      movementId: 0,
      vehicle: VehicleDTO(key: "Walking"),
      classifiedPeriod:
          ClassifiedPeriod(type: 1, startDate: DateTime.now(), endDate: DateTime.now(), synced: false, confirmed: false, createdOn: DateTime.now(), userId: 0),
      manualGeolocations: [],
      sensorGeolocations: []);
  StopDto stop = StopDto(
      stopId: 0,
      reason: ReasonDTO(key: "Home"),
      classifiedPeriod:
          ClassifiedPeriod(type: 1, startDate: DateTime.now(), endDate: DateTime.now(), synced: false, confirmed: false, createdOn: DateTime.now(), userId: 0),
      manualGeolocations: [],
      sensorGeolocations: [],
      googleMapsData: null);

  ValidatedNotifier(this._classifiedPeriodApi) : super(const Initial());

  void clearPeriods() {
    periods.clear();
  }

  void addStop(StopDto stopDto) {
    periods.add(stopDto);
  }

  void addMovement(MovementDto movementDto) {
    periods.add(movementDto);
  }

  Future getClassifiedPeriods() async {}

  Future savePeriods() async {
    state = const Loading();

    for (var period in periods) {
      if (period is StopDto && period.classifiedPeriod.id == null) {
        await _classifiedPeriodApi.addStop(userId, period);
      }

      if (period is MovementDto && period.classifiedPeriod.id == null) {
        await _classifiedPeriodApi.addMovement(userId, period);
      }
    }

    state = Loaded(periods);
  }

  void setVehicle(String vehicle) {
    var transport = Transport.values.firstWhere((element) => element.toString() == "Transport." + vehicle);

    movement = movement.copyWith(vehicle: VehicleDTO(key: transport.toString().replaceAll("Transport.", "")));
  }

  void setReason(String newStop) {
    var stopEnum = StopEnum.values.firstWhere((element) => element.toString() == "StopEnum." + newStop);

    stop = stop.copyWith(reason: ReasonDTO(key: stopEnum.toString().replaceAll("Transport.", "")));
  }

  void setTimeMovement(int startHour, int startMinute, int endHour, int endMinute) {
    movement = movement.copyWith(
        classifiedPeriod: movement.classifiedPeriod.copyWith(
            startDate: DateTime(date.year, date.month, date.day, startHour, startMinute),
            endDate: DateTime(date.year, date.month, date.day, endHour, endMinute)));

    periods.add(movement);

    state = Loaded(periods);
  }

  void setTimeStop(int startHour, int startMinute, int endHour, int endMinute) {
    stop = stop.copyWith(
        classifiedPeriod: stop.classifiedPeriod.copyWith(
            startDate: DateTime(date.year, date.month, date.day, startHour, startMinute),
            endDate: DateTime(date.year, date.month, date.day, endHour, endMinute)));

    periods.add(stop);

    state = Loaded(periods);
  }

  void removeClassifiedPeriod(int index) {}

  void setUserId(int id) {
    userId = id;
  }

  void setDate(DateTime dateTime) async {
    state = const Loading();
    date = dateTime;
    periods.clear();

    var response = await _classifiedPeriodApi.GetClassifiedPeriods(userId, dateTime.year, dateTime.month, dateTime.day);
    periods.addAll(response.payload!.movements);
    periods.addAll(response.payload!.stops);

    state = Loaded(periods);
  }

  void removePeriod(int index) {
    state = const Loading();

    var period = periods.removeAt(index);

    if (period.classifiedPeriod.id != null) {
      _classifiedPeriodApi.DeleteClassifiedPeriod(period.classifiedPeriod.id!);
    }

    state = Loaded(periods);
  }
}
