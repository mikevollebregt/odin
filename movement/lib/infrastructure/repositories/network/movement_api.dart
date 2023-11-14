import '../database/database.dart';
import '../dtos/parsed_response.dart';
import 'base_api.dart';

class MovementApi extends BaseApi {
  MovementApi(Database database) : super('movement/', database);

  Future<ParsedResponse<Movement?>> sync(Movement movement) async => this.getParsedResponse<Movement, Movement>(
        'upsert',
        Movement.fromJson,
        payload: movement,
      );
}
