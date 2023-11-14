import 'package:json_annotation/json_annotation.dart';

import '../database/database.dart';

part 'log_dto.g.dart';

@JsonSerializable()
class LogDTO {
  @JsonKey(name: 'Message')
  String? message;
  @JsonKey(name: 'Description')
  String? description;
  @JsonKey(name: 'Type')
  String? type;
  @JsonKey(name: 'DateTime')
  int datetime;

  LogDTO({
    required this.message,
    required this.description,
    required this.type,
    required this.datetime,
  });

  factory LogDTO.fromMap(Map<String, dynamic> map) => _$LogDTOFromJson(map);

  factory LogDTO.fromLog(Log log) => LogDTO(
        message: log.message,
        description: log.description,
        type: log.type,
        datetime: log.date!.microsecondsSinceEpoch,
      );

  Map<String, dynamic> toJson() => _$LogDTOToJson(this);

  static List<LogDTO> fromList(List<Log> list) {
    return list.map((log) => LogDTO.fromLog(log)).toList();
  }

  static List<Map<String, dynamic>> toList(List<LogDTO> list) {
    return list.map((log) => log.toJson()).toList();
  }
}
