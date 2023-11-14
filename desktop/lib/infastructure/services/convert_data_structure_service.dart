import 'package:desktop/infastructure/repositories/dtos/sensor_geolocation_batch_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/sensor_geolocation_dto.dart';
import 'package:desktop/infastructure/repositories/network/sensor_geo_location_api.dart';

import '../repositories/dtos/location_dto.dart';
import '../repositories/dtos/tracker.dart';
import '../repositories/network/testcase_api.dart';

class ConvertDataStructureService {
  final TestCaseApi _testCaseApi;
  final SensorGeoLocationApi _sensorGeoLocationApi;

  ConvertDataStructureService(this._testCaseApi, this._sensorGeoLocationApi);

  Future syncToNewDatastructure() async {
    var response = await _testCaseApi.getUserTestCasesAsync();

    if (response.payload!.isEmpty) {
      return;
    }

    for (var userData in response.payload!) {
      var userId = userData.userId;
      var list = <SensorGeolocationDTO>[];

      for (var day in userData.userTestDaysDataDTO) {
        for (var location in day.rawdata) {
          var batteryLevel = getBatteryLevel(location, day.pings);
          list.add(mapToSensorGeolocation(location, batteryLevel));
        }
      }

      var batch = SensorGeolocationBatchDTO(userId: userId, sensorGeolocationBatch: list);

      await _sensorGeoLocationApi.syncBatchGeoLocation(batch);
    }
  }

  int getBatteryLevel(LocationDTO loc, List<Tracker> trackers) {
    for (var i = 0; i < trackers.length; i++) {
      if (trackers.length == i + 1) {
        return trackers[i].batteryLevel;
      }

      if (trackers[i].date <= loc.date) {
        return trackers[i].batteryLevel;
      }

      if (trackers[i].date >= loc.date && trackers[i + 1].date < loc.date) {
        return trackers[i + 1].batteryLevel;
      }
    }

    return 0;
  }

  SensorGeolocationDTO mapToSensorGeolocation(LocationDTO location, int batteryLevel) {
    return SensorGeolocationDTO(
        speed: location.speed,
        accuracy: location.accuracy,
        altitude: location.altitude,
        bearing: location.bearing,
        createdOn: location.date,
        lat: location.lat,
        lon: location.lon,
        batteryLevel: batteryLevel,
        sensorType: location.sensorType,
        deletedOn: null,
        density: 0,
        acceleration: 0,
        calculatedSpeed: 0,
        uuid: "");
  }
}
