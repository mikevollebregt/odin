import 'package:desktop/infastructure/notifiers/testcase_raw_detail_notifier.dart';
import 'package:desktop/infastructure/notifiers/tom_algo_notifier.dart';
import 'package:desktop/infastructure/repositories/network/testcase_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/dtos/user_test_day_data_dto.dart';
import 'generic_notifier.dart';

class TestCaseDetailNotifier extends StateNotifier<NotifierState> {
  final TestCaseApi _testCaseApi;
  final TestCaseRawDetailNotifier _testCaseRawDetailNotifier;
  //final TestCaseAlgoDetailNotifier _testCaseAlgoDetailNotifier;
  final TestCaseTomAlgoDetailNotifier _testCaseTomAlgoDetailNotifier;

  TestCaseDetailNotifier(this._testCaseApi, this._testCaseRawDetailNotifier, this._testCaseTomAlgoDetailNotifier) : super(const Initial());

  Future getDetailAsync(UserTestDayDataDTO details) async {
    state = const Loading();

    await Future.wait([
      // _testCaseAlgoDetailNotifier.showOnMapAsync(details),
      _testCaseRawDetailNotifier.showOnMapAsync(details),
      _testCaseTomAlgoDetailNotifier.showOnMapAsync(details)
    ]);

    state = const Loaded<bool>(true);
  }
}
