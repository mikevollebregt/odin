

import 'package:desktop/infastructure/notifiers/mock_database.dart';
import 'package:desktop/infastructure/notifiers/sensor_data.dart';

class SensorDataRepository {
  final MockDatabase mockDatabase;

  SensorDataRepository(this.mockDatabase);

  Future<List<SensorData>> getPreviousSensorDataWithoutNoise({required int count}) async {
    return mockDatabase.getPreviousNonNoise(count: count);
  }

  void save(SensorData sensorData) {
    mockDatabase.save(sensorData);
  }
}
