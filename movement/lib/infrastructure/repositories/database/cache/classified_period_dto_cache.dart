import '../../dtos/classified_period_dto.dart';
import '../database.dart';

// Cache lookup keys
typedef ClassifiedPeriodUuid = String;
typedef EndDate = int;

class ClassifiedPeriodDtoCache {
  final _cachedClassifiedPeriodDtos = <ClassifiedPeriodUuid, Map<EndDate, ClassifiedPeriodDto>>{};

  ClassifiedPeriodDto? get(ClassifiedPeriod classifiedPeriod) {
    final firstKey = classifiedPeriod.uuid;
    final secondKey = classifiedPeriod.endDate.microsecondsSinceEpoch;
    if (_cachedClassifiedPeriodDtos.containsKey(firstKey)) {
      final _innerCache = _cachedClassifiedPeriodDtos[firstKey]!;
      if (_innerCache.containsKey(secondKey)) return _innerCache[secondKey]!;
      _cachedClassifiedPeriodDtos.remove(firstKey);
    }
    return null;
  }

  void add(ClassifiedPeriodDto classifiedPeriodDto) {
    final firstKey = classifiedPeriodDto.classifiedPeriod.uuid;
    final secondKey = classifiedPeriodDto.classifiedPeriod.endDate.microsecondsSinceEpoch;
    _cachedClassifiedPeriodDtos[firstKey] = {secondKey: classifiedPeriodDto};
  }

  void remove(ClassifiedPeriodDto classifiedPeriodDto) {
    final firstKey = classifiedPeriodDto.classifiedPeriod.uuid;
    _cachedClassifiedPeriodDtos.remove(firstKey);
  }
}
