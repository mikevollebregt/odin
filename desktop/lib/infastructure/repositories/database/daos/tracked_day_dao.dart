import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/classified_period_table.dart';
import '../tables/tracked_day_table.dart';

part 'tracked_day_dao.g.dart';

@DriftAccessor(tables: [TrackedDays, ClassifiedPeriods])
class TrackedDayDao extends DatabaseAccessor<Database> with _$TrackedDayDaoMixin {
  TrackedDayDao(Database db) : super(db);

  Future<int> insertTrackedDay(TrackedDay trackedDay) async => into(trackedDays).insert(trackedDay);

  Future<TrackedDay?> getTrackedDay(DateTime dateTime) async {
    return (select(trackedDays)
          ..where((t) => t.date.day.equals(dateTime.day))
          ..where((t) => t.date.month.equals(dateTime.month))
          ..where((t) => t.date.year.equals(dateTime.year)))
        .getSingleOrNull();
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
