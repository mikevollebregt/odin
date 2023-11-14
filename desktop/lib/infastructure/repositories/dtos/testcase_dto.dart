import 'package:desktop/infastructure/repositories/dtos/tracked_day_dto.dart';

import 'location_dto.dart';

class TestCaseDTO {
  String sdk, brand, model, user;
  String? uuid;
  int day;
  List<LocationDTO> rawdata;
  TrackedDayDTO trackedDay;

  TestCaseDTO(
      {required this.sdk,
      required this.brand,
      required this.model,
      required this.day,
      required this.rawdata,
      required this.trackedDay,
      required this.user});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Sdk'] = sdk;
    data["Day"] = day;
    data["Brand"] = brand;
    data["RawData"] = rawdata;
    data["Model"] = model;
    data["ValidatedData"] = rawdata;
    data["User"] = user;

    return data;
  }

  factory TestCaseDTO.fromMap(Map<String, dynamic> json) => TestCaseDTO(
      sdk: json["Sdk"],
      brand: json["Brand"],
      day: json["Day"],
      model: json["Model"],
      user: json["User"],
      rawdata:
          json["RawData"] == null ? [] : LocationDTO.fromList(json["RawData"]),
      trackedDay: TrackedDayDTO.fromMap(json["ValidatedData"]));
}
