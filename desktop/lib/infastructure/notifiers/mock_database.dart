import 'dart:io';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:desktop/infastructure/notifiers/sensor_data.dart';

class MockDatabase {
  final List<SensorData> _cachedNonNoiseData = [];
  final List<SensorData> _cachedFullData = [];

  Future<List<SensorData>> getPreviousNonNoise({required int count}) async {
    if (_cachedNonNoiseData.isEmpty) return [];
    if (_cachedNonNoiseData.length == 1) return [_cachedNonNoiseData.last];
    final lastIndex = _cachedNonNoiseData.length;
    final startIndex = max(0, (lastIndex - count));
    return _cachedNonNoiseData.sublist(startIndex, lastIndex);
  }

  void save(SensorData sensorData) {
    _cachedFullData.add(sensorData);
    if (sensorData.isNoise == false) _cachedNonNoiseData.add(sensorData);
  }

  void writeResultsToCsv() {
    final fields = <List<dynamic>>[];
    fields.add(SensorData.getListHeader());
    for (final sensorData in _cachedFullData) {
      fields.add(sensorData.toList());
    }
    String csv = const ListToCsvConverter().convert(fields);
    final file = File('/Users/tom/work/movement project/apps/movement_algo/assets/results.csv');
    file.writeAsString(csv);
  }

  List<SensorData> getResults() {
    return _cachedNonNoiseData;
  }
}
