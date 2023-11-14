import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final calendarNotifierProvider = ChangeNotifierProvider<CalendarProperties>((_) => CalendarProperties());

const textValueText = 'textValue';
const firstDayOfExperimentText = 'firstDayOfExperiment';
const lastDayOfExperimentText = 'lastDayOfExperiment';
const isTitleText = 'isTitle';
const greyValueText = 'greyValue';
const inExperimentText = 'inExperiment';
const isValidatedText = 'isValidated';
const isUnvalidatedText = 'isUnValidated';
const isMissingText = 'isMissing';
const isTodayText = 'isToday';
const confirmed = 'confirmed';
const yearText = 'year';
const monthText = 'month';
const dayText = 'day';

class CalendarPageDayData {
  final DateTime _day;
  final double _missing;
  final double _unvalidated;
  final double _validated;
  final bool _confirmed;

  CalendarPageDayData({required DateTime day, required double missing, required double unvalidated, required double validated, required bool confirmed})
      : _day = day,
        _missing = missing,
        _unvalidated = unvalidated,
        _validated = validated,
        _confirmed = confirmed;

  DateTime get day {
    return _day;
  }

  double? get missing {
    return _missing;
  }

  double? get unvalidated {
    return _unvalidated;
  }

  double? get validated {
    return _validated;
  }

  bool? get confirmed {
    return _confirmed;
  }
}

class CalendarProperties extends ChangeNotifier {
  int _monthIndex = 0;
  int daysSynced = 0;
  int daysMissing = 0;
  int daysToDo = 0;
  int _calendarMonth = DateTime(2022, 12, 28).month;
  int _calendarYear = DateTime(2022, 12, 28).year;
  late List<CalendarPageDayData> _calendarData;
  final List<DateTime> _today = [DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime(2022, 12, 1)))]; //2022, 4, 7
  late List<Map> _calendarValues;

  final months = ['Januari', 'Februari', 'Maart', 'April', 'Mei', 'Juni', 'Juli', 'Augustus', 'September', 'Oktober', 'November', 'December'];

  int get monthIndex {
    return _monthIndex;
  }

  int get calendarMonth {
    return _calendarMonth;
  }

  int get calendarYear {
    return _calendarYear;
  }

  String get monthString {
    return months[_calendarMonth - 1];
  }

  List<Map> get calendarValues {
    return [..._calendarValues];
  }

  void setDates(List<CalendarPageDayData> calendarData) {
    _calendarData = calendarData;
    computeCalendarValues();
  }

  void setMonthIndex(int index) {
    _monthIndex = index;

    notifyListeners();
  }

  void setCalendarMonth(int month) {
    _calendarMonth = month;

    notifyListeners();
  }

  void setCalendarYear(int year) {
    _calendarYear = year;

    notifyListeners();
  }

  void computeProgress() {
    daysMissing = 0;
    daysSynced = 0;
    daysToDo = 0;

    for (var i = 0; i < _calendarData.length; i++) {
      if (_calendarData[i].confirmed!) {
        daysSynced++;
        continue;
      }

      if (!_calendarData[i].confirmed! && (_calendarData[i].unvalidated! > 0 || _calendarData[i].validated! > 0)) {
        daysMissing++;
        continue;
      }

      if (_calendarData[i].missing != 0 && !_calendarData[i].confirmed!) {
        daysToDo++;
        continue;
      }
    }
  }

  void computeCalendarValues() {
    var calendarValues = <Map>[];

    final int _firstWeekDayDisplayMonth = DateTime(calendarYear, calendarMonth).weekday;
    final int _numberOfDaysDisplayMonth = DateTime(calendarYear, calendarMonth + 1, 0).day;
    int _numberOfDaysPreviousMonth = DateTime(calendarYear, calendarMonth, 0).day;

    //Makes sure to check for next year
    final int _previousMonth = calendarMonth == 1 ? 12 : calendarMonth - 1;
    final int _nextMonth = calendarMonth == 12 ? 1 : calendarMonth + 1;

    //Makes sure to check for previous year
    final int _previousMonthsYear = calendarMonth == 1 ? calendarYear - 1 : calendarYear;
    final int _nextMonthsYear = calendarMonth == 12 ? calendarYear + 1 : calendarYear;

    //Adds the days to be displayed from the previous month (and formatting value) to the calendarValues list
    for (int i = 0; i < _firstWeekDayDisplayMonth - 1; i++) {
      final calendarValue = {};
      calendarValue[textValueText] = _numberOfDaysPreviousMonth.toString();
      calendarValue[isTitleText] = false;
      calendarValue[greyValueText] = true;
      _addFormatting(_previousMonthsYear, _previousMonth, _numberOfDaysPreviousMonth, calendarValue);
      calendarValues.add(calendarValue);
      _numberOfDaysPreviousMonth--;
    }
    calendarValues = calendarValues.reversed.toList();

    //Adds the days to be displayed from the this month (and formatting value) to the calendarValues list
    for (int i = 1; i <= _numberOfDaysDisplayMonth; i++) {
      final calendarValue = {};
      calendarValue[textValueText] = i.toString();
      calendarValue[isTitleText] = false;
      calendarValue[greyValueText] = false;
      _addFormatting(calendarYear, calendarMonth, i, calendarValue);
      calendarValues.add(calendarValue);
    }

    //Adds the days to be displayed for the next month (and formatting value) to the calanderValues list
    int i = 1;
    while (calendarValues.length < 42) {
      final calendarValue = {};
      calendarValue[textValueText] = i.toString();
      calendarValue[isTitleText] = false;
      calendarValue[greyValueText] = true;
      _addFormatting(_nextMonthsYear, _nextMonth, i, calendarValue);
      calendarValues.add(calendarValue);
      i++;
    }

    _calendarValues = calendarValues;
  }

  void goBackMonth({bool check = true}) {
    if (_monthIndex > -1 && check) {
      _monthIndex--;
      _calendarYear = _calendarMonth == 1 ? _calendarYear - 1 : _calendarYear;
      _calendarMonth = _calendarMonth == 1 ? 12 : _calendarMonth - 1;
    } else {
      _calendarYear = _calendarMonth == 1 ? _calendarYear - 1 : _calendarYear;
      _calendarMonth = _calendarMonth == 1 ? 12 : _calendarMonth - 1;
    }

    computeCalendarValues();

    notifyListeners();
  }

  void goForwardMonth({bool check = true}) {
    print("goForwardMonth monthIndex [$_monthIndex] and check [$check]");
    if (_monthIndex < 1 && check) {
      _monthIndex++;
      _calendarYear = _calendarMonth == 12 ? _calendarYear + 1 : _calendarYear;
      _calendarMonth = _calendarMonth == 12 ? 1 : _calendarMonth + 1;
    } else {
      _calendarYear = _calendarMonth == 12 ? _calendarYear + 1 : _calendarYear;
      _calendarMonth = _calendarMonth == 12 ? 1 : _calendarMonth + 1;
    }

    computeCalendarValues();

    notifyListeners();
  }

  void _addFormatting(
    int year,
    int month,
    int day,
    Map calendarValue,
  ) {
    final DateTime _firstDayOfExperiment = _calendarData.first.day;
    final DateTime _lastDayOfExperiment = _calendarData.last.day;
    calendarValue[firstDayOfExperimentText] = false;
    calendarValue[lastDayOfExperimentText] = false;
    calendarValue[yearText] = year;
    calendarValue[monthText] = month;
    calendarValue[dayText] = day;
    calendarValue[confirmed] = confirmed;

    if (_firstDayOfExperiment.year == year && _firstDayOfExperiment.month == month && _firstDayOfExperiment.day == day) {
      calendarValue[firstDayOfExperimentText] = true;
    }
    if (_lastDayOfExperiment.year == year && _lastDayOfExperiment.month == month && _lastDayOfExperiment.day == day) {
      calendarValue[lastDayOfExperimentText] = true;
    }

    calendarValue[inExperimentText] = false;
    calendarValue[isValidatedText] = false;
    calendarValue[isUnvalidatedText] = false;
    calendarValue[isMissingText] = false;
    calendarValue[confirmed] = false;
    for (var data in _calendarData) {
      if (data.day.year == year && data.day.month == month && data.day.day == day) {
        calendarValue[inExperimentText] = true;
        calendarValue[isValidatedText] = data.validated ?? 0.0;
        calendarValue[isUnvalidatedText] = data.unvalidated ?? 0.0;
        calendarValue[isMissingText] = data.missing ?? 0.0;
        calendarValue[confirmed] = data.confirmed ?? false;
      }
    }

    calendarValue[isTodayText] = false;
    for (final DateTime specialDate in _today) {
      if (specialDate.year == year && specialDate.month == month && specialDate.day == day) {
        calendarValue[isTodayText] = true;
      }
    }
  }
}
