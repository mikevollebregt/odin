import '../database/database.dart';
import '../dtos/parsed_response.dart';
import 'base_api.dart';

class ErrorLogApi extends BaseApi {
  ErrorLogApi(Database database) : super('', database);

  Future<ParsedResponse<List<Map<String, String>>>> getErrorLogs() async {
    //TODO: implement getErrorLogsAsync
    throw UnimplementedError();
  }
}
