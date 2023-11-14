import 'package:json_annotation/json_annotation.dart';


part 'reason_dto.g.dart';

@JsonSerializable()
class ReasonDTO {
  @JsonKey(name: 'Name')
  String? name;
  @JsonKey(name: 'ID')
  int? id;
  @JsonKey(name: 'Key')
  String key;

  ReasonDTO({this.name, this.id, required this.key});

  //TODO: fix duplicate methods
  factory ReasonDTO.fromMap(Map<String, dynamic> map) => _$ReasonDTOFromJson(map);

  factory ReasonDTO.fromJson(Map<String, dynamic> json) => _$ReasonDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ReasonDTOToJson(this);
}
