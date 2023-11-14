

class TrainGeometryDTO {
  String type;
  List<double> coordinates;

  TrainGeometryDTO({required this.type, required this.coordinates});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data["coordinates"] = coordinates;

    return data;
  }

  factory TrainGeometryDTO.fromMap(Map<String, dynamic> json) {
    var list = json["coordinates"].map((e) => e / 1.0 as double).toList();
    var doubleList = List<double>.from(list);

    return TrainGeometryDTO(type: json["type"], coordinates: doubleList);
  }
}
