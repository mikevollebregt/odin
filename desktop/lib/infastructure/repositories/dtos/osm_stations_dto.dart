class OSMStationsDTO {
  final double latitude, longitude;
  final String stations;

  OSMStationsDTO({required this.latitude, required this.longitude, required this.stations});

  factory OSMStationsDTO.fromMap(Map<String, dynamic> json) =>
      OSMStationsDTO(latitude: json["latitude"] / 1.0, longitude: json["longitude"] / 1.0, stations: json["name"]);

  static List<OSMStationsDTO> fromList(List<dynamic> list) {
    return list.map((item) => OSMStationsDTO.fromMap(item as Map<String, dynamic>)).toList();
  }
}
