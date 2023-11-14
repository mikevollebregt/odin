import 'package:desktop/infastructure/repositories/dtos/tracked_location_dto.dart';

import '../../../presentation/calendar/calendar_properties.dart';

class TrackedDayDTO {
  String id, userId;
  int trackedDayId, day, choiceId, validated, unvalidated, unknown;
  bool confirmed;
  List<TrackedLocationDTO>? locations;

  TrackedDayDTO(
      {required this.id,
      required this.trackedDayId,
      required this.day,
      required this.choiceId,
      required this.confirmed,
      required this.locations,
      required this.userId,
      required this.validated,
      required this.unvalidated,
      required this.unknown});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TrackedDayId'] = trackedDayId;
    data['Day'] = day;
    data['Confirmed'] = confirmed;
    data['ChoiceId'] = choiceId;
    data['TrackedLocation'] = locations;

    return data;
  }

  static List<CalendarPageDayData> toDataList(List<TrackedDayDTO> days) {
    final dataList = <CalendarPageDayData>[];
    for (final item in days) {
      dataList.add(item.toData());
    }

    return dataList;
  }

  factory TrackedDayDTO.fromMap(Map<String, dynamic> json) => TrackedDayDTO(
      id: json["uuid"],
      confirmed: json["confirmed"],
      choiceId: json["choiceId"],
      userId: json["userId"],
      day: json["day"],
      trackedDayId: 0,
      locations: json["TrackedLocations"] != null ? TrackedLocationDTO.fromList(json["TrackedLocations"]) : null,
      validated: json["validated"],
      unvalidated: json["unvalidated"],
      unknown: json["unknown"]);

  static List<TrackedDayDTO> fromList(List<Map<String, dynamic>> list) {
    List<TrackedDayDTO> mappedList = [];
    for (var item in list) {
      mappedList.add(TrackedDayDTO.fromMap(item));
    }

    return mappedList;
  }

  CalendarPageDayData toData() => CalendarPageDayData(
      day: DateTime.fromMillisecondsSinceEpoch(day),
      missing: unknown.toDouble(),
      unvalidated: unvalidated.toDouble(),
      validated: validated.toDouble(),
      confirmed: false);
}
