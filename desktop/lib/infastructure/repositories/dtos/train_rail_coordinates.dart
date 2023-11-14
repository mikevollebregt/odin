class VehicleCoordinates {
  final double latitude, longitude;

  VehicleCoordinates({
    required this.latitude,
    required this.longitude,
  });

  factory VehicleCoordinates.fromMap(Map<String, dynamic> json) => VehicleCoordinates(latitude: json["latitude"] / 1.0, longitude: json["longitude"] / 1.0);
}
