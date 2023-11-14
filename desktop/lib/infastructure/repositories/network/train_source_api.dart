
import '../database/database.dart';
import '../dtos/parsed_response.dart';
import '../dtos/train_properties_dto.dart';
import 'base_api.dart';

class TrainSourceApi extends BaseApi {
  TrainSourceApi(Database database) : super("trainSource/", database);

  Future<ParsedResponse<List<TrainPropertyDTO>>> getPolylineTrainInfrastructureAsync() async =>
      getParsedResponse<List<TrainPropertyDTO>, TrainPropertyDTO>('getPolylineTrainInfrastructure', TrainPropertyDTO.fromMap);
}
