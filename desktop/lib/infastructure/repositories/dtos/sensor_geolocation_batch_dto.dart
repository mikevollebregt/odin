import 'package:desktop/infastructure/repositories/dtos/sensor_geolocation_dto.dart';

class SensorGeolocationBatchDTO {
  int userId;
  List<SensorGeolocationDTO> sensorGeolocationBatch;

  SensorGeolocationBatchDTO({required this.userId, required this.sensorGeolocationBatch});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data["sensorGeoLocationBatch"] = sensorGeolocationBatch;

    return data;
  }

  factory SensorGeolocationBatchDTO.fromMap(Map<String, dynamic> json) =>
      SensorGeolocationBatchDTO(userId: json["userId"], sensorGeolocationBatch: SensorGeolocationBatchDTO.fromList(json["sensorGeoLocationBatch"]));

  static List<SensorGeolocationDTO> fromList(List<dynamic> list) {
    return list.map((item) => SensorGeolocationDTO.fromMap(item as Map<String, dynamic>)).toList();
  }
}
