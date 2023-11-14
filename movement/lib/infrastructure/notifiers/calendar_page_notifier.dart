import 'package:calendar_page/calendar_page.dart';
import 'package:flutter/material.dart';

import '../repositories/tracked_day_repository.dart';
import '../services/foreground_service.dart';

class CalendarPageNotifier extends ChangeNotifier {
  final TrackedDayRepository _trackedDayRepository;
  final ForegroundService _foregroundService;

  bool hasDisplayedFinale = false;
  List<CalendarPageDayData> calendarPageDayDataList = [];

  CalendarPageNotifier(this._trackedDayRepository, this._foregroundService) {
    loadCalendarPageDayDataList();
  }

  void disableForegroundService() async {
    final isRunning = await _foregroundService.isForegroundServiceRunning();
    if (isRunning) {
      _foregroundService.stopForegroundService();
      _foregroundService.completeWeek();
    }
  }

  bool isWeekCompleted() {
    bool isWeekCompletedBool = false;
    if (calendarPageDayDataList.isNotEmpty) {
      isWeekCompletedBool = true;
      for (var item in calendarPageDayDataList) {
        if (!item.confirmed!) {
          isWeekCompletedBool = false;
        }
      }
    }
    return isWeekCompletedBool;
  }

  Future<bool> isInTrackedDays(DateTime date) async => _trackedDayRepository.isInTrackedDays(date);

  Future<void> setupCalendarDays() async {
    calendarPageDayDataList = await _trackedDayRepository.getCalendarPageDayDataList();
    if (calendarPageDayDataList.isEmpty) {
      await _initializeDays();
    }
    await loadCalendarPageDayDataList();
  }

  Future<void> loadCalendarPageDayDataList() async {
    calendarPageDayDataList = await _trackedDayRepository.getCalendarPageDayDataList();
    notifyListeners();
  }

  Future<void> _initializeDays() async {
    for (var day = 0; day <= 7; day++) {
      await _trackedDayRepository.insertTrackedDay(day);
    }
    await loadCalendarPageDayDataList();
  }
}
