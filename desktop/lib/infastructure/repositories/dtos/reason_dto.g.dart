// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reason_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReasonDTO _$ReasonDTOFromJson(Map<String, dynamic> json) => ReasonDTO(
      name: json['Name'] as String?,
      id: json['ID'] as int?,
      key: json['Key'] as String,
    );

Map<String, dynamic> _$ReasonDTOToJson(ReasonDTO instance) => <String, dynamic>{
      'Name': instance.name,
      'ID': instance.id,
      'Key': instance.key,
    };
