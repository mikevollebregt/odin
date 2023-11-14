import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/classified_period_table.dart';
import '../tables/tracked_day_table.dart';

part 'tracked_day_dao.g.dart';

@DriftAccessor(tables: [TrackedDays, ClassifiedPeriods])
class TrackedDayDao extends DatabaseAccessor<Database> with _$TrackedDayDaoMixin {
  TrackedDayDao(Database db) : super(db);

  Future<int> insertTrackedDay(TrackedDay trackedDay) async => into(trackedDays).insert(trackedDay);

  Future<bool> updateTrackedDay(TrackedDay trackedDay) async => update(trackedDays).replace(trackedDay);

  Future<TrackedDay?> getTrackedDay(DateTime dateTime) async {
    List<TrackedDay> alldays = await (select(trackedDays)).get();
    for (var item in alldays) {
      var itemDate = DateTime(item.date.year, item.date.month, item.date.day);
      var inputDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
      if (itemDate.isAtSameMomentAs(inputDate)) {
        return item;
      }
    }
    return null;
  }

  Future<List<TrackedDay>> getAllTrackedDays() async {
    return (select(trackedDays)).get();
  }

  Future<bool> allDaysCompleted() async {
    final unconfirmedDays = await (select(trackedDays)..where((t) => t.confirmed.equals(false))).get();
    final confirmedDays = await (select(trackedDays)..where((t) => t.confirmed.equals(true))).get();
    return unconfirmedDays.isEmpty && confirmedDays.isNotEmpty;
  }
}
