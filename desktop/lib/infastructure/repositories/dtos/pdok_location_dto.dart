class PDOKLocationDTO {
  double score, afstand;
  String type, weergavenaam, id;

  PDOKLocationDTO({
    required this.score,
    required this.afstand,
    required this.type,
    required this.weergavenaam,
    required this.id,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Lat'] = score;
    data['Lon'] = afstand;
    data['Altitude'] = type;
    data['SensorType'] = weergavenaam;
    data['Date'] = id;

    return data;
  }

  static List<PDOKLocationDTO> fromList(List<dynamic> list) {
    List<PDOKLocationDTO> mappedList = [];
    for (var item in list) {
      mappedList.add(PDOKLocationDTO.fromMap(item));
    }

    return mappedList;
  }

  factory PDOKLocationDTO.fromMap(Map<String, dynamic> json) => PDOKLocationDTO(
        score: json["score"],
        afstand: json["afstand"] / 1.0,
        type: json["type"],
        weergavenaam: json["weergavenaam"],
        id: json["id"],
      );
}
