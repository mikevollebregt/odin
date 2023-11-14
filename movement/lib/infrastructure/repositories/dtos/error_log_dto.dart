import 'package:json_annotation/json_annotation.dart';

part 'error_log_dto.g.dart';

@JsonSerializable()
class ErrorLogDTO {
  String? name;
  String? version;

  ErrorLogDTO({
    this.name,
    this.version,
  });

  factory ErrorLogDTO.fromMap(Map<String, dynamic> map) => _$ErrorLogDTOFromJson(map);

  Map<String, dynamic> toMap() => _$ErrorLogDTOToJson(this);

  static List<ErrorLogDTO> fromList(List<Map<String, String>> list) => list.map(ErrorLogDTO.fromMap).toList();
}
