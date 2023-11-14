class LocationDTO {
  double lon, lat, altitude, speed, bearing, accuracy, calculatedSpeed, density;
  int date, trackedId;
  String sensorType;
  bool? isMoving;
  String? uuid;

  LocationDTO(
      {required this.lon,
      required this.lat,
      required this.altitude,
      required this.sensorType,
      required this.date,
      required this.trackedId,
      required this.speed,
      required this.bearing,
      required this.accuracy,
      this.density = 0,
      this.uuid,
      this.calculatedSpeed = 0});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Lat'] = lat;
    data['Lon'] = lat;
    data['Altitude'] = lat;
    data['SensorType'] = lat;
    data['Date'] = lat;
    data['TrackedID'] = lat;

    return data;
  }

  static List<LocationDTO> fromList(List<dynamic> list) {
    List<LocationDTO> mappedList = [];
    for (var item in list) {
      mappedList.add(LocationDTO.fromMap(item));
    }

    return mappedList;
  }

  static List<List<LocationDTO>> fromListList(List<dynamic> list) {
    List<List<LocationDTO>> mappedList = [];
    for (var item in list) {
      List<LocationDTO> locationList = [];
      for (var j in item) {
        locationList.add(LocationDTO.fromMap(j));
      }
      mappedList.add(locationList);
    }

    return mappedList;
  }

  factory LocationDTO.fromMap(Map<String, dynamic> json) => LocationDTO(
      lat: json["Lat"],
      lon: json["Lon"],
      altitude: double.parse(json["Altitude"].toString()),
      sensorType: json["SensorType"],
      date: json["Date"],
      trackedId: json["TrackerID"],
      speed: (json["Speed"]) / 1.0,
      bearing: json["Bearing"] / 1.0,
      accuracy: json["Accuracy"] / 1.0);
}
