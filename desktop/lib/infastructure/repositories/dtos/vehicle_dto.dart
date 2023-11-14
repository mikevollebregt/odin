import 'package:json_annotation/json_annotation.dart';


part 'vehicle_dto.g.dart';

@JsonSerializable()
class VehicleDTO {
  @JsonKey(name: 'Name')
  String? name;
  @JsonKey(name: 'ID')
  int? id;
  @JsonKey(name: 'Key')
  String key;

  VehicleDTO({this.name, this.id, required this.key});

  //TODO: fix duplicate methods
  factory VehicleDTO.fromMap(Map<String, dynamic> map) => _$VehicleDTOFromJson(map);

  factory VehicleDTO.fromJson(Map<String, dynamic> json) => _$VehicleDTOFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleDTOToJson(this);
}
