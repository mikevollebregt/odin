import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDTO {
  String username;
  String email;
  String password;

  UserDTO(this.username, this.email, this.password);

  factory UserDTO.fromJson(Map<String, dynamic> map) => _$UserDTOFromJson(map);

  Map<String, dynamic> toMap() => _$UserDTOToJson(this);
}
