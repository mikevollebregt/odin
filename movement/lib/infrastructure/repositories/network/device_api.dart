import '../database/database.dart';
import '../dtos/device_dto.dart';
import '../dtos/parsed_response.dart';
import 'base_api.dart';

class DeviceApi extends BaseApi {
  DeviceApi(Database database) : super('device', database);

  Future<ParsedResponse<List<DeviceDTO>?>> getDevices() async {
    // TODO: implement getDevices
    throw UnimplementedError();
  }

  Future<ParsedResponse<DeviceDTO?>> insertDevice(DeviceDTO deviceDTO) async =>
      this.getParsedResponse<DeviceDTO, DeviceDTO>('', DeviceDTO.fromMap, payload: deviceDTO.toJson());
}
