import '../repositories/dtos/sensor_geolocation_dto.dart';

class AccuracyClassifier {
  AccuracyClassifier();

  int getAccuracyThreshold(List<SensorGeolocationDTO> list) {
    return 30;
  }

  int getMovingThreshold(String sensor) {
    switch (sensor) {
      case "normal":
        return 3;
      case "fused":
        return 1;
      case "balanced":
        return 1;
    }

    return 0;
  }
}
