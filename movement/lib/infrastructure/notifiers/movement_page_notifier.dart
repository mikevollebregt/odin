import 'package:flutter/material.dart';

import '../repositories/database/database.dart';
import '../repositories/tracked_day_repository.dart';

class MovementPageNotifier extends ChangeNotifier {
  final TrackedDayRepository trackedDayRepository;

  MovementPageNotifier(this.trackedDayRepository);

  Future<TrackedDay> getTrackedDay() async {
    throw UnimplementedError();
  }
}
