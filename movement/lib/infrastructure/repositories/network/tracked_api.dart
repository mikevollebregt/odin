import 'dart:convert';

import '../database/database.dart';
import '../dtos/enums/log_type.dart';
import '../dtos/tracked_day_dto.dart';
import '../log_repository.dart';
import 'base_api.dart';

class TrackedApi extends BaseApi {
  TrackedApi(Database database) : super('tracked/', database);

  Future<void> insertTrackedDay(TrackedDayDTO day) async {
    try {
      final parsedResponse = await this.getParsedResponse<TrackedDayDTO, TrackedDayDTO>('insertTrackedDay', TrackedDayDTO.fromMap, payload: day.toJson());
      print(parsedResponse);
    } catch (error) {
      await log('TrackedApi::insertTrackedDay Error', error.toString(), LogType.Error);
      await log('TrackedApi::insertTrackedDay Error', jsonEncode(day.toJson()), LogType.Error);
    }
  }

  Future<void> updateTrackedDay(TrackedDayDTO day) async {
    try {
      final parsedResponse = await this.getParsedResponse<TrackedDayDTO, TrackedDayDTO>('updateTrackedDay', TrackedDayDTO.fromMap, payload: day.toJson());
      print(parsedResponse);
    } catch (error) {
      await log('TrackedApi::updateTrackedDay Error', error.toString(), LogType.Error);
      await log('TrackedApi::updateTrackedDay Error', jsonEncode(day.toJson()), LogType.Error);
    }
  }
}
