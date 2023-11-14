
import '../database/database.dart';
import '../dtos/google_place_dto.dart';
import '../dtos/parsed_response.dart';
import 'base_api.dart';

class GoogleApi extends BaseApi {
  GoogleApi(Database database) : super("googlesearch/", database);

  Future<ParsedResponse<GooglePlaceDTO>> getPlaceDetails(double lat, double lon) async =>
      getParsedResponse<GooglePlaceDTO, GooglePlaceDTO>('place/$lat/$lon', GooglePlaceDTO.fromMap);

  Future<ParsedResponse<GooglePlaceDTO>> getPlaceRadiusDetails(double lat, double lon) async =>
      getParsedResponse<GooglePlaceDTO, GooglePlaceDTO>('radius/$lat/$lon', GooglePlaceDTO.fromMap);
}
