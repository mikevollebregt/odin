import 'package:desktop/infastructure/repositories/dtos/google_place_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/sensor_geolocation_dto.dart';

class GoogleDetailsDTO {
  final GooglePlaceDTO googlePlaceDTO;
  final SensorGeolocationDTO sensorGeolocationDTO;

  GoogleDetailsDTO(this.googlePlaceDTO, this.sensorGeolocationDTO);
}
