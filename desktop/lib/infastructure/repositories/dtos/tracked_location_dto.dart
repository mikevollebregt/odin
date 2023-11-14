import 'package:desktop/infastructure/repositories/database/database.dart';
import 'package:desktop/infastructure/repositories/dtos/tracked_movement_dto.dart';

class TrackedLocationDTO {
  int? id, trackedDayId, startTime, endTime;
  bool? confirmed;
  List<TrackedMovementDTO>? movements;
  double? lat, lon;

  TrackedLocationDTO(
      {this.id,
      this.trackedDayId,
      this.startTime,
      this.endTime,
      this.movements,
      this.confirmed,
      this.lon,
      this.lat});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Confirmed'] = confirmed;
    data['EndTime'] = endTime;
    data['StartTime'] = startTime;
    data['TrackedDayId'] = trackedDayId;
    data['Lat'] = lat;
    data['Lon'] = lon;

    return data;
  }

  factory TrackedLocationDTO.fromMap(Map<String, dynamic> json) =>
      TrackedLocationDTO(
          confirmed: json["Confirmed"],
          endTime: json["EndTime"],
          startTime: json["StartTime"],
          lat: json["Lat"],
          lon: json["Lon"],
          trackedDayId: json["TrackedDayId"],
          id: json["ID"],
          movements: TrackedMovementDTO.fromList(json["TrackedMovements"]));

  static List<TrackedLocationDTO> fromList(List<dynamic> list) {
    List<TrackedLocationDTO> mappedList = [];
    for (var item in list) {
      mappedList.add(TrackedLocationDTO.fromMap(item));
    }

    return mappedList;
  }

  factory TrackedLocationDTO.fromTrackedLocation(TrackedLocation tl) =>
      TrackedLocationDTO(
        id: tl.id,
        confirmed: tl.confirmed,
        startTime: tl.startTime.millisecondsSinceEpoch,
        endTime: tl.endTime.millisecondsSinceEpoch,
        trackedDayId: tl.trackedDayId,
        lat: tl.lat,
        lon: tl.lon,
      );

  static List<TrackedLocationDTO> fromTableList(List<TrackedLocation> list) {
    List<TrackedLocationDTO> mappedList = [];
    for (var item in list) {
      mappedList.add(TrackedLocationDTO.fromTrackedLocation(item));
    }

    return mappedList;
  }
}
