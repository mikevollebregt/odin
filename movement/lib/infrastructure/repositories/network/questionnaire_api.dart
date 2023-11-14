import '../database/database.dart';
import '../dtos/parsed_response.dart';
import '../dtos/questionnaire_dto.dart';
import 'base_api.dart';

class QuestionnaireApi extends BaseApi {
  QuestionnaireApi(Database database) : super('', database);

  Future<ParsedResponse<QuestionnaireDTO?>> addQuestionnaire(QuestionnaireDTO qeustionnaireString) async =>
      this.getParsedResponse<QuestionnaireDTO, QuestionnaireDTO>('addQuestionnaire', QuestionnaireDTO.fromMap, payload: qeustionnaireString);
}
