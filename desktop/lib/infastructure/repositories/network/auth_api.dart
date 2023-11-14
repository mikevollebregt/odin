import '../database/database.dart';
import '../dtos/parsed_response.dart';
import '../dtos/user_dto.dart';
import 'base_api.dart';

class AuthApi extends BaseApi {
  AuthApi(Database database) : super('', database);

  Future<ParsedResponse<UserDTO?>> signup(String username, String email, String password) async {
    final map = UserDTO(username, email, password).toMap();
    return getParsedResponse<UserDTO, UserDTO>('signup', UserDTO.fromJson, payload: map);
  }
}
