import 'package:json_annotation/json_annotation.dart';

part 'questionnaire_dto.g.dart';

@JsonSerializable()
class QuestionnaireDTO {
  final String? answers;

  QuestionnaireDTO({
    required this.answers,
  });

  factory QuestionnaireDTO.fromMap(Map<String, dynamic> map) => _$QuestionnaireDTOFromJson(map);

  Map<String, dynamic> toJson() => _$QuestionnaireDTOToJson(this);
}
