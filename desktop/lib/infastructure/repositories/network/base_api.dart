import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../database/database.dart';
import '../dtos/parsed_response.dart';

//const serverSocketAddress = 'http://188.166.119.164:8000'; // Remote droplet
const serverSocketAddress = 'http://192.168.178.11:45455'; // Local Mike
//const serverSocketAddress = 'http://192.168.1.202:8000'; // Local Tim

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
    final uri = Uri.parse('$serverSocketAddress/api/$_path$route');

    late http.Response response;

    if (_isHttpGet(body)) {
      response = await http.get(uri, headers: {'Content-Type': 'application/json', HttpHeaders.authorizationHeader: authHeader});
    } else {
      response = await http.post(uri, body: jsonEncode(body), headers: {'Content-Type': 'application/json', HttpHeaders.authorizationHeader: authHeader});
    }

    if (_isOk(response)) {
      final dynamic deserializedResponse = json.decode(response.body)["response"];

      dynamic payload;

      if (deserializedResponse is Map) {
        payload = responseParser(deserializedResponse as Map<String, dynamic>);
      }

      if (deserializedResponse is Iterable) {
        if (R is Map) {
          throw Exception('Wrong casting in parsedResponse function');
        }

        final payloadList = <T>[];
        for (final serializedPayloadItem in deserializedResponse) {
          payloadList.add(responseParser(serializedPayloadItem as Map<String, dynamic>));
        }
        payload = payloadList;
      }

      final parsedResponse = ParsedResponse<R>(statusCode: response.statusCode, debugMessages: '', errorMessages: '', infoMessages: '', payload: payload as R);

      return parsedResponse;
    }

    return ParsedResponse(statusCode: response.statusCode, errorMessages: '', debugMessages: '', infoMessages: '', payload: null);
  }

  Future<String> _getAutHeader() async {
    final token = await database.tokensDao.getTokenAsync();
    return _bearerTokenExists(token) ? 'Bearer ${token!.authToken}' : 'Bearer ';
  }

  bool _bearerTokenExists(Token? token) => token?.authToken != null;

  bool _isHttpGet(dynamic body) => body == null;

  bool _isOk(http.Response response) {
    if (response == null) return false;
    if (response.statusCode < 200 || response.statusCode >= 300) return false;
    return true;
  }
}
