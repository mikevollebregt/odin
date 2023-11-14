// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_device_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDeviceDTO _$UserDeviceDTOFromJson(Map<String, dynamic> json) =>
    UserDeviceDTO(
      User.fromJson(json['User'] as Map<String, dynamic>),
      DeviceDTO.fromJson(json['Device'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserDeviceDTOToJson(UserDeviceDTO instance) =>
    <String, dynamic>{
      'User': instance.user,
      'Device': instance.device,
    };
