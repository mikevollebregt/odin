// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleDTO _$VehicleDTOFromJson(Map<String, dynamic> json) => VehicleDTO(
      name: json['Name'] as String?,
      id: json['ID'] as int?,
      key: json['Key'] as String,
    );

Map<String, dynamic> _$VehicleDTOToJson(VehicleDTO instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'ID': instance.id,
      'Key': instance.key,
    };
