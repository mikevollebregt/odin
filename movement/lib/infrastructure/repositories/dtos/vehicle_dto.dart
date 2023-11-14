import 'package:json_annotation/json_annotation.dart';

import '../database/database.dart';

part 'vehicle_dto.g.dart';

@JsonSerializable()
class VehicleDTO {
  final int id;
  final String name;
  final String icon;
  final String? hexColor;

  VehicleDTO({
    required this.id,
    required this.name,
    required this.icon,
    required this.hexColor,
  });

  factory VehicleDTO.fromMap(Map<String, dynamic> map) => _$VehicleDTOFromJson(map);

  Vehicle toVehicle() => Vehicle(
        id: id,
        name: name,
        icon: icon,
        color: hexColor,
      );
}
