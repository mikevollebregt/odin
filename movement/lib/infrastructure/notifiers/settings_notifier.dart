import 'dart:async';
import 'dart:io';

import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart' as BackAcc;
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../repositories/dtos/enums/log_type.dart';
import '../repositories/dtos/setting_dto.dart';
import '../repositories/log_repository.dart';
import '../repositories/sensor_repository.dart';
import '../services/foreground_service.dart';
import '../services/ios_service.dart';
import 'auth_notifier.dart';
import 'generic_notifier.dart';

class SettingsNotifier extends StateNotifier<NotifierState> {
  final ForegroundService _foregroundService;
  final AuthNotifier _authNotifier;
  final SensorRepository _sensorRepository;

  SettingsNotifier(this._foregroundService, this._authNotifier, this._sensorRepository)
      : super(Loaded<SettingsDTO>(SettingsDTO(
            accesibilityMode: false,
            locationCount: 0,
            locationService: false,
            notificationReminder: false,
            notificationTime: const TimeOfDay(hour: 12, minute: 0),
            isBatteryOptimizationDisabled: false,
            shouldRefresh: false))) {
    initState(false);
  }

  Future initState(bool shouldRefresh) async {
    state = Loaded<SettingsDTO>(SettingsDTO(
        accesibilityMode: false,
        locationCount: 0,
        locationService: false,
        notificationReminder: false,
        notificationTime: const TimeOfDay(hour: 12, minute: 0),
        isBatteryOptimizationDisabled: await DisableBatteryOptimization.isBatteryOptimizationDisabled,
        shouldRefresh: shouldRefresh));
  }

  Future initLocationServiceAsync() async {
    bool? isRunning = false;

    if (Platform.isIOS) {
      isRunning = await BackgroundLocator.isServiceRunning();
    } else if (Platform.isAndroid) {
      isRunning = await this._foregroundService.isForegroundServiceRunning();
    }

    await log(
        'SettingsNotifier::initLocationServiceAsync', 'isIOS: ${Platform.isIOS}, isRunning: $isRunning', LogType.Flow);
    setlocationService(isRunning);
  }

  bool? get locationService {
    if (state is Loaded) {
      return ((state as Loaded).loadedObject as SettingsDTO).locationService;
    }
    return null;
  }

  Future<bool> getForegroundRunning() async {
    bool runs = false;
    if (Platform.isIOS) {
      runs = await BackgroundLocator.isServiceRunning();
    } else if (Platform.isAndroid) {
      runs = await _foregroundService.isForegroundServiceRunning();
    }
    return runs;
  }

  void stopForegroundRunning() {
    _foregroundService.stopForegroundService();
  }

  Future configureForegroundService(bool run) async {
    if (Platform.isIOS) {
      if (run) {
        final data = <String, dynamic>{'countInit': 1};
        await _checkLocationPermission();

        await BackgroundLocator.registerLocationUpdate(
          CallbackHandler.iosCallback,
          initDataCallback: data,
          initCallback: CallbackHandler.init,
          iosSettings: IOSSettings(showsBackgroundLocationIndicator: true),
        );
      } else {
        await BackgroundLocator.unRegisterLocationUpdate();
      }
    } else if (Platform.isAndroid) {
      if (run) {
        await _foregroundService.startForegroundService();
      } else {
        await _foregroundService.stopForegroundService();
      }
    }

    await log('SettingsNotifier::configureForegroundService', 'run: $run', LogType.Flow);
    setlocationService(run);
  }

  Future<bool> _checkLocationPermission() async {
    final access = await Geolocator.checkPermission();
    await log('IntroductionPage::askLocationPermission', 'access: $access', LogType.Flow);
    switch (access) {
      case LocationPermission.whileInUse:
        return true;
      case LocationPermission.deniedForever:
        return false;
      case LocationPermission.unableToDetermine:
        final permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.always) {
          return true;
        } else {
          return false;
        }
      case LocationPermission.denied:
        final permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.always) {
          return true;
        } else {
          return false;
        }
      case LocationPermission.always:
        return true;
      default:
        return false;
    }
  }

  void setlocationService(bool? val) {
    log('SettingsNotifier::setlocationService', 'val: $val', LogType.Flow);
    if (state is Loaded) {
      (state as Loaded<SettingsDTO>).loadedObject.locationService = val;
      final newState = state;
      state = const Loading();
      state = newState;
    }
  }

  Future<void> refreshLocationCount() async {
    await log('SettingsNotifier::refreshLocationCount', '', LogType.Flow);
    if (state is Loaded) {
      (state as Loaded<SettingsDTO>).loadedObject.locationCount = await _sensorRepository.getSensorGeolocationCount();
      final newState = state;
      state = const Loading();
      state = newState;
    }
  }

  bool? get notificationReminder {
    if (state is Loaded) {
      return (state as Loaded<SettingsDTO>).loadedObject.notificationReminder;
    }
    return null;
  }

  void setNotificationReminder(bool val) {
    log('SettingsNotifier::setNotificationReminder', 'val: $val', LogType.Flow);
    if (state is Loaded) {
      (state as Loaded<SettingsDTO>).loadedObject.notificationReminder = val;
    }
    final newState = state;
    state = const Loading();
    state = newState;
  }

  TimeOfDay? get notificationTime {
    if (state is Loaded) {
      return (state as Loaded<SettingsDTO>).loadedObject.notificationTime;
    }
    return null;
  }

  void setNotificationTime(TimeOfDay time) {
    log('SettingsNotifier::setNotificationTime', 'val: $time', LogType.Flow);
    if (state is Loaded) {
      (state as Loaded<SettingsDTO>).loadedObject.notificationTime = time;
      final newState = state;
      state = const Loading();
      state = newState;
    }
  }

  bool? get accesibilityMode {
    if (state is Loaded) {
      return ((state as Loaded).loadedObject as SettingsDTO).accesibilityMode;
    }
    return null;
  }

  void setAccesibilityMode(bool val) {
    log('SettingsNotifier::setAccesibilityMode', 'val: $val', LogType.Flow);
    if (state is Loaded) {
      (state as Loaded<SettingsDTO>).loadedObject.accesibilityMode = val;
      final newState = state;
      state = const Loading();
      state = newState;
    }
    state = state;
  }

  Future logout() async {
    await this._authNotifier.logout();
  }
}
