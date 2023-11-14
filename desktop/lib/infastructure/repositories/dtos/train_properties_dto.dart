

class TrainPropertyDTO {
  double lat, lon;

  TrainPropertyDTO({required this.lat, required this.lon});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data["lon"] = lon;

    return data;
  }

  factory TrainPropertyDTO.fromMap(Map<String, dynamic> json) {
    return TrainPropertyDTO(lat: json["latitude"], lon: json["longitude"]);
  }
}
