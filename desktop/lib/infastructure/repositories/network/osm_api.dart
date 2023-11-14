import '../database/database.dart';
import '../dtos/osm_coordinates_dto.dart';
import '../dtos/parsed_response.dart';
import 'base_api.dart';

class OSMApi extends BaseApi {
  OSMApi(Database database) : super("osmDataSource/", database);

  Future<ParsedResponse<OSMCoordinatesDTO>> getTrainInfastructure() async =>
      getParsedResponse<OSMCoordinatesDTO, OSMCoordinatesDTO>('GetTrainInfastructure', OSMCoordinatesDTO.fromMap);

  Future<ParsedResponse<OSMCoordinatesDTO>> getTramInfastructure() async =>
      getParsedResponse<OSMCoordinatesDTO, OSMCoordinatesDTO>('GetTramInfastructure', OSMCoordinatesDTO.fromMap);

  Future<ParsedResponse<OSMCoordinatesDTO>> getSubwayInfastructure() async =>
      getParsedResponse<OSMCoordinatesDTO, OSMCoordinatesDTO>('GetSubwayInfastructure', OSMCoordinatesDTO.fromMap);

  Future<ParsedResponse<OSMCoordinatesDTO>> getCarInfastructure() async =>
      getParsedResponse<OSMCoordinatesDTO, OSMCoordinatesDTO>('GetCarInfastructure', OSMCoordinatesDTO.fromMap);

  Future<ParsedResponse<OSMCoordinatesDTO>> getBicycleInfastructure() async =>
      getParsedResponse<OSMCoordinatesDTO, OSMCoordinatesDTO>('GetBicycleInfastructure', OSMCoordinatesDTO.fromMap);

  Future<ParsedResponse<OSMCoordinatesDTO>> getBusInfastructure() async =>
      getParsedResponse<OSMCoordinatesDTO, OSMCoordinatesDTO>('GetBusInfastructure', OSMCoordinatesDTO.fromMap);

  Future<ParsedResponse<OSMCoordinatesDTO>> getWalkingInfastructure() async =>
      getParsedResponse<OSMCoordinatesDTO, OSMCoordinatesDTO>('GetWalkingInfastructure', OSMCoordinatesDTO.fromMap);
}
