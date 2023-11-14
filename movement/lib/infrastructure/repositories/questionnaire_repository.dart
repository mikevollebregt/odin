import 'package:movement/infrastructure/repositories/dtos/questionnaire_dto.dart';

import 'network/questionnaire_api.dart';

class QuestionnaireRepository {
  final QuestionnaireApi _questionnaireApi;

  QuestionnaireRepository(this._questionnaireApi);

  Future<void> submitQuestionnaire(String answers) async {
    final survey = QuestionnaireDTO(answers: answers);
    await _questionnaireApi.addQuestionnaire(survey);
  }
}
