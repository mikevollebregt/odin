import 'package:json_annotation/json_annotation.dart';

part 'login_payload.g.dart';

@JsonSerializable()
class LoginPayload {
  String username;
  String password;

  LoginPayload(this.username, this.password);

  factory LoginPayload.fromMap(Map<String, dynamic> map) => _$LoginPayloadFromJson(map);

  Map<String, dynamic> toMap() => _$LoginPayloadToJson(this);
}
