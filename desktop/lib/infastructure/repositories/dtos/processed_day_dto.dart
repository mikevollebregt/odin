import 'package:desktop/infastructure/repositories/dtos/grouped_battery_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/sensor_geolocation_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/tracked_day_dto.dart';

import 'grouped_sensor_geolocations.dart';

class ProcessedDayDTO {
  List<SensorGeolocationDTO> sensorGeolocations, normalSensorGeolocations, fusedSensorGeolocations, balancedSensorGeolocations;
  TrackedDayDTO? trackedDay;
  List<GroupedSensorGeolocationDTO> groupedRawdata, groupedFusedSensorLocations, groupedNormalSensorLocations, groupedBalancedSensorLocations;
  List<GroupedBatteryDTO> groupedBatteries;

  ProcessedDayDTO(
      {required this.sensorGeolocations,
      required this.trackedDay,
      required this.groupedRawdata,
      required this.groupedBatteries,
      required this.groupedNormalSensorLocations,
      required this.groupedFusedSensorLocations,
      required this.groupedBalancedSensorLocations,
      required this.normalSensorGeolocations,
      required this.fusedSensorGeolocations,
      required this.balancedSensorGeolocations});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["sensorGeolocations"] = sensorGeolocations;
    data["trackedDay"] = trackedDay;

    return data;
  }

  factory ProcessedDayDTO.fromMap(Map<String, dynamic> json) => ProcessedDayDTO(
      sensorGeolocations: json["sensorGeolocations"] == null ? [] : SensorGeolocationDTO.fromList(json["sensorGeolocations"]),
      trackedDay: json["trackedDay"] == null ? null : TrackedDayDTO.fromMap(json["trackedDay"]),
      groupedRawdata: json["groupedSensorLocations"] == null ? [] : GroupedSensorGeolocationDTO.fromList(json["groupedSensorLocations"]),
      groupedBatteries: json['groupedBatteries'] == null ? [] : GroupedBatteryDTO.fromList(json['groupedBatteries']),
      groupedFusedSensorLocations: json["groupedFusedSensorLocations"] == null ? [] : GroupedSensorGeolocationDTO.fromList(json["groupedFusedSensorLocations"]),
      groupedNormalSensorLocations:
          json["groupedNormalSensorLocations"] == null ? [] : GroupedSensorGeolocationDTO.fromList(json["groupedNormalSensorLocations"]),
      groupedBalancedSensorLocations:
          json["groupedBalancedSensorLocations"] == null ? [] : GroupedSensorGeolocationDTO.fromList(json["groupedBalancedSensorLocations"]),
      normalSensorGeolocations: json["normalSensorGeolocations"] == null ? [] : SensorGeolocationDTO.fromList(json["normalSensorGeolocations"]),
      fusedSensorGeolocations: json["fusedSensorGeolocations"] == null ? [] : SensorGeolocationDTO.fromList(json["fusedSensorGeolocations"]),
      balancedSensorGeolocations: json["balancedSensorGeolocations"] == null ? [] : SensorGeolocationDTO.fromList(json["balancedSensorGeolocations"]));

  static List<ProcessedDayDTO> fromList(List<dynamic> list) {
    List<ProcessedDayDTO> mappedList = [];
    for (var item in list) {
      mappedList.add(ProcessedDayDTO.fromMap(item));
    }

    return mappedList;
  }
}
