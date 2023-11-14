import 'package:calendar_page/calendar_page.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repositories/classified_period_repository.dart';
import '../repositories/database/database.dart';
import '../repositories/dtos/classified_period_dto.dart';
import '../repositories/dtos/enums/log_type.dart';
import '../repositories/dtos/movement_dto.dart';
import '../repositories/log_repository.dart';
import '../repositories/tracked_day_repository.dart';

class DayOverviewNotifier extends ChangeNotifier {
  final TrackedDayRepository _trackedDayRepository;
  final ClassifiedPeriodRepository _classifiedPeriodRepository;

  DayOverviewNotifier(this._trackedDayRepository, this._classifiedPeriodRepository) {
    initOnboarding();
  }

  List<ClassifiedPeriodDto>? classifiedPeriodDtos;
  bool hasMovements = false;
  bool hasDisplayedOnboarding = false;

  final selectedIds = <String>[];
  void addToSelected(String id) {
    final index = selectedIds.indexWhere((element) => element.contains(id));
    if (index != -1) {
      removeFromSelected(id);
      notifyListeners();
      return;
    }

    selectedIds.add(id);
    notifyListeners();
  }

  void initOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    hasDisplayedOnboarding = prefs.getBool('hasDisplayedOnboarding') ?? false;
  }

  void setOnboarding(bool hasDisplayed) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('hasDisplayedOnboarding', true);
    notifyListeners();
  }

  void removeFromSelected(String id) {
    selectedIds.remove(id);
    notifyListeners();
  }

  Future removeClassifiedPeriods() async {
    final periods = await _classifiedPeriodRepository.getClassifiedPeriodsById(selectedIds);
    await _classifiedPeriodRepository.removeClassifiedPeriods(periods);

    selectedIds.clear();
    isDeleteMode = false;
    notifyListeners();
  }

  bool isDeleteMode = false;
  void setDeleteMode(String id) {
    isDeleteMode = !isDeleteMode;
    final index = selectedIds.indexWhere((element) => element.contains(id));
    if (index == -1) {
      selectedIds.add(id);
    }

    notifyListeners();
  }

  DateTime day = DateTime.now();
  void setDay(DateTime _day) {
    day = _day;
    notifyListeners();
  }

  Future<void> trackedDayHasMovements() async {
    var classifiedPeriods = await streamClassifiedPeriodDtos().first;
    hasMovements = false;
    for (var dto in classifiedPeriods) {
      if (dto is MovementDto) {
        hasMovements = true;
      }
    }
  }

  Stream<List<ClassifiedPeriodDto>> streamClassifiedPeriodDtos() => _classifiedPeriodRepository.streamClassifiedPeriodDtos(day);

  Stream<CalendarPageDayData> streamCalendarPageDayData(DateTime dateTime) => _trackedDayRepository.streamCalendarPageData(dateTime);

  Future confirmDayAsync(String text, int choice, DateTime dateTime) async {
    await log('MovementPageNotifier::confirmDayAsync', 'text: $text, choice1: $choice', LogType.Flow);
    final trackedDay = await _trackedDayRepository.getTrackedDay(dateTime);
    final newTrackedDay = trackedDay!.copyWith(choiceText: Value(text), choiceId: Value(choice), confirmed: true);
    await _trackedDayRepository.updateTrackedDay(newTrackedDay);
    await _trackedDayRepository.syncTrackedDays();
    notifyListeners();
  }

  Future<TrackedDay?> getTrackedDay(dateTime) async {
    final trackedDay = await _trackedDayRepository.getTrackedDay(dateTime);
    return trackedDay;
  }

  bool isLaterDate(DateTime other) {
    DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime secundary = DateTime(other.year, other.month, other.day);
    return now.isAfter(secundary);
  }
}
