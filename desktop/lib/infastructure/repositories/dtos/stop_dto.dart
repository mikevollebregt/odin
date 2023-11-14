import 'package:desktop/infastructure/repositories/dtos/reason_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/sensor_geolocation_dto.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../database/database.dart';
import 'classified_period_dto.dart';

class StopDto extends ClassifiedPeriodDto {
  final int stopId;
  final ReasonDTO? reason;
  final GoogleMapsData? googleMapsData;
  final MaterialColor? color;

  LatLng get centroid {
    if (super.manualGeolocations.isNotEmpty) {
      return LatLng(manualGeolocations.first.latitude, manualGeolocations.first.longitude);
    } else {
      return _computeCentroid();
    }
  }

  StopDto(
      {required this.stopId,
      required this.reason,
      required this.googleMapsData,
      required ClassifiedPeriod classifiedPeriod,
      required List<ManualGeolocation> manualGeolocations,
      required List<SensorGeolocationDTO> sensorGeolocations,
      this.color})
      : super(
          classifiedPeriod: classifiedPeriod,
          manualGeolocations: manualGeolocations,
          sensorGeolocations: sensorGeolocations,
        );

  // TODO: maybe move this to the contructor
  LatLng _computeCentroid() {
    final latlngs = super.sensorGeolocations.map((s) => LatLng(s.lat, s.lon)).toList();
    var latitude = 0.0;
    var longitude = 0.0;
    final n = latlngs.length;
    for (final point in latlngs) {
      latitude += point.latitude;
      longitude += point.longitude;
    }
    return LatLng(latitude / n, longitude / n);
  }

  StopDto copyWith({
    int? stopId,
    ReasonDTO? reason,
    GoogleMapsData? googleMapsData,
    ClassifiedPeriod? classifiedPeriod,
    List<ManualGeolocation>? manualGeolocations,
    List<SensorGeolocationDTO>? sensorGeolocations,
  }) =>
      StopDto(
        stopId: stopId ?? this.stopId,
        reason: reason ?? this.reason,
        googleMapsData: googleMapsData ?? this.googleMapsData,
        classifiedPeriod: classifiedPeriod ?? this.classifiedPeriod,
        manualGeolocations: manualGeolocations ?? this.manualGeolocations,
        sensorGeolocations: sensorGeolocations ?? this.sensorGeolocations,
      );

  factory StopDto.fromMap(Map<String, dynamic> json) => StopDto(
      stopId: 0,
      reason: null,
      classifiedPeriod: ClassifiedPeriod(
          id: json["ClassifiedPeriod"]["ID"],
          startDate: DateTime.fromMillisecondsSinceEpoch(json["ClassifiedPeriod"]["StartDate"]),
          endDate: DateTime.fromMillisecondsSinceEpoch(json["ClassifiedPeriod"]["EndDate"]),
          createdOn: DateTime.now(),
          confirmed: false,
          synced: false,
          type: 0,
          userId: 0),
      googleMapsData: null,
      manualGeolocations: [],
      sensorGeolocations: []);

  static List<StopDto> fromList(List<dynamic> list) {
    return list.map((item) => StopDto.fromMap(item as Map<String, dynamic>)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StopId'] = stopId;
    data["Reason"] = reason;
    data["ClassifiedPeriod"] = classifiedPeriod;
    data["ManualGeolocations"] = manualGeolocations;
    data["SensorGeolocations"] = sensorGeolocations;

    return data;
  }
}
