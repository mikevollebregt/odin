import 'package:desktop/infastructure/notifiers/sensor_type.dart';
import 'package:desktop/infastructure/repositories/dtos/tracked_movement_dto.dart';
import 'package:latlong2/latlong.dart';

import '../repositories/dtos/location_dto.dart';
import '../repositories/dtos/tracked_location_dto.dart';

class SensorData {
  late DateTime datetime;
  late LatLng location;
  late SensorType sensorType;
  late double accuracy;
  late double altitude;
  late double speed;
  late double bearing;

  // Validated data
  late bool isValidated;
  late bool isValidatedStop;

  // Classification results
  bool? isTooQuick;
  bool? isFirstSensorData;
  bool? isNoise;
  bool? isClassifiedStop;
  double? distance;

  SensorData.fromJson(Map<String, dynamic> map) {
    datetime = DateTime.fromMillisecondsSinceEpoch(map['Date'], isUtc: true);
    final double _lat = map['Lat'];
    final double _lon = map['Lon'];
    location = LatLng(_lat, _lon);
    sensorType = (map['SensorType'] as String).toSensorType();
    accuracy = double.parse(map['Accuracy'].toString()); //TODO: improve this parsing
    altitude = double.parse(map['Altitude'].toString());
    speed = double.parse(map['Speed'].toString());
    bearing = double.parse(map['Bearing'].toString());
  }

  SensorData.fromLocationDTO(LocationDTO locationDTO) {
    datetime = DateTime.fromMillisecondsSinceEpoch(locationDTO.date);
    final double _lat = locationDTO.lat;
    final double _lon = locationDTO.lon;
    location = LatLng(_lat, _lon);
    sensorType = locationDTO.sensorType.toSensorType();
    accuracy = locationDTO.accuracy;
    altitude = locationDTO.altitude;
    speed = locationDTO.speed;
    bearing = locationDTO.bearing;
  }

  TrackedMovementDTO toTrackedMovement() {
    return TrackedMovementDTO(
      
    );
  }

  TrackedLocationDTO toTrackedLocationDTO() {
    return TrackedLocationDTO();
  }

  // Helper method for writing results to csv file
  static List<dynamic> getListHeader() {
    return ['datetime', 'latitude', 'longitude', 'sensorType', 'accuracy', 'altitude', 'speed', 'bearing', 'isTooQuick', 'isFirstNonNoiseSensorData', 'isNoise', 'isClassifiedStop', 'distance'];
  }

  // Helper method for writing results to csv file
  List<dynamic> toList() {
    return [
      datetime,
      location.latitude,
      location.longitude,
      sensorType.convertToString(),
      accuracy,
      altitude,
      speed,
      bearing,
      isTooQuick ?? '',
      isFirstSensorData ?? '',
      isNoise ?? '',
      isClassifiedStop ?? '',
      distance ?? ''
    ];
  }
}
