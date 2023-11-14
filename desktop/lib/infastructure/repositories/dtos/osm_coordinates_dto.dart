import 'package:desktop/infastructure/repositories/dtos/train_rail_coordinates.dart';

import 'osm_stations_dto.dart';

class OSMCoordinatesDTO {
  final List<VehicleCoordinates> coordinates;
  final List<OSMStationsDTO> stations;

  OSMCoordinatesDTO({required this.coordinates, required this.stations});

  factory OSMCoordinatesDTO.fromMap(Map<String, dynamic> json) =>
      OSMCoordinatesDTO(coordinates: fromList(json["coordinates"]), stations: json["stations"] != null ? OSMStationsDTO.fromList(json["stations"]) : []);

  static List<VehicleCoordinates> fromList(List<dynamic> list) {
    return list.map((item) => VehicleCoordinates.fromMap(item as Map<String, dynamic>)).toList();
  }
}
