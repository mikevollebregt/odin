import 'dart:math';

import 'package:desktop/infastructure/notifiers/testcase_detail_notifier.dart';
import 'package:desktop/infastructure/repositories/dtos/user_sensor_geolocation_data_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/dtos/sensor_geolocation_dto.dart';
import '../repositories/network/auth_api.dart';
import '../repositories/network/testcase_api.dart';
import '../services/convert_data_structure_service.dart';
import 'generic_notifier.dart';

class TestCaseListDetailNotifier extends StateNotifier<NotifierState> {
  final TestCaseApi _testCaseApi;
  final TestCaseDetailNotifier _notifier;
  final AuthApi _authApi;
  final ConvertDataStructureService _convertDataStructureService;

  TestCaseListDetailNotifier(this._testCaseApi, this._notifier, this._authApi, this._convertDataStructureService) : super(const Initial());

  Future getDetail(String userId) async {
    state = const Loading();

    var userTestDaysDataDTO = await _testCaseApi.getUserSensorGeolocationDayData(userId);

    for (var day in userTestDaysDataDTO.payload!.userTestDaysDataDTO!) {
      if (day.testRawdata[0].isNotEmpty) {
        day.testRawdata[0].removeWhere((element) => element.accuracy > 30);

        for (var i = 1; i < day.testRawdata[0].length; i++) {
          var distance = _calculateDistance(day.testRawdata[0][i - 1].lat, day.testRawdata[0][i - 1].lon, day.testRawdata[0][i].lat, day.testRawdata[0][i].lon);
          day.testRawdata[0][i].calculatedSpeed = _calculateSpeed(day.testRawdata[0][i - 1].createdOn, day.testRawdata[0][i].createdOn, distance);

          if (i < 3) {
            continue;
          }

          var timeDifferenceInSeconds = (day.testRawdata[0][i].createdOn - day.testRawdata[0][i - 3].createdOn) / 1000 / 60;
          var density = distance * timeDifferenceInSeconds;

          day.testRawdata[0][i].density = density > 40 ? -1 : density;
        }
      }

      if (day.testRawdata[1].isNotEmpty) {
        day.testRawdata[1].removeWhere((element) => element.accuracy > 30);

        for (var i = 1; i < day.testRawdata[1].length; i++) {
          var distance = _calculateDistance(day.testRawdata[1][i - 1].lat, day.testRawdata[1][i - 1].lon, day.testRawdata[1][i].lat, day.testRawdata[1][i].lon);
          day.testRawdata[1][i].calculatedSpeed = _calculateSpeed(day.testRawdata[1][i - 1].createdOn, day.testRawdata[1][i].createdOn, distance);

          if (i < 3) {
            continue;
          }

          var timeDifferenceInSeconds = (day.testRawdata[1][i].createdOn - day.testRawdata[1][i - 3].createdOn) / 1000 / 60;
          var density = distance * timeDifferenceInSeconds;

          day.testRawdata[1][i].density = density > 40 ? -1 : density;
        }
      }

      if (day.testRawdata[2].isNotEmpty) {
        day.testRawdata[2].removeWhere((element) => element.accuracy > 30);

        for (var i = 1; i < day.testRawdata[2].length; i++) {
          var distance = _calculateDistance(day.testRawdata[2][i - 1].lat, day.testRawdata[2][i - 1].lon, day.testRawdata[2][i].lat, day.testRawdata[2][i].lon);
          day.testRawdata[2][i].calculatedSpeed = _calculateSpeed(day.testRawdata[2][i - 1].createdOn, day.testRawdata[2][i].createdOn, distance);

          if (i < 3) {
            continue;
          }

          var timeDifferenceInSeconds = (day.testRawdata[2][i].createdOn - day.testRawdata[2][i - 3].createdOn) / 1000 / 60;
          var density = distance * timeDifferenceInSeconds;

          day.testRawdata[2][i].density = density > 40 ? -1 : density;
        }
      }

      if (day.testRawdata[0].isNotEmpty && day.testRawdata[1].isNotEmpty && day.testRawdata[2].isNotEmpty) {
        var as1 = day.testRawdata[0].map((m) => m.speed).reduce((a, b) => a + b) / day.testRawdata[0].length;
        var as2 = day.testRawdata[1].map((m) => m.speed).reduce((a, b) => a + b) / day.testRawdata[1].length;
        var as3 = day.testRawdata[2].map((m) => m.speed).reduce((a, b) => a + b) / day.testRawdata[2].length;

        var i = 0;
      }

      day.testRawdata[1].removeWhere((element) => element.calculatedSpeed > 150);
      day.testRawdata[1].removeWhere((element) => element.calculatedSpeed < 0);

      var i = 0;
    }

    state = Loaded<UserSensorGeolocationDataDTO>(userTestDaysDataDTO.payload!);
  }

  double _calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;

    return 12742 * asin(sqrt(a)) * 1000;
  }

  double _calculateSpeed(int startTime, int endTime, double distance) {
    var startDate = DateTime.fromMillisecondsSinceEpoch(startTime);
    var endDate = DateTime.fromMillisecondsSinceEpoch(endTime);

    var timeDifferenceInSeconds = (endTime - startTime) / 1000;
    var speed = distance / timeDifferenceInSeconds;

    return speed.isNaN ? 0 : speed * 3.6;
  }

  double _calculateDensity() {
    return 0.0;
  }

  double _calculateAverageDensity(List<SensorGeolocationDTO> locations) {
    var itemsInHour = locations.sublist(0, 100);
    var densityList = <double>[];
    var densityAverage = 0.0;

    for (var i = 3; i < itemsInHour.length; i++) {
      var distance = _calculateDistance(locations[i - 3].lat, locations[i - 3].lon, locations[i].lat, locations[i].lon);
      var timeDifferenceInSeconds = (locations[i].createdOn - locations[i - 3].createdOn) / 1000 / 60;
      var density = distance * timeDifferenceInSeconds;
      densityList.add(density);
    }

    densityAverage = densityList.reduce((a, b) => a + b) / densityList.length;

    return densityAverage;
  }
}
