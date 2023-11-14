import 'package:desktop/infastructure/repositories/dtos/pdok_location_dto.dart';

class PDOKResponseDTO {
  double maxScore;
  int numFound, start;
  bool numFoundExact;
  List<PDOKLocationDTO> locations;

  PDOKResponseDTO({required this.maxScore, required this.numFound, required this.start, required this.numFoundExact, required this.locations});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Lat'] = maxScore;

    return data;
  }

  static List<PDOKResponseDTO> fromList(List<dynamic> list) {
    List<PDOKResponseDTO> mappedList = [];
    for (var item in list) {
      mappedList.add(PDOKResponseDTO.fromMap(item));
    }

    return mappedList;
  }

  factory PDOKResponseDTO.fromMap(Map<String, dynamic> json) => PDOKResponseDTO(
      maxScore: json["maxScore"] / 1.0,
      numFound: json["numFound"],
      start: json["start"],
      numFoundExact: json["numFoundExact"],
      locations: json["docs"] != null ? PDOKLocationDTO.fromList(json["docs"]) : []);
}
