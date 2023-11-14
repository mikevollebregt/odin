import 'package:desktop/infastructure/repositories/dtos/sensor_geolocation_dto.dart';

import '../database/database.dart';

class ClassifiedPeriodDto {
  final ClassifiedPeriod classifiedPeriod;
  final List<ManualGeolocation> manualGeolocations;
  final List<SensorGeolocationDTO> sensorGeolocations;

  ClassifiedPeriodDto({
    required this.classifiedPeriod,
    required this.manualGeolocations,
    required this.sensorGeolocations,
  });

  factory ClassifiedPeriodDto.fromMap(Map<String, dynamic> json) => ClassifiedPeriodDto(
      classifiedPeriod:
          ClassifiedPeriod(startDate: DateTime.now(), endDate: DateTime.now(), confirmed: true, createdOn: DateTime.now(), synced: true, type: 0, userId: 0),
      manualGeolocations: [],
      sensorGeolocations: []);
}
