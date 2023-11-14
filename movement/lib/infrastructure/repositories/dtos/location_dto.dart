import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'location_dto.g.dart';

@JsonSerializable()
class LocationDTO {
  final double lon;
  final double lat;
  final double altitude;
  final double accuracy;
  final double speed;
  final int date;
  final double? bearing;
  final String? sensorType;
  final String? provider;

  LocationDTO({
    required this.lon,
    required this.lat,
    required this.altitude,
    required this.accuracy,
    required this.speed,
    required this.date,
    this.bearing,
    this.sensorType,
    this.provider,
  });

  Map<String, dynamic> toMap() => _$LocationDTOToJson(this);

  factory LocationDTO.fromJson(String json) => _$LocationDTOFromJson(jsonDecode(json) as Map<String, dynamic>);

  factory LocationDTO.fromMap(Map<String, dynamic> map) => _$LocationDTOFromJson(map);

  static List<LocationDTO> fromList(List<Map<String, dynamic>> list) => list.map(LocationDTO.fromMap).toList();

  Map<String, dynamic> toJson() => _$LocationDTOToJson(this);
}
