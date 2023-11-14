import 'package:intl/intl.dart';

import '../../../infrastructure/repositories/database/database.dart';

String getDateString(ClassifiedPeriod classifiedPeriod, bool isLastIndex) {
  final start = DateFormat('Hm').format(classifiedPeriod.startDate);
  final end = (DateTime.now().difference(classifiedPeriod.endDate).inSeconds <= 60) && isLastIndex ? 'Heden' : DateFormat('Hm').format(classifiedPeriod.endDate);
  return '$start - $end';
}
