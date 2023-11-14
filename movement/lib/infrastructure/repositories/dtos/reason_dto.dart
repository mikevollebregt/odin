import 'package:json_annotation/json_annotation.dart';

import '../database/database.dart';

part 'reason_dto.g.dart';

@JsonSerializable()
class ReasonDTO {
  final int id;
  final String name;
  final String icon;
  final String? color;

  ReasonDTO({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  factory ReasonDTO.fromMap(Map<String, dynamic> map) => _$ReasonDTOFromJson(map);

  Map<String, dynamic> toMap() => _$ReasonDTOToJson(this);

  Reason toReason() => Reason(id: id, name: name, icon: icon, color: color);

  // factory ReasonDTO.reason(Reason r) => ReasonDTO(id: r.id, name: r.name, icon: r.icon, color: r.color);

  // static List<ReasonDTO> fromList(List<Reason> list) {
  //   return list.map(ReasonDTO.reason).toList();
  // }
}
