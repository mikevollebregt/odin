import 'package:desktop/infastructure/notifiers/sensor_data.dart';
import 'package:latlong2/latlong.dart';

const int distanceTreshhold = 100;

class StopClassifier {
  static bool isStop(SensorData newSensorData, SensorData referenceSensorData) {
    // TODO: should maybe use distance from stop centroid?
    double distanceInMeters =
        const Distance()(newSensorData.location, referenceSensorData.location);
    newSensorData.distance = distanceInMeters; //TODO: remove this
    return distanceInMeters <= distanceTreshhold;
  }

  //TODO: remove this, it is only used for debugging
  static void setDistance(
      SensorData newSensorData, SensorData referenceSensorData) {
    double distanceInMeters =
        const Distance()(newSensorData.location, referenceSensorData.location);
    newSensorData.distance = distanceInMeters;
  }
}
