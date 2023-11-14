import 'package:desktop/infastructure/repositories/dtos/user.dart';
import 'package:json_annotation/json_annotation.dart';

import 'device_dto.dart';

part 'user_device_dto.g.dart';

@JsonSerializable()
class UserDeviceDTO {
  @JsonKey(name: 'User')
  User user;
  @JsonKey(name: 'Device')
  DeviceDTO device;

  UserDeviceDTO(this.user, this.device);

  factory UserDeviceDTO.fromMap(Map<String, dynamic> map) => _$UserDeviceDTOFromJson(map);

  Map<String, dynamic> toMap() => _$UserDeviceDTOToJson(this);
}
