import 'package:desktop/infastructure/repositories/dtos/processed_day_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/testcase_dto.dart';

import '../database/database.dart';
import '../dtos/parsed_response.dart';
import '../dtos/user_sensor_geolocation_data_dto.dart';
import '../dtos/user_test_data_dto.dart';
import 'base_api.dart';

class TestCaseApi extends BaseApi {
  TestCaseApi(Database database) : super("testcase/", database);

  Future<ParsedResponse<List<TestCaseDTO>>> getShallowTestCasesAsync() async =>
      getParsedResponse<List<TestCaseDTO>, TestCaseDTO>('shallow', TestCaseDTO.fromMap);

  Future<ParsedResponse<List<UserTestDataDTO>>> getUserTestCasesAsync() async =>
      getParsedResponse<List<UserTestDataDTO>, UserTestDataDTO>('users', UserTestDataDTO.fromMap);

  Future<ParsedResponse<TestCaseDTO>> getDetailTestCasesAsync(int dayId, int userId) async =>
      getParsedResponse<TestCaseDTO, TestCaseDTO>("details/$dayId/$userId", TestCaseDTO.fromMap);

  Future<ParsedResponse<List<UserSensorGeolocationDataDTO>>> getUserSensorGeolocationData() async =>
      getParsedResponse<List<UserSensorGeolocationDataDTO>, UserSensorGeolocationDataDTO>('GetUserSensorGeolocationData', UserSensorGeolocationDataDTO.fromMap);

  Future<ParsedResponse<UserSensorGeolocationDataDTO>> getUserSensorGeolocationDayData(String userId) async =>
      getParsedResponse<UserSensorGeolocationDataDTO, UserSensorGeolocationDataDTO>(
          'GetUserSensorGeolocationDayData/$userId', UserSensorGeolocationDataDTO.fromMap);

  Future<ParsedResponse<List<UserSensorGeolocationDataDTO>>> getUsefulUsersDays() async =>
      getParsedResponse<List<UserSensorGeolocationDataDTO>, UserSensorGeolocationDataDTO>('GetUsefulUsersDays', UserSensorGeolocationDataDTO.fromMap);

  Future<ParsedResponse<ProcessedDayDTO>> getUsefulDays(int userDaySensorCountViewsId) async =>
      getParsedResponse<ProcessedDayDTO, ProcessedDayDTO>('GetUsefulDays/$userDaySensorCountViewsId', ProcessedDayDTO.fromMap);
}
