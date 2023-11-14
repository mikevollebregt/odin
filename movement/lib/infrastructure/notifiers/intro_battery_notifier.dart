import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:flutter/material.dart';

class IntroBatteryNotifier extends ChangeNotifier {
  bool isGranted = false;
  bool isPressed = false;

  Future<void> askDisableBatteryDialog() async {
    await DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
    await Future.delayed(Duration(seconds: 1));
  }

  Future<void> disableBatteryOptimization() async {
    try {
      var response = await DisableBatteryOptimization.isBatteryOptimizationDisabled;
      if (response == true) {
        isGranted = true;
      } else if (response == false) {
        await askDisableBatteryDialog();
        await disableBatteryOptimization();
      } else {
        return;
      }
    } catch (e) {
      return;
    }

    isPressed = true;
    notifyListeners();
  }

  Future<void> reset() async {
    isGranted = await DisableBatteryOptimization.isBatteryOptimizationDisabled ?? false;
    isPressed = false;
    notifyListeners();
  }
}
