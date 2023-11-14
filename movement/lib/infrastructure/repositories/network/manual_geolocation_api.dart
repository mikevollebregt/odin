import '../database/database.dart';
import '../dtos/parsed_response.dart';
import 'base_api.dart';

class ManualGeolocationApi extends BaseApi {
  ManualGeolocationApi(Database database) : super('manualGeolocation/', database);

  Future<ParsedResponse<ManualGeolocation?>> sync(ManualGeolocation manualGeolocation) async => this.getParsedResponse<ManualGeolocation, ManualGeolocation>(
        'upsert',
        ManualGeolocation.fromJson,
        payload: manualGeolocation,
      );
}
