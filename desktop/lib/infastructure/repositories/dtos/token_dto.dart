import 'package:json_annotation/json_annotation.dart';

part 'token_dto.g.dart';

@JsonSerializable()
class TokenDTO {
  final String token;

  TokenDTO(this.token);

  factory TokenDTO.fromMap(Map<String, dynamic> map) => _$TokenDTOFromJson(map);

  Map<String, dynamic> toMap() => _$TokenDTOToJson(this);
}
