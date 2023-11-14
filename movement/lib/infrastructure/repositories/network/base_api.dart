import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../database/database.dart';
import '../dtos/parsed_response.dart';

// const serverSocketAddress = 'http://188.166.119.164:8000';
// const serverSocketAddress = 'http://137.184.133.174:8000'; // OLD
//const serverSocketAddress = 'http://192.168.178.33:8000'; // Local Mike
// const serverSocketAddress = 'http://192.168.1.202:8000'; // Local Tim
// const serverSocketAddress = 'http://192.168.1.7:8000'; // Local Tom
const serverSocketAddress = 'https://odin-api.test.cbs.nl'; // CF backend
var bearerToken = 'Bearer';

class BaseApi {
  final String _path;
  final Database database;

  BaseApi(this._path, this.database);

  Future<ParsedResponse<R>> getParsedResponse<R, T>(String route, T Function(Map<String, dynamic>) responseParser, {dynamic payload}) async {
    final response = await _getResponse<R, T>(route, responseParser, body: payload);
    return response;
  }

  Future<ParsedResponse<R>> _getResponse<R, T>(String route, T Function(Map<String, dynamic>) responseParser, {dynamic body}) async {
    final authHeader = await _getAutHeader();
    final uri = Uri.parse('$serverSocketAddress/api/${this._path}$route');

    late http.Response response;

    try {
      if (_isHttpGet(body)) {
        response = await http.get(uri, headers: {'Content-Type': 'application/json', HttpHeaders.authorizationHeader: authHeader});
      } else {
        response = await http.post(uri, body: jsonEncode(body), headers: {'Content-Type': 'application/json', HttpHeaders.authorizationHeader: authHeader});
      }

      if (_isOk(response)) {
        final deserializedResponse = json.decode(response.body) as Map<String, dynamic>;
        final dynamic serializedPayload = json.decode(deserializedResponse['Body'] as String);

        dynamic payload;

        if (serializedPayload is Map) {
          payload = responseParser(serializedPayload as Map<String, dynamic>);
        }

        if (serializedPayload is Iterable) {
          if (R is Map) {
            throw Exception('Wrong casting in parsedResponse function');
          }

          final payloadList = <T>[];
          for (final serializedPayloadItem in serializedPayload) {
            payloadList.add(responseParser(serializedPayloadItem as Map<String, dynamic>));
          }
          payload = payloadList;
        }

        final parsedResponse = ParsedResponse<R>(
            statusCode: response.statusCode,
            debugMessages: deserializedResponse['DebugMessages'] == null ? '' : deserializedResponse['DebugMessages'] as String,
            errorMessages: deserializedResponse['ErrorMessages'] == null ? '' : deserializedResponse['ErrorMessages'] as String,
            infoMessages: deserializedResponse['InfoMessages'] == null ? '' : deserializedResponse['InfoMessages'] as String,
            payload: payload as R);

        return parsedResponse;
      }

      if (response.statusCode == 401) {
        final deserializedResponse = json.decode(response.body) as Map<String, dynamic>;
        final deserializedBody = json.decode(deserializedResponse['Body'].toString()) as Map<String, dynamic>;

        final parsedResponse = ParsedResponse<R>(
            statusCode: response.statusCode,
            debugMessages: deserializedBody['DebugMessages'] == null ? '' : deserializedBody['DebugMessages'] as String,
            errorMessages: deserializedBody['ErrorMessages'] == null ? '' : deserializedBody['ErrorMessages'] as String,
            infoMessages: deserializedBody['InfoMessages'] == null ? '' : deserializedBody['InfoMessages'] as String,
            payload: null);
        return parsedResponse;
      }
    } on Exception catch (e) {
      print(e);
    }

    return ParsedResponse(statusCode: 500, errorMessages: '', debugMessages: '', infoMessages: '', payload: null);
  }

  Future<String> _getAutHeader() async {
    final token = await database.tokensDao.getTokenAsync();
    if (_bearerTokenExists(token)) {
      bearerToken = 'Bearer ${token!.authToken}';
      return 'Bearer ${token.authToken}';
    } else {
      return 'Bearer ';
    }
  }

  bool _bearerTokenExists(Token? token) => token?.authToken != null;

  bool _isHttpGet(dynamic body) => body == null;

  bool _isOk(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) return false;
    return true;
  }
}
