import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

import '../database/database.dart';
import 'classified_period_dto.dart';

class MovementDto extends ClassifiedPeriodDto with EquatableMixin {
  final String movementUuid;
  final Vehicle? vehicle;

  bool get isComplete => vehicle != null;

  @override
  List<Object> get props => [movementUuid];

  List<LatLng> get route {
    if (manualGeolocations.isEmpty) return sensorGeolocations.map((s) => LatLng(s.latitude, s.longitude)).toList();
    final _route = manualGeolocations.map((m) => LatLng(m.latitude, m.longitude)).toList();
    for (final sensorLocation in sensorGeolocations) {
      if (sensorLocation.createdOn.isAfter(manualGeolocations.last.createdOn)) {
        _route.add(LatLng(sensorLocation.latitude, sensorLocation.longitude));
      }
    }
    return _route;
  }

  MovementDto({
    required this.movementUuid,
    required this.vehicle,
    required ClassifiedPeriod classifiedPeriod,
    required List<ManualGeolocation> manualGeolocations,
    required List<SensorGeolocation> sensorGeolocations,
  }) : super(
          classifiedPeriod: classifiedPeriod,
          manualGeolocations: manualGeolocations,
          sensorGeolocations: sensorGeolocations,
        );

  MovementDto.userCreate(DateTime startDate, DateTime endDate, String trackedDayUuid)
      : movementUuid = Uuid().v4(),
        vehicle = null,
        super(
          classifiedPeriod: ClassifiedPeriod(
            uuid: 'user_insert',
            trackedDayUuid: trackedDayUuid,
            startDate: startDate,
            endDate: endDate,
            confirmed: false,
            createdOn: DateTime.now(),
            synced: false,
          ),
          manualGeolocations: [],
          sensorGeolocations: [],
        );

  MovementDto copyWith({
    String? movementUuid,
    Vehicle? vehicle,
    ClassifiedPeriod? classifiedPeriod,
    List<ManualGeolocation>? manualGeolocations,
    List<SensorGeolocation>? sensorGeolocations,
  }) =>
      MovementDto(
        movementUuid: movementUuid ?? this.movementUuid,
        vehicle: vehicle ?? this.vehicle,
        classifiedPeriod: classifiedPeriod ?? this.classifiedPeriod,
        manualGeolocations: manualGeolocations ?? this.manualGeolocations,
        sensorGeolocations: sensorGeolocations ?? this.sensorGeolocations,
      );
}
