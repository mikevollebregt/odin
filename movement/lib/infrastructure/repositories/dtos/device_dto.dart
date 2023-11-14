import 'package:json_annotation/json_annotation.dart';

import '../database/database.dart';

part 'device_dto.g.dart';

@JsonSerializable()
class DeviceDTO {
  @JsonKey(name: 'Device')
  String? device;
  @JsonKey(name: 'Version')
  String? version;
  @JsonKey(name: 'Product')
  String? product;
  @JsonKey(name: 'DeviceModel')
  String? model;
  @JsonKey(name: 'Brand')
  String? brand;
  @JsonKey(name: 'AndroidId')
  String? androidId;
  @JsonKey(name: 'SecureId')
  String? secureId;
  @JsonKey(name: 'SDK')
  String? sdk;
  @JsonKey(name: 'Width')
  double? width;
  @JsonKey(name: 'Height')
  double? height;
  @JsonKey(name: 'WidthLogical')
  double? widthLogical;
  @JsonKey(name: 'HeightLogical')
  double? heightLogical;

  DeviceDTO(
      {this.device,
      this.version,
      this.product,
      this.model,
      this.brand,
      this.androidId,
      this.secureId,
      this.sdk,
      this.width,
      this.height,
      this.widthLogical,
      this.heightLogical});

  //TODO: fix duplicate methods
  factory DeviceDTO.fromMap(Map<String, dynamic> map) => _$DeviceDTOFromJson(map);

  factory DeviceDTO.fromJson(Map<String, dynamic> json) => _$DeviceDTOFromJson(json);

  factory DeviceDTO.fromDevice(Device device) => DeviceDTO(
      device: device.device,
      version: device.version,
      product: device.product,
      model: device.model,
      brand: device.brand,
      androidId: device.androidId,
      secureId: device.secureId,
      sdk: device.sdk,
      width: device.width,
      height: device.height,
      widthLogical: device.widthLogical,
      heightLogical: device.heightLogical);

  Map<String, dynamic> toJson() => _$DeviceDTOToJson(this);

  static List<DeviceDTO> fromList(List<Map<String, String>> list) => list.map(DeviceDTO.fromMap).toList();
}
