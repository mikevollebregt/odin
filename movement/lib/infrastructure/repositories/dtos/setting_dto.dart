import 'package:flutter/material.dart';

class SettingsDTO {
  bool? notificationReminder;
  TimeOfDay? notificationTime;
  bool? accesibilityMode;
  bool? locationService;
  int? locationCount;
  bool? isBatteryOptimizationDisabled;
  bool? shouldRefresh;

  SettingsDTO(
      {this.notificationReminder,
      this.notificationTime,
      this.accesibilityMode,
      this.locationService,
      this.locationCount,
      this.isBatteryOptimizationDisabled,
      this.shouldRefresh});
}
