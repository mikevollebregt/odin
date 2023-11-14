class GroupedBatteryDTO {
  int time, batteryLevel;

  GroupedBatteryDTO({required this.time, required this.batteryLevel});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['batteryLevel'] = batteryLevel;

    return data;
  }

  factory GroupedBatteryDTO.fromMap(Map<String, dynamic> json) => GroupedBatteryDTO(time: json["time"], batteryLevel: json["batteryLevel"]);

  static List<GroupedBatteryDTO> fromList(List<dynamic> list) {
    List<GroupedBatteryDTO> mappedList = [];
    for (var item in list) {
      mappedList.add(GroupedBatteryDTO.fromMap(item));
    }

    return mappedList;
  }

  static List<List<GroupedBatteryDTO>> fromListList(List<dynamic> list) {
    List<List<GroupedBatteryDTO>> mappedList = [];
    for (var item in list) {
      List<GroupedBatteryDTO> locationList = [];
      for (var j in item) {
        locationList.add(GroupedBatteryDTO.fromMap(j));
      }
      mappedList.add(locationList);
    }

    return mappedList;
  }
}
