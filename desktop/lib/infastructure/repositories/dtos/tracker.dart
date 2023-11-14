
import 'package:json_annotation/json_annotation.dart';

part 'tracker.g.dart';

@JsonSerializable()
class Tracker {
  @JsonKey(name: 'BatteryLevel')
  final int batteryLevel;
  @JsonKey(name: 'Date')
  final int date;

  Tracker(
    this.batteryLevel,
    this.date,
  );

  Map<String, dynamic> toMap() => _$TrackerToJson(this);

  factory Tracker.fromMap(Map<String, dynamic> map) => _$TrackerFromJson(map);

  static List<Tracker> fromList(List<dynamic> list) {
    return list.map((item) => Tracker.fromMap(item as Map<String, dynamic>)).toList();
  }
}
