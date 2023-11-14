import 'package:desktop/infastructure/repositories/database/database.dart';
import 'package:desktop/infastructure/repositories/dtos/tracked_movement_latlon_dto.dart';

class TrackedMovementDTO {
  int? id, trackedLocationId, startTime, endTime;
  List<TrackedMovementLatlngDTO>? latlngs;
  bool? confirmed;

  TrackedMovementDTO(
      {this.id,
      this.startTime,
      this.endTime,
      this.confirmed,
      this.trackedLocationId,
      this.latlngs});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Confirmed'] = confirmed;
    data['EndTime'] = endTime;
    data['StartTime'] = startTime;
    data['TrackedLocationId'] = trackedLocationId;

    return data;
  }

  factory TrackedMovementDTO.fromMap(Map<String, dynamic> json) =>
      TrackedMovementDTO(
          confirmed: json["Confirmed"],
          endTime: json["EndTime"],
          startTime: json["StartTime"],
          trackedLocationId: json["TrackedLocationId"],
          id: json["ID"],
          latlngs: TrackedMovementLatlngDTO.fromList(json["TrackedLatLons"]));

  static List<TrackedMovementDTO> fromList(List<dynamic> list) {
    List<TrackedMovementDTO> mappedList = [];
    for (var item in list) {
      mappedList.add(TrackedMovementDTO.fromMap(item));
    }

    return mappedList;
  }

  factory TrackedMovementDTO.fromTrackedMovement(TrackedMovement tm) =>
      TrackedMovementDTO(
          id: tm.id,
          confirmed: tm.confirmed,
          startTime: tm.startTime.millisecondsSinceEpoch,
          endTime: tm.endTime.millisecondsSinceEpoch,
          trackedLocationId: tm.trackedLocationId);

  static List<TrackedMovementDTO> fromTableList(List<TrackedMovement> list) {
    List<TrackedMovementDTO> mappedList = [];
    for (var item in list) {
      mappedList.add(TrackedMovementDTO.fromTrackedMovement(item));
    }

    return mappedList;
  }
}
