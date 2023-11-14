import '../database/database.dart';
import '../dtos/parsed_response.dart';
import '../dtos/vehicle_dto.dart';
import 'base_api.dart';

class VehicleApi extends BaseApi {
  VehicleApi(Database database) : super('transports', database);

  Future<ParsedResponse<List<VehicleDTO>?>> getVehicleDtos() async => this.getParsedResponse<List<VehicleDTO>, VehicleDTO>('', VehicleDTO.fromMap);
}
