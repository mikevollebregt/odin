import 'database/database.dart';
import 'network/reason_api.dart';

class ReasonRepository {
  final Database _database;
  final ReasonApi _reasonApi;

  ReasonRepository(this._database, this._reasonApi);

  Future<List<Reason>?> getReasons() async {
    final reasons = await _database.reasonDao.getReasons();
    if (reasons.isNotEmpty) return reasons;

    final response = await _reasonApi.getReasons();
    final reasonList = await response.payload!;
    reasonList.sort((a, b) => a.id.compareTo(b.id));
    for (final reason in reasonList) {
      await _database.reasonDao.insertReason(reason.toReason());
    }

    final insertedReasons = await _database.reasonDao.getReasons();
    if (insertedReasons.isNotEmpty) return insertedReasons;
    return null;
  }
}
