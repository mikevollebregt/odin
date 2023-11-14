import 'package:desktop/infastructure/repositories/database/tables/tracked_day_table.dart';
import 'package:desktop/infastructure/repositories/database/tables/tracked_location_table.dart';
import 'package:drift/drift.dart';

import '../../database.dart';

part 'tracked_day_dao.g.dart';

@DriftAccessor(tables: [TrackedDays, TrackedLocations])
class TrackedDaysDao extends DatabaseAccessor<Database> with _$TrackedDaysDaoMixin {
  TrackedDaysDao(Database db) : super(db);

  // Future<TrackedDay?> getByIdAsync(int trackedDayId) => (select(trackedDays)
  //       ..where((tm) => tm.deleted.isNull())
  //       ..where((tm) => tm.id.equals(trackedDayId)))
  //     .getSingleOrNull();

  // Future<List<TrackedDay?>> getAsync() =>
  //     (select(trackedDays)..where((tm) => tm.deleted.isNull())).get();

  // Future<TrackedDay?> findByDayAsync(int day, String uuid) =>
  //     (select(trackedDays)
  //           ..where((tm) => tm.deleted.isNull())
  //           ..where((tm) => tm.uuid.equals(uuid))
  //           ..where((tm) => tm.day.day.equals(day)))
  //         .getSingleOrNull();

  Future<int> insertTrackedDayAsync(
      bool confirmed, int choiceId, String choiceText, DateTime day, double validated, double unvalidated, double missing, String uuid) async {
    var newTrackedLocation = TrackedDaysCompanion.insert(
        confirmed: Value.ofNullable(confirmed), choiceId: Value.ofNullable(choiceId), choiceText: Value.ofNullable(choiceText), date: day);

    var id = await into(trackedDays).insert(newTrackedLocation);

    return id;
  }

  Future updateTrackedDayAsync(TrackedDay td) async {
    var updatedTrackedDay = TrackedDay(id: td.id, confirmed: td.confirmed, choiceId: td.choiceId, choiceText: td.choiceText, date: td.date);

    await update(trackedDays).replace(updatedTrackedDay);
  }

  Future deleteTrackedDayAsync(TrackedDay td) async {
    var deletedTrackedDay = TrackedDay(id: td.id, confirmed: td.confirmed, choiceId: td.choiceId, choiceText: td.choiceText, date: td.date);

    await update(trackedDays).replace(deletedTrackedDay);
  }
}
