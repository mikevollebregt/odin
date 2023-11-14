import '../database/database.dart';
import '../dtos/parsed_response.dart';
import 'base_api.dart';

class StopApi extends BaseApi {
  StopApi(Database database) : super('stop/', database);

  Future<ParsedResponse<Stop?>> sync(Stop stop) async => this.getParsedResponse<Stop, Stop>(
        'upsert',
        Stop.fromJson,
        payload: stop,
      );
}
