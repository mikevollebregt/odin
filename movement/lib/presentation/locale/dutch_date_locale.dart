import 'package:date_format/date_format.dart';

class DutchDateLocale implements DateLocale {
  const DutchDateLocale();

  @override
  final List<String> monthsShort = const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  @override
  final List<String> monthsLong = const [
    'Januari',
    'Februari',
    'Maart',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Augustus',
    'September',
    'Oktober',
    'November',
    'December'
  ];

  @override
  final List<String> daysShort = const ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun'];

  @override
  final List<String> daysLong = const ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  @override
  String get am => 'AM';

  @override
  String get pm => 'PM';
}
