import 'package:desktop/infastructure/repositories/dtos/tracked_day_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/tracker.dart';

import 'location_dto.dart';

class UserTestDayDataDTO {
  List<LocationDTO> rawdata;
  List<List<LocationDTO>> testRawdata;
  List<Tracker> pings;
  TrackedDayDTO trackedDay;

  UserTestDayDataDTO({required this.rawdata, required this.testRawdata, required this.trackedDay, required this.pings});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["RawData"] = rawdata;
    data["ValidatedData"] = rawdata;

    return data;
  }

  factory UserTestDayDataDTO.fromMap(Map<String, dynamic> json) => UserTestDayDataDTO(
      rawdata: json["RawData"] == null ? [] : LocationDTO.fromList(json["RawData"]),
      testRawdata: json["TestRawData"] == null ? [] : LocationDTO.fromListList(json["TestRawData"]),
      trackedDay: TrackedDayDTO.fromMap(json["ValidatedData"]),
      pings: Tracker.fromList(json["Pings"]));

  static List<UserTestDayDataDTO> fromList(List<dynamic> list) {
    List<UserTestDayDataDTO> mappedList = [];
    for (var item in list) {
      mappedList.add(UserTestDayDataDTO.fromMap(item));
    }

    return mappedList;
  }
}
