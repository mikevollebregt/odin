import 'package:desktop/infastructure/notifiers/noise_classifier.dart';
import 'package:desktop/infastructure/notifiers/sensor_data.dart';
import 'package:desktop/infastructure/notifiers/sensor_data_repository.dart';
import 'package:desktop/infastructure/notifiers/stop_classifier.dart';

const minTimeTresholdInSeconds = 240;
const minSamplesPerSecond = 5; //TODO: ask Mike what this number should be

class ClassificationNotifier {
  SensorDataRepository sensorDataRepository;

  late SensorData _newData;
  late List<SensorData> _previousSensorDataWithoutNoise;
  late SensorData? _referenceSensorData;

  ClassificationNotifier(this.sensorDataRepository);

  Future<void> classify(SensorData sensorData) async {
    await _loadData(sensorData);
    if (_shouldDoStopClassifcation()) {
      sensorData.isClassifiedStop = _isStop();
    } else {
      if ( _isFirstSensorData() == false) StopClassifier.setDistance(_newData, _referenceSensorData!);
    }
    sensorDataRepository.save(sensorData);
  }

  Future<void> _loadData(SensorData sensorData) async {
    _newData = sensorData;
    _previousSensorDataWithoutNoise = await sensorDataRepository.getPreviousSensorDataWithoutNoise(count: minTimeTresholdInSeconds * minSamplesPerSecond);
    _referenceSensorData = _getReferenceSensorData();
  }

  SensorData? _getReferenceSensorData() {
    if (_previousSensorDataWithoutNoise.isEmpty) return null;
    for (final sensorData in _previousSensorDataWithoutNoise.reversed) {
      if (sensorData.isClassifiedStop != null) return sensorData;
    }
    return _previousSensorDataWithoutNoise[0];
  }

  bool _shouldDoStopClassifcation() {
    // TODO: if too quick then don't check isNoise?
    final isFirstSensorData = _isFirstSensorData();
    final isTooQuick = _isTooQuick();
    final isNoise = _isNoise();
    _newData.isFirstSensorData = isFirstSensorData;
    _newData.isTooQuick = isTooQuick;
    _newData.isNoise = isNoise;
    return isNoise == false && isTooQuick == false && isFirstSensorData == false;
  }

  bool _isFirstSensorData() {
    return _previousSensorDataWithoutNoise.isEmpty;
  }

  bool _isTooQuick() {
    if (_previousSensorDataWithoutNoise.isEmpty) return false;
    int timeSinceReferenceInSeconds = _newData.datetime.difference(_referenceSensorData!.datetime).inSeconds;
    return timeSinceReferenceInSeconds <= minTimeTresholdInSeconds;
  }

  bool _isNoise() {
    return NoiseClassifier.isNoise(_newData);
  }

  bool _isStop() {
    return StopClassifier.isStop(_newData, _referenceSensorData!);
  }
}
