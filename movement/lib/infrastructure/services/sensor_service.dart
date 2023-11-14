import 'dart:io';

import '../repositories/database/database.dart';
import 'foreground_service.dart';

class SensorService {
  final int batteryThreshHold = 10;
  final int normalBiasAmount = 200;
  final int fusedBiasAmount = 100;
  final int hourInMilliseconds = 3600000;
  final Database _database;
  final ForegroundService _foregroundService;

  SensorService(this._database, this._foregroundService);

  checkIfShouldChooseSensor() async {
    if (Platform.isIOS) {
      return;
    }

    var device = await _database.devicesDao.getDeviceAsync();
    if (device!.sensorLock) {
      return;
    }

    await _database.devicesDao.updateDeviceAsync(device.copyWith(sensorLock: true));

    var locations = await _database.sensorGeolocationDao.getAllSensorGeolocations();

    if (locations.isEmpty) {
      await _database.devicesDao.updateDeviceAsync(device.copyWith(sensorLock: false));
      return;
    }

    var now = DateTime.now();
    var timeDifference = now.millisecondsSinceEpoch - locations.first.createdOn.millisecondsSinceEpoch;

    if (timeDifference > hourInMilliseconds) {
      //An hour has passed, calculate what sensor is better and remove the other two.

      //is too much battery used?
      var batteryLevelStart = locations.first.batteryLevel;
      var batteryLevelEnd = locations.last.batteryLevel;
      var batteryUsed = batteryLevelStart - batteryLevelEnd;

      if (batteryUsed > batteryUsed) {
        //use the fused or balanced sensor
        await _foregroundService.useFused();
        return;
      }

      var percentageNormal = await getPercentageNormal();
      var percentageFused = await getPercentageFused();
      var percentageBalanced = await getPercentageBalanced();

      if (percentageNormal >= 100) {
        await _foregroundService.useNormal();
        return;
      }

      if (percentageFused >= 100) {
        await _foregroundService.useFused();
        return;
      }

      if (percentageBalanced >= 100) {
        await _foregroundService.useBalanced();
        return;
      }

      //We'll turn on fused. In general, it's the most reliable.
      await _foregroundService.useFused();
    } else {
      await _database.devicesDao.updateDeviceAsync(device.copyWith(sensorLock: false));
    }
  }

  Future<int> getPercentageFused() async {
    var locations = await _database.sensorGeolocationDao.findSensorGeolocations("fused");
    var percentage = locations.length / fusedBiasAmount * 100;

    return percentage.toInt();
  }

  Future<int> getPercentageBalanced() async {
    var locations = await _database.sensorGeolocationDao.findSensorGeolocations("normal");
    var percentage = locations.length / fusedBiasAmount * 100;

    return percentage.toInt();
  }

  Future<int> getPercentageNormal() async {
    var locations = await _database.sensorGeolocationDao.findSensorGeolocations("balanced");
    var percentage = locations.length / normalBiasAmount * 100;

    return percentage.toInt();
  }
}
