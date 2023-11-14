import '../database/database.dart';
import '../dtos/parsed_response.dart';
import 'base_api.dart';

class ClassifiedPeriodApi extends BaseApi {
  ClassifiedPeriodApi(Database database) : super('classifiedPeriod/', database);

  Future<ParsedResponse<ClassifiedPeriod?>> sync(ClassifiedPeriod classifiedPeriod) async => this.getParsedResponse<ClassifiedPeriod, ClassifiedPeriod>(
        'upsert',
        ClassifiedPeriod.fromJson,
        payload: classifiedPeriod,
      );
}
