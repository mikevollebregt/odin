import 'dart:math';

import 'package:calendar_page/calendar_page.dart';
import 'package:drift/drift.dart';
import 'package:movement/infrastructure/repositories/dtos/tracked_day_dto.dart';
import 'package:movement/presentation/widgets/date_picker_widget/util/date_extensions.dart';
import 'package:uuid/uuid.dart';

import 'database/database.dart';
import 'network/tracked_api.dart';

class TrackedDayRepository {
  final Database _database;
  final TrackedApi _trackedApi;

  TrackedDayRepository(this._database, this._trackedApi);

  Future<void> insertTrackedDay(int day) async {
    final dateTime = DateTime.now().add(Duration(days: day));
    final dateTimeStartOfDay = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final trackedDay = TrackedDay(
      confirmed: false,
      date: dateTimeStartOfDay,
      uuid: Uuid().v4(),
      synced: false,
    );

    await _database.trackedDayDao.insertTrackedDay(trackedDay);

    await _trackedApi.insertTrackedDay(TrackedDayDTO(Uuid: trackedDay.uuid, day: dateTimeStartOfDay.millisecondsSinceEpoch));
  }

  Future<void> updateTrackedDay(TrackedDay trackedDay) async {
    final dateTimeStartOfDay = DateTime(trackedDay.date.year, trackedDay.date.month, trackedDay.date.day);
    var trackedDayDto = new TrackedDayDTO(
      Uuid: trackedDay.uuid,
      day: dateTimeStartOfDay.millisecondsSinceEpoch,
      choiceId: trackedDay.choiceId,
      confirmed: trackedDay.confirmed,
      choiceText: trackedDay.choiceText,
    );

    await _database.trackedDayDao.updateTrackedDay(trackedDay.copyWith(synced: Value(true)));

    await _trackedApi.updateTrackedDay(trackedDayDto);
  }

  Future<String?> getTrackedDayUuid(DateTime dateTime) async {
    final trackedDay = await _database.trackedDayDao.getTrackedDay(dateTime);
    return trackedDay?.uuid;
  }

  Future<List<TrackedDay>> getAllTrackedDay() {
    throw UnimplementedError();
  }

  Future<TrackedDay?> getTrackedDay(DateTime dateTime) async {
    final trackedDay = await _database.trackedDayDao.getTrackedDay(dateTime);
    return trackedDay;
  }

  Future<void> syncTrackedDays() async {
    final allTrackedDays = await _database.trackedDayDao.getAllTrackedDays();
    for (final trackedDay in allTrackedDays) {
      if (trackedDay.confirmed && !trackedDay.synced!) {
        updateTrackedDay(trackedDay);
      }
    }
  }

  Future<bool> isWeekComplete() {
    return _database.trackedDayDao.allDaysCompleted();
  }

  Future<List<CalendarPageDayData>> getCalendarPageDayDataList() async {
    final trackedDays = await _database.trackedDayDao.getAllTrackedDays();
    return Future.wait(trackedDays.map((t) async {
      final classifiedPeriods = await _database.classifiedPeriodDao.getClassifiedPeriodsOnDay(t.date);
      final progress = _getDailyProgress(classifiedPeriods, t.date);
      return CalendarPageDayData(
        confirmed: t.confirmed,
        day: t.date,
        missing: progress['missing']!,
        unvalidated: progress['unvalidated']!,
        validated: progress['validated']!,
      );
    }).toList());
  }

  Future<bool> isInTrackedDays(DateTime dateTime) async {
    // final trackedDay = await _database.trackedDayDao.getTrackedDay(dateTime);
    // return trackedDay != null;

    final days = await _database.trackedDayDao.getAllTrackedDays();
    final newDateTime = DateTime(dateTime.year, dateTime.month, dateTime.day);

    var timetime = DateTime(days.last.date.year, days.last.date.month, days.last.date.day);
    if (newDateTime.isAfter(timetime)) {
      return false;
    }

    timetime = DateTime(days[0].date.year, days[0].date.month, days[0].date.day);
    if (newDateTime.isBefore(timetime)) {
      return false;
    }

    timetime = DateTime.now();
    if (newDateTime.isBefore(DateTime.now()) || newDateTime.isAtSameMomentAs(DateTime.now())) {
      return true;
    } else {
      return false;
    }
  }

  Future<CalendarPageDayData> getCalendarPageDayData(DateTime dateTime) async {
    final trackedDay = await _database.trackedDayDao.getTrackedDay(dateTime);
    final classifiedPeriods = await _database.classifiedPeriodDao.getClassifiedPeriodsOnDay(dateTime);
    final progress = _getDailyProgress(classifiedPeriods, dateTime);
    return CalendarPageDayData(
      confirmed: trackedDay?.confirmed ?? false,
      day: dateTime,
      missing: progress['missing']!,
      unvalidated: progress['unvalidated']!,
      validated: progress['validated']!,
    );
  }

  Stream<CalendarPageDayData> streamCalendarPageData(DateTime dateTime) async* {
    final trackedDay = await _database.trackedDayDao.getTrackedDay(dateTime);
    yield* _database.classifiedPeriodDao.streamClassifiedPeriodsOnDay(dateTime).asyncMap((classifiedPeriods) {
      final progress = _getDailyProgress(classifiedPeriods, dateTime);
      return CalendarPageDayData(
        confirmed: trackedDay?.confirmed ?? false,
        day: dateTime,
        missing: progress['missing']!,
        unvalidated: progress['unvalidated']!,
        validated: progress['validated']!,
      );
    });
  }

  Map<String, double> _getDailyProgress(List<ClassifiedPeriod> classifiedPeriods, DateTime currentDay) {
    final results = <String, double>{};
    results['validated'] = 0.0;
    results['unvalidated'] = 0.0;
    results['missing'] = 86400.0;
    for (final classifiedPeriod in classifiedPeriods) {
      final _startBoundedByDay = max(classifiedPeriod.startDate.secondsSinceEpoch, currentDay.startOfDay().secondsSinceEpoch);
      final _endBoundedByDay = min(classifiedPeriod.endDate.secondsSinceEpoch, currentDay.endOfDay().secondsSinceEpoch);
      final durationInSeconds = _endBoundedByDay - _startBoundedByDay;
      results['missing'] = results['missing']! - durationInSeconds;
      if (classifiedPeriod.confirmed) {
        results['validated'] = durationInSeconds + results['validated']!;
      } else {
        results['unvalidated'] = durationInSeconds + results['unvalidated']!;
      }
    }
    return results;
  }
}
