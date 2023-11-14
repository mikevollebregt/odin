
class SensorGeolocationDTO {
  double lon, lat, altitude, speed, bearing, accuracy, acceleration, calculatedSpeed, density;
  int createdOn, batteryLevel;
  int? deletedOn;
  String sensorType, uuid;

  SensorGeolocationDTO(
      {required this.lon,
      required this.lat,
      required this.altitude,
      required this.sensorType,
      required this.speed,
      required this.bearing,
      required this.accuracy,
      required this.batteryLevel,
      required this.createdOn,
      required this.deletedOn,
      required this.calculatedSpeed,
      required this.acceleration,
      required this.density,
      required this.uuid});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['Latitude'] = lat;
    data['Longitude'] = lon;
    data['Altitude'] = altitude;
    data['Accuracy'] = accuracy;
    data['SensorType'] = sensorType;
    data['CreatedOn'] = createdOn;
    data['DeletedOn'] = deletedOn;
    data['Bearing'] = bearing;
    data['Speed'] = speed;
    data['BatteryLevel'] = batteryLevel;
    data['Uuid'] = "";
    data['UserId'] = "";
    data['Provider'] = "";
    data['SensoryType'] = "";

    return data;
  }

  factory SensorGeolocationDTO.fromMap(Map<String, dynamic> json) => SensorGeolocationDTO(
      lat: json["latitude"] / 1.0,
      lon: json["longitude"] / 1.0,
      altitude: double.parse(json["altitude"].toString()),
      sensorType: json["sensoryType"],
      createdOn: json["createdOn"],
      deletedOn: json["deletedOn"],
      bearing: json["bearing"] / 1.0,
      speed: 1.0,
      batteryLevel: json["batteryLevel"],
      accuracy: json["accuracy"] / 1.0,
      acceleration: 0,
      calculatedSpeed: 0,
      density: 0.0,
      uuid: "");

  static List<SensorGeolocationDTO> fromList(List<dynamic> list) {
    List<SensorGeolocationDTO> mappedList = [];
    for (var item in list) {
      mappedList.add(SensorGeolocationDTO.fromMap(item));
    }

    return mappedList;
  }

  static List<List<SensorGeolocationDTO>> fromListList(List<dynamic> list) {
    List<List<SensorGeolocationDTO>> mappedList = [];
    for (var item in list) {
      List<SensorGeolocationDTO> locationList = [];
      for (var j in item) {
        locationList.add(SensorGeolocationDTO.fromMap(j));
      }
      mappedList.add(locationList);
    }

    return mappedList;
  }
}
