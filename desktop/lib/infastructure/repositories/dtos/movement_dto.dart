import 'package:desktop/infastructure/repositories/dtos/sensor_geolocation_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/vehicle_dto.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../database/database.dart';
import 'classified_period_dto.dart';

class MovementDto extends ClassifiedPeriodDto {
  final int movementId;
  final VehicleDTO? vehicle;
  final Color? color;

  List<LatLng> get route {
    if (manualGeolocations.isEmpty) return sensorGeolocations.map((s) => LatLng(s.lat, s.lon)).toList();
    final _route = manualGeolocations.map((m) => LatLng(m.latitude, m.longitude)).toList();
    for (final sensorLocation in sensorGeolocations) {
      if (DateTime.fromMillisecondsSinceEpoch(sensorLocation.createdOn).isAfter(manualGeolocations.last.createdOn)) {
        _route.add(LatLng(sensorLocation.lat, sensorLocation.lon));
      }
    }
    return _route;
  }

  MovementDto(
      {required this.movementId,
      required this.vehicle,
      required ClassifiedPeriod classifiedPeriod,
      required List<ManualGeolocation> manualGeolocations,
      required List<SensorGeolocationDTO> sensorGeolocations,
      this.color})
      : super(
          classifiedPeriod: classifiedPeriod,
          manualGeolocations: manualGeolocations,
          sensorGeolocations: sensorGeolocations,
        );

  MovementDto copyWith({
    int? movementId,
    VehicleDTO? vehicle,
    ClassifiedPeriod? classifiedPeriod,
    List<ManualGeolocation>? manualGeolocations,
    List<SensorGeolocationDTO>? sensorGeolocations,
  }) =>
      MovementDto(
        movementId: movementId ?? this.movementId,
        vehicle: vehicle ?? this.vehicle,
        classifiedPeriod: classifiedPeriod ?? this.classifiedPeriod,
        manualGeolocations: manualGeolocations ?? this.manualGeolocations,
        sensorGeolocations: sensorGeolocations ?? this.sensorGeolocations,
      );

  factory MovementDto.fromMap(Map<String, dynamic> json) => MovementDto(
      movementId: 0,
      vehicle: null,
      classifiedPeriod: ClassifiedPeriod(
          id: json["ClassifiedPeriod"]["ID"],
          startDate: DateTime.fromMillisecondsSinceEpoch(json["ClassifiedPeriod"]["StartDate"]),
          endDate: DateTime.fromMillisecondsSinceEpoch(json["ClassifiedPeriod"]["EndDate"]),
          createdOn: DateTime.now(),
          confirmed: false,
          synced: false,
          type: 0,
          userId: 0),
      manualGeolocations: [],
      sensorGeolocations: []);

  static List<MovementDto> fromList(List<dynamic> list) {
    return list.map((item) => MovementDto.fromMap(item as Map<String, dynamic>)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MovementId'] = movementId;
    data["Vehicle"] = vehicle;
    data["ClassifiedPeriod"] = classifiedPeriod;
    data["ManualGeolocations"] = manualGeolocations;
    data["SensorGeolocations"] = sensorGeolocations;

    return data;
  }
}
