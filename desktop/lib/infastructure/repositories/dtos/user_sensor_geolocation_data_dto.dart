import 'package:desktop/infastructure/repositories/dtos/tracked_day_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/user_sensor_geolocation_day_data_dto.dart';

class UserSensorGeolocationDataDTO {
  String sdk;
  String brand;
  String model;
  String user;
  String userId;
  String sensorCount;
  int userDaySensorCountViewsId;
  TrackedDayDTO? trackedDay;
  List<UserSensorGeolocationDayDataDTO>? userTestDaysDataDTO;

  UserSensorGeolocationDataDTO(
      {required this.sdk,
      required this.brand,
      required this.model,
      required this.user,
      required this.userId,
      required this.sensorCount,
      required this.userTestDaysDataDTO,
      required this.userDaySensorCountViewsId,
      required this.trackedDay});

  factory UserSensorGeolocationDataDTO.fromMap(Map<String, dynamic> map) => UserSensorGeolocationDataDTO(
      sdk: map['sdk'] ?? "",
      brand: map['brand'] ?? "",
      model: map['model'] ?? "",
      user: map['user'] ?? "",
      userId: map['userId'],
      sensorCount: map['sensorCount'],
      userDaySensorCountViewsId: map['userDaySensorCountViewsId'],
      trackedDay: map['trackedDay'] != null ? TrackedDayDTO.fromMap(map['trackedDay']) : null,
      userTestDaysDataDTO: map['userTestDaysDataDTO'] != null ? UserSensorGeolocationDayDataDTO.fromList(map['userTestDaysDataDTO']) : null);

  // Map<String, dynamic> toMap() => _$UserDTOToJson(this);
}
