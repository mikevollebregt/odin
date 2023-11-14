import 'package:flutter/material.dart';

import '../repositories/dtos/sensor_geolocation_dto.dart';

class DetailNotifier extends ChangeNotifier {
  SensorGeolocationDTO? location;

  getDetails(SensorGeolocationDTO dto) {
    print(DateTime.fromMillisecondsSinceEpoch(dto.createdOn).toString());
  }
}
