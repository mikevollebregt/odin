
import '../database/database.dart';
import '../dtos/parsed_response.dart';
import '../dtos/pdok_response_dto.dart';
import 'base_api.dart';

class PDOKApi extends BaseApi {
  PDOKApi(Database database) : super("pdokapi/", database);

  Future<ParsedResponse<PDOKResponseDTO>> getPointsOfInterest(double lat, double lon, int distance) async =>
      getParsedResponse<PDOKResponseDTO, PDOKResponseDTO>('getPointsOfInterest/$lat/$lon/$distance', PDOKResponseDTO.fromMap);
}
