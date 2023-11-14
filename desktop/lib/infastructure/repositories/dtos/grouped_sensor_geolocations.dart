class GroupedSensorGeolocationDTO {
  int time, count;

  GroupedSensorGeolocationDTO({required this.time, required this.count});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['count'] = count;

    return data;
  }

  factory GroupedSensorGeolocationDTO.fromMap(Map<String, dynamic> json) => GroupedSensorGeolocationDTO(time: json["time"], count: json["count"]);

  static List<GroupedSensorGeolocationDTO> fromList(List<dynamic> list) {
    List<GroupedSensorGeolocationDTO> mappedList = [];
    for (var item in list) {
      mappedList.add(GroupedSensorGeolocationDTO.fromMap(item));
    }

    return mappedList;
  }

  static List<List<GroupedSensorGeolocationDTO>> fromListList(List<dynamic> list) {
    List<List<GroupedSensorGeolocationDTO>> mappedList = [];
    for (var item in list) {
      List<GroupedSensorGeolocationDTO> locationList = [];
      for (var j in item) {
        locationList.add(GroupedSensorGeolocationDTO.fromMap(j));
      }
      mappedList.add(locationList);
    }

    return mappedList;
  }
}
