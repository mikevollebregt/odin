import 'dart:math';

import 'package:desktop/infastructure/repositories/dtos/processed_day_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/network/testcase_api.dart';
import 'generic_notifier.dart';

class UsefulDaysNotifier extends StateNotifier<NotifierState> {
  final TestCaseApi _testCaseApi;

  UsefulDaysNotifier(this._testCaseApi) : super(const Initial());

  Future getDaysAsync(int userDaySensorCountViewsId) async {
    state = const Loading();

    final response = await _testCaseApi.getUsefulDays(userDaySensorCountViewsId);

    if (response.payload!.normalSensorGeolocations.isNotEmpty) {
      //response.payload!.normalSensorGeolocations.removeWhere((element) => element.accuracy > 30);

      for (var i = 1; i < response.payload!.normalSensorGeolocations.length; i++) {
        var distance = _calculateDistance(response.payload!.normalSensorGeolocations[i - 1].lat, response.payload!.normalSensorGeolocations[i - 1].lon,
            response.payload!.normalSensorGeolocations[i].lat, response.payload!.normalSensorGeolocations[i].lon);

        var calculatedSpeed =
            _calculateSpeed(response.payload!.normalSensorGeolocations[i - 1].createdOn, response.payload!.normalSensorGeolocations[i].createdOn, distance);

        calculatedSpeed = calculatedSpeed.isInfinite ? 5 : calculatedSpeed;

        response.payload!.normalSensorGeolocations[i].calculatedSpeed = response.payload!.normalSensorGeolocations[i].accuracy < 20 ? calculatedSpeed : 5;

        var previousLocationSpeed = response.payload!.normalSensorGeolocations[i - 1].calculatedSpeed.isNaN ||
                response.payload!.normalSensorGeolocations[i - 1].calculatedSpeed.isInfinite
            ? 0
            : response.payload!.normalSensorGeolocations[i - 1].calculatedSpeed.toInt();

        var currentLocationSpeed =
            response.payload!.normalSensorGeolocations[i].calculatedSpeed.isNaN || response.payload!.normalSensorGeolocations[i].calculatedSpeed.isInfinite
                ? 0
                : response.payload!.normalSensorGeolocations[i].calculatedSpeed.toInt();

        var timePassed = (response.payload!.normalSensorGeolocations[i].createdOn - response.payload!.normalSensorGeolocations[i - 1].createdOn) * 0.001;

        response.payload!.normalSensorGeolocations[i].acceleration = currentLocationSpeed - previousLocationSpeed / timePassed;

        if (i < 3) {
          continue;
        }

        var timeDifferenceInSeconds =
            (response.payload!.normalSensorGeolocations[i].createdOn - response.payload!.normalSensorGeolocations[i - 3].createdOn) / 1000 / 60;
        var density = distance * timeDifferenceInSeconds;

        response.payload!.normalSensorGeolocations[i].density = density > 40 ? -1 : density;
      }
    }

    // if (day.testRawdata[0].isNotEmpty && day.testRawdata[1].isNotEmpty && day.testRawdata[2].isNotEmpty) {
    //   var as1 = day.testRawdata[0].map((m) => m.speed).reduce((a, b) => a + b) / day.testRawdata[0].length;
    //   var as2 = day.testRawdata[1].map((m) => m.speed).reduce((a, b) => a + b) / day.testRawdata[1].length;
    //   var as3 = day.testRawdata[2].map((m) => m.speed).reduce((a, b) => a + b) / day.testRawdata[2].length;

    //   var i = 0;
    // }

    // day.testRawdata[1].removeWhere((element) => element.calculatedSpeed > 150);
    // day.testRawdata[1].removeWhere((element) => element.calculatedSpeed < 0);

    // var i = 0;

    state = Loaded<ProcessedDayDTO>(response.payload!);
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
}
