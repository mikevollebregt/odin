import 'package:desktop/infastructure/repositories/database/database.dart';

class TrackedMovementLatlngDTO {
  int? id, mappedDate;
  double? lat, lon, altitude;
  int? movementId;

  TrackedMovementLatlngDTO(
      {this.id,
      this.lat,
      this.lon,
      this.altitude,
      this.movementId,
      this.mappedDate});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Lat'] = lat;
    data['Lon'] = lon;
    data['MappedDate'] = mappedDate;
    data['TrackedMovementId'] = movementId;

    return data;
  }

  factory TrackedMovementLatlngDTO.fromMap(Map<String, dynamic> json) =>
      TrackedMovementLatlngDTO(
          id: json["ID"],
          lat: json["Lat"],
          lon: json["Lon"],
          mappedDate: json["MappedDate"],
          movementId: json["TrackedMovementId"],
          altitude: 0);

  static List<TrackedMovementLatlngDTO> fromList(List<dynamic> list) {
    List<TrackedMovementLatlngDTO> mappedList = [];
    for (var item in list) {
      mappedList.add(TrackedMovementLatlngDTO.fromMap(item));
    }

    return mappedList;
  }

  // static List<TrackedMovementLatlngDTO> fromTableList(List<TrackedMovementLatLng> list) {
  //   List<TrackedMovementLatlngDTO> mappedList = [];
  //   for (var item in list) {
  //     mappedList.add(TrackedMovementLatlngDTO.fromMap(item));
  //   }

  //   return mappedList;
  // }

  factory TrackedMovementLatlngDTO.fromLatLon(TrackedMovementLatLng tm) =>
      TrackedMovementLatlngDTO(
          id: tm.id,
          altitude: tm.altitude,
          lat: tm.lat,
          lon: tm.lon,
          mappedDate: tm.mappedDate.millisecondsSinceEpoch,
          movementId: tm.movementId);

  static List<TrackedMovementLatlngDTO> fromTableList(
      List<TrackedMovementLatLng> list) {
    List<TrackedMovementLatlngDTO> mappedList = [];
    for (var item in list) {
      mappedList.add(TrackedMovementLatlngDTO.fromLatLon(item));
    }

    return mappedList;
  }
}
