import 'dart:math';

enum SensorType { network, cell, gps }

extension SensorTypeFromString on String {
  SensorType toSensorType() {
    final s = this;
    switch (s) {
      case 'Network':
        return SensorType.network;
      case 'cell': //TODO: implement correct label
        return SensorType.cell;
      case 'GPS':
        return SensorType.gps;
      default:
        print('Warning: cannot parse sensortype "$s", returning random sensor');
        return randomSensorType();
    }
  }
}

extension SensorTypeToString on SensorType {
  String convertToString() {
    final s = this;
    switch (s) {
      case SensorType.network:
        return 'network';
      case SensorType.cell:
        return 'cell';
      case SensorType.gps:
        return 'gps';
      default:
        return '';
    }
  }
}

SensorType randomSensorType() {
  final sensors = [SensorType.network, SensorType.gps, SensorType.cell];
  return sensors[Random().nextInt(sensors.length)];
}
