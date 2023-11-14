import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/dtos/user_sensor_geolocation_data_dto.dart';
import '../repositories/network/testcase_api.dart';
import 'generic_notifier.dart';

class UsefulDaysUserNotifier extends StateNotifier<NotifierState> {
  final TestCaseApi _testCaseApi;

  UsefulDaysUserNotifier(this._testCaseApi) : super(const Initial()) {
    getListAsync();
  }

  Future getListAsync() async {
    state = const Loading();

    final response = await _testCaseApi.getUsefulUsersDays();

    state = Loaded<List<UserSensorGeolocationDataDTO>>(response.payload!);
  }
}
