import 'package:desktop/infastructure/repositories/dtos/user_device_dto.dart';

import '../database/database.dart';
import '../dtos/parsed_response.dart';
import '../dtos/user_sensor_geolocation_data_dto.dart';
import 'base_api.dart';

class VerificationApi extends BaseApi {
  VerificationApi(Database database) : super("verificationdata/", database);

  Future<ParsedResponse<List<UserDeviceDTO>>> getUsers() async => getParsedResponse<List<UserDeviceDTO>, UserDeviceDTO>('users', UserDeviceDTO.fromMap);

  Future<ParsedResponse<UserSensorGeolocationDataDTO>> getUser(int userId) async =>
      getParsedResponse<UserSensorGeolocationDataDTO, UserSensorGeolocationDataDTO>('user/$userId', UserSensorGeolocationDataDTO.fromMap);
}
