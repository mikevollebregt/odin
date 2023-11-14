import 'package:shared_preferences/shared_preferences.dart';

import '../database/database.dart';
import '../dtos/login_payload.dart';
import '../dtos/parsed_response.dart';
import '../dtos/token_dto.dart';
import '../dtos/user_dto.dart';
import 'base_api.dart';

class AuthApi extends BaseApi {
  AuthApi(Database database) : super('', database);

  Future<ParsedResponse<TokenDTO?>> login(String email, String password) async {
    final map = LoginPayload(email, password).toMap();
    final parsedResponse = await this.getParsedResponse<TokenDTO, TokenDTO>('login', TokenDTO.fromMap, payload: map);

    if (parsedResponse.payload == null) {
      return parsedResponse;
    }

    final token = Token(authToken: parsedResponse.payload!.token);
    await this.database.tokensDao.clean();
    await this.database.tokensDao.insertTokenAsync(token);
    (await SharedPreferences.getInstance()).setString('username', email);
    (await SharedPreferences.getInstance()).setInt('login_unix_timestamp', DateTime.now().millisecondsSinceEpoch);
    return parsedResponse;
  }

  Future<ParsedResponse<UserDTO?>> signup(String username, String email, String password) async {
    final map = UserDTO(username, email, password).toMap();
    return this.getParsedResponse<UserDTO, UserDTO>('signup', UserDTO.fromMap, payload: map);
  }
}
