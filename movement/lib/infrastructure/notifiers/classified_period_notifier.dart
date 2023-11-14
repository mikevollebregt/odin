import 'package:flutter/foundation.dart';

import '../repositories/classified_period_repository.dart';
import '../repositories/dtos/classified_period_dto.dart';

class ClassifiedPeriodNotifier extends ChangeNotifier {
  final ClassifiedPeriodRepository _classifiedPeriodRepository;

  ClassifiedPeriodDto classifiedPeriodDto;
  bool isModified = false;

  ClassifiedPeriodNotifier(this.classifiedPeriodDto, this._classifiedPeriodRepository) {
    _listenToSensorTimeUpdates();
  }

  void _listenToSensorTimeUpdates() {
    _classifiedPeriodRepository.streamClassifiedPeriodDto(classifiedPeriodDto.classifiedPeriod.uuid).listen(
      (dto) {
        if (isModified == false && dto != null) classifiedPeriodDto.classifiedPeriod = dto.classifiedPeriod.copyWith(endDate: dto.classifiedPeriod.endDate);
      },
    );
  }

  void updateClassifiedPeriod({DateTime? startDate, DateTime? endDate}) {
    classifiedPeriodDto.classifiedPeriod = classifiedPeriodDto.classifiedPeriod.copyWith(startDate: startDate, endDate: endDate);
    isModified = true;
    notifyListeners();
  }
}
