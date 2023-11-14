import '../database/database.dart';
import '../dtos/log_dto.dart';
import '../dtos/parsed_response.dart';
import 'base_api.dart';

class LogApi extends BaseApi {
  LogApi(Database database) : super('logs', database);

  Future<ParsedResponse?> getLogs() async {
    // TODO: implement getLogs
    throw UnimplementedError();
  }

  Future<ParsedResponse<LogDTO?>> postLog(LogDTO logDTO) async => this.getParsedResponse<LogDTO, LogDTO>('', LogDTO.fromMap);

  Future<ParsedResponse<List<LogDTO>?>> postLogs(List<LogDTO> logs) async =>
      this.getParsedResponse<List<LogDTO>, LogDTO>('', LogDTO.fromMap, payload: LogDTO.toList(logs));
}
