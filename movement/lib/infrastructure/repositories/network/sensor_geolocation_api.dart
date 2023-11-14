import '../database/database.dart';
import '../dtos/parsed_response.dart';
import 'base_api.dart';

class SensorGeolocationApi extends BaseApi {
  SensorGeolocationApi(Database database) : super('sensorGeolocation/', database);

  Future<ParsedResponse<List<SensorGeolocation>>> syncSensorGeolocation(List<SensorGeolocation> sensorGeolocations) async {
    final payload = sensorGeolocations.map((sensorGeolocation) => sensorGeolocation.toJson()).toList();
    return this.getParsedResponse<List<SensorGeolocation>, SensorGeolocation>(
      'bulkInsert',
      SensorGeolocation.fromJson,
      payload: payload,
    );
  }
}
