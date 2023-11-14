import 'package:json_annotation/json_annotation.dart';

part 'tracked_day_dto.g.dart';

@JsonSerializable()
class TrackedDayDTO {
  String? Uuid;
  int? day;
  int? choiceId;
  String? choiceText;
  bool? confirmed;

  TrackedDayDTO({
    this.Uuid,
    this.day,
    this.choiceId,
    this.choiceText,
    this.confirmed,
  });

  factory TrackedDayDTO.fromMap(Map<String, dynamic> map) => _$TrackedDayDTOFromJson(map);

  Map<String, dynamic> toJson() => _$TrackedDayDTOToJson(this);
}
