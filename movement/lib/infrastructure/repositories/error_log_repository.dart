import 'dtos/error_log_dto.dart';
import 'network/error_log_api.dart';

class ErrorLogRepository {
  final ErrorLogApi _errorLogApi;

  ErrorLogRepository(this._errorLogApi);

  Future<List<ErrorLogDTO>> getErrorLogsAsync() async {
    final response = await _errorLogApi.getErrorLogs();
    final devices = ErrorLogDTO.fromList(response.payload!);

    return devices;
  }
}
