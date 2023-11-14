import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/dtos/device_dto.dart';
import '../repositories/dtos/enums/log_type.dart';
import '../repositories/log_repository.dart';
import '../services/device_service.dart';

abstract class DeviceState {
  const DeviceState();
}

class DeviceInitial extends DeviceState {
  const DeviceInitial();
}

class DeviceLoading extends DeviceState {
  const DeviceLoading();
}

@immutable
class DeviceLoaded extends DeviceState {
  final DeviceDTO device;
  const DeviceLoaded(this.device);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeviceLoaded && other.device == device;
  }

  @override
  int get hashCode => device.hashCode;
}

@immutable
class DeviceError extends DeviceState {
  final String message;
  const DeviceError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeviceError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class DeviceNotifier extends StateNotifier<DeviceState> {
  final DeviceService _deviceService;

  DeviceNotifier(this._deviceService) : super(const DeviceInitial());

  Future<void> getDevice() async {
    try {
      state = const DeviceLoading();
      final device = await _deviceService.getDeviceAsync();
      state = DeviceLoaded(device!);
    } catch (error) {
      await log('DeviceNotifier::getDevice Error', '', LogType.Error);
      state = const DeviceError("Couldn't fetch device info.");
    }
  }
}
