class GooglePlaceDTO {
  List<String> pointsOfInterest;
  String place;

  GooglePlaceDTO({required this.pointsOfInterest, required this.place});

  factory GooglePlaceDTO.fromMap(Map<String, dynamic> json) =>
      GooglePlaceDTO(pointsOfInterest: (json["pointsOfInterest"] as List<dynamic>).map((e) => e as String).toList(), place: json["place"]);
}
