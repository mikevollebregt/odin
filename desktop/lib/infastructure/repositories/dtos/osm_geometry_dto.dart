class OSMGeometryDTO {
  final List<List<double>> coordinates;

  OSMGeometryDTO({
    required this.coordinates,
  });

  factory OSMGeometryDTO.fromMap(Map<String, dynamic> json) => OSMGeometryDTO(coordinates: fromList(json["coordinates"]));

  static List<List<double>> fromList(List<dynamic> listlist) {
    List<List<double>> testList = List.from(List<double>.from([]));
    var test = listlist.cast<List<double>>();

    for (var list in listlist) {
      List<double> castedList = List<double>.from(list);
      testList.add(castedList);
    }

    return testList;
  }
}
