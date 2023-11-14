import 'package:desktop/infastructure/repositories/dtos/sensor_geolocation_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/tracked_day_dto.dart';

import 'grouped_sensor_geolocations.dart';

class UserSensorGeolocationDayDataDTO {
  List<SensorGeolocationDTO> rawdata;
  List<GroupedSensorGeolocationDTO> groupedRawdata;
  List<List<SensorGeolocationDTO>> testRawdata;
  TrackedDayDTO trackedDay;

  UserSensorGeolocationDayDataDTO({required this.rawdata, required this.testRawdata, required this.trackedDay, required this.groupedRawdata});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["RawData"] = rawdata;
    data["ValidatedData"] = rawdata;

    return data;
  }

  factory UserSensorGeolocationDayDataDTO.fromMap(Map<String, dynamic> json) => UserSensorGeolocationDayDataDTO(
      rawdata: json["rawdata"] == null ? [] : SensorGeolocationDTO.fromList(json["rawdata"]),
      testRawdata: json["testRawdata"] == null ? [] : SensorGeolocationDTO.fromListList(json["testRawdata"]),
      trackedDay: TrackedDayDTO.fromMap(json["trackedDay"]),
      groupedRawdata: json["groupedRawdata"] == null ? [] : GroupedSensorGeolocationDTO.fromList(json["groupedRawdata"]));

  static List<UserSensorGeolocationDayDataDTO> fromList(List<dynamic> list) {
    List<UserSensorGeolocationDayDataDTO> mappedList = [];
    for (var item in list) {
      mappedList.add(UserSensorGeolocationDayDataDTO.fromMap(item));
    }

    return mappedList;
  }
}
