import '../database/database.dart';

class ClassifiedPeriodDto {
  ClassifiedPeriod classifiedPeriod;
  final List<ManualGeolocation> manualGeolocations;
  final List<SensorGeolocation> sensorGeolocations;

  ClassifiedPeriodDto({
    required this.classifiedPeriod,
    required this.manualGeolocations,
    required this.sensorGeolocations,
  });
}
