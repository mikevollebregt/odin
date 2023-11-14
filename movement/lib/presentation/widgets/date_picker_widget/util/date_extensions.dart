extension DateTimeCompare on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isSameDayAndHour(DateTime other) {
    return year == other.year && month == other.month && day == other.day && other.hour == hour;
  }

  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }

  String toPaddedString() {
    return '${this.hour.toString().padLeft(2, '0')}:${this.minute.toString().padLeft(2, '0')}';
  }
}

extension DateProperties on DateTime {

  DateTime startOfDay() => DateTime(this.year, this.month, this.day);

  DateTime _startOfNextDay() => this.startOfDay().add(Duration(days: 1));

  DateTime endOfDay() => this._startOfNextDay().subtract(Duration(milliseconds: 1));
  
  int get secondsSinceEpoch => this.millisecondsSinceEpoch ~/ 1000;
}
