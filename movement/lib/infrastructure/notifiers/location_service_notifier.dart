import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/dtos/enums/log_type.dart';
import '../repositories/log_repository.dart';
import '../services/foreground_service.dart';

abstract class LocationServiceState {
  const LocationServiceState();
}

class LocationServiceInitial extends LocationServiceState {
  const LocationServiceInitial();
}

class LocationServiceLoading extends LocationServiceState {
  const LocationServiceLoading();
}

@immutable
class LocationServiceLoaded extends LocationServiceState {
  final bool? isRunning;
  const LocationServiceLoaded(this.isRunning);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LocationServiceLoaded && other.isRunning == isRunning;
  }

  @override
  int get hashCode => isRunning.hashCode;
}

@immutable
class LocationServiceError extends LocationServiceState {
  final String message;
  const LocationServiceError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LocationServiceError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class LocationServiceNotifier extends StateNotifier<LocationServiceState> {
  final ForegroundService _foregroundService;

  LocationServiceNotifier(this._foregroundService) : super(const LocationServiceInitial());

  void setIsRunning(bool isRunning) {
    state = LocationServiceLoaded(isRunning);
  }

  Future<void> isForegroundServiceRunningAsync() async {
    try {
      state = const LocationServiceLoading();
      final isRunning = await _foregroundService.isForegroundServiceRunning();
      state = LocationServiceLoaded(isRunning);
    } catch (error) {
      await log('LocationServiceNotifier::isForegroundServiceRunningAsync Error', error.toString(), LogType.Error);
      state = const LocationServiceError("Couldn't fetch foregroundService info.");
    }
  }
}
