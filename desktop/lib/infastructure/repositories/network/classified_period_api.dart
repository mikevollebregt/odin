import 'package:desktop/infastructure/repositories/dtos/classified_period_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/movement_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/period_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/stop_dto.dart';

import '../database/database.dart';
import '../dtos/parsed_response.dart';
import 'base_api.dart';

class ClassifiedPeriodApi extends BaseApi {
  ClassifiedPeriodApi(Database database) : super("classifiedPeriod/", database);

  Future<ParsedResponse<StopDto>> addStop(int userId, StopDto stopDto) async =>
      getParsedResponse<StopDto, StopDto>('addStop/$userId', StopDto.fromMap, payload: stopDto);

  Future<ParsedResponse<MovementDto>> addMovement(int userId, MovementDto movementDto) async =>
      getParsedResponse<MovementDto, MovementDto>('addMovement/$userId', MovementDto.fromMap, payload: movementDto);

  Future<ParsedResponse<ClassifiedPeriodDto>> DeleteClassifiedPeriod(int classifiedPeriodId) async =>
      getParsedResponse<ClassifiedPeriodDto, ClassifiedPeriodDto>('DeleteClassifiedPeriod/$classifiedPeriodId', ClassifiedPeriodDto.fromMap);

  Future<ParsedResponse<ValidatedPeriodDto>> GetClassifiedPeriods(int userId, int year, int month, int day) async =>
      getParsedResponse<ValidatedPeriodDto, ValidatedPeriodDto>('GetClassifiedPeriods/$userId/$year/$month/$day', ValidatedPeriodDto.fromMap);
}
