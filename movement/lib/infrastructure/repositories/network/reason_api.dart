import '../database/database.dart';
import '../dtos/parsed_response.dart';
import '../dtos/reason_dto.dart';
import 'base_api.dart';

class ReasonApi extends BaseApi {
  ReasonApi(Database database) : super('reasons', database);

  Future<ParsedResponse<List<ReasonDTO>?>> getReasons() async => this.getParsedResponse<List<ReasonDTO>, ReasonDTO>('', ReasonDTO.fromMap);
}
