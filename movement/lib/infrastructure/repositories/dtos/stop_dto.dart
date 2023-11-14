import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

import '../database/database.dart';
import 'classified_period_dto.dart';

class StopDto extends ClassifiedPeriodDto with EquatableMixin {
  final String stopUuid;
  final Reason? reason;
  final GoogleMapsData? googleMapsData;

  bool get isComplete => reason != null && googleMapsData != null;

  @override
  List<Object> get props => [stopUuid];

  LatLng? get centroid {
    if (super.manualGeolocations.isNotEmpty) {
      return LatLng(manualGeolocations.first.latitude, manualGeolocations.first.longitude);
    } else if (super.sensorGeolocations.isNotEmpty) {
      return _computeCentroid();
    } else {
      return null;
    }
  }

  StopDto({
    required this.stopUuid,
    required this.reason,
    required this.googleMapsData,
    required ClassifiedPeriod classifiedPeriod,
    required List<ManualGeolocation> manualGeolocations,
    required List<SensorGeolocation> sensorGeolocations,
  }) : super(
          classifiedPeriod: classifiedPeriod,
          manualGeolocations: manualGeolocations,
          sensorGeolocations: sensorGeolocations,
        );

  StopDto.userCreate(DateTime startDate, DateTime endDate, String trackedDayUuid)
      : stopUuid = Uuid().v4(),
        reason = null,
        googleMapsData = null,
        super(
          classifiedPeriod: ClassifiedPeriod(
            uuid: 'user_insert',
            trackedDayUuid: trackedDayUuid,
            startDate: startDate,
            endDate: endDate,
            confirmed: false,
            createdOn: DateTime.now(),
            synced: false,
          ),
          manualGeolocations: [],
          sensorGeolocations: [],
        );

  LatLng _computeCentroid() {
    final latlngs = super.sensorGeolocations.map((s) => LatLng(s.latitude, s.longitude)).toList();
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
    String? stopUuid,
    Reason? reason,
    GoogleMapsData? googleMapsData,
    ClassifiedPeriod? classifiedPeriod,
    List<ManualGeolocation>? manualGeolocations,
    List<SensorGeolocation>? sensorGeolocations,
  }) =>
      StopDto(
        stopUuid: stopUuid ?? this.stopUuid,
        reason: reason ?? this.reason,
        googleMapsData: googleMapsData ?? this.googleMapsData,
        classifiedPeriod: classifiedPeriod ?? this.classifiedPeriod,
        manualGeolocations: manualGeolocations ?? this.manualGeolocations,
        sensorGeolocations: sensorGeolocations ?? this.sensorGeolocations,
      );
}
