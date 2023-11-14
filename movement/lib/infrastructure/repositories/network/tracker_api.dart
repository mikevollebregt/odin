import '../database/database.dart';
import '../dtos/parsed_response.dart';
import '../dtos/tracker_dto.dart';
import 'base_api.dart';

class TrackerApi extends BaseApi {
  TrackerApi(Database database) : super('', database);

  Future<List<TrackerDTO>> getTrackers() async {
    //TODO: implement getTrackersAsync
    throw UnimplementedError();
  }

  Future<ParsedResponse<TrackerDTO?>> postTracker(TrackerDTO trackerDTO) async {
    final map = trackerDTO.toMap();
    return this.getParsedResponse<TrackerDTO, TrackerDTO>('trackers', TrackerDTO.fromMap, payload: map);
  }
}
