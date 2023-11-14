// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceDTO _$DeviceDTOFromJson(Map<String, dynamic> json) => DeviceDTO(
      device: json['Device'] as String?,
      version: json['Version'] as String?,
      product: json['Product'] as String?,
      model: json['DeviceModel'] as String?,
      brand: json['Brand'] as String?,
      androidId: json['AndroidId'] as String?,
      secureId: json['SecureId'] as String?,
      sdk: json['SDK'] as String?,
      width: (json['Width'] as num?)?.toDouble(),
      height: (json['Height'] as num?)?.toDouble(),
      widthLogical: (json['WidthLogical'] as num?)?.toDouble(),
      heightLogical: (json['HeightLogical'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DeviceDTOToJson(DeviceDTO instance) => <String, dynamic>{
      'Device': instance.device,
      'Version': instance.version,
      'Product': instance.product,
      'DeviceModel': instance.model,
      'Brand': instance.brand,
      'AndroidId': instance.androidId,
      'SecureId': instance.secureId,
      'SDK': instance.sdk,
      'Width': instance.width,
      'Height': instance.height,
      'WidthLogical': instance.widthLogical,
      'HeightLogical': instance.heightLogical,
    };
