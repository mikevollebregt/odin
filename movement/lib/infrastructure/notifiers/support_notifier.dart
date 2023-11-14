import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:movement/infrastructure/repositories/sensor_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../providers.dart';
import '../repositories/dtos/sensor_stats_dto.dart';
import '../services/ios_service.dart';

class SupportNotifier extends ChangeNotifier {
  final SensorRepository _sensorRepository;

  List<SensorStatsDto> sensorStats = [];
  bool sensorsAreRunning = true;

  SupportNotifier(this._sensorRepository);

  Future<void> updateSensorStats() async {
    sensorStats = await _sensorRepository.getSensorStats();
    notifyListeners();
  }

  Future<int> _getMinutesSinceLastRestart() async {
    final restartTime = (await SharedPreferences.getInstance()).getInt('restart_unix_timestamp') ?? 0;
    return DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(restartTime)).inMinutes;
  }

  Future<int> _getMinutesSinceLogin() async {
    final loginTime = (await SharedPreferences.getInstance()).getInt('login_unix_timestamp') ?? DateTime.now().millisecondsSinceEpoch;
    return DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(loginTime)).inMinutes;
  }

  void pressedRestart() async {
    sensorsAreRunning = true;
    notifyListeners();
  }

  Future<void> updateSensorsAreRunning() async {
    sensorsAreRunning = (await isProblemWithLocationService()) == false;
    notifyListeners();
  }

  Future<bool> isProblemWithLocationService() async {
    const maxMinutesBetweenLocations = 15; 

    final minutesSinceLastRestart = await await _getMinutesSinceLastRestart();
    if (minutesSinceLastRestart < maxMinutesBetweenLocations) return false;

    final sensorGeolocation = await _sensorRepository.getLastBackgroundSensorGeolocation();
    final minutesSinceLogin = await _getMinutesSinceLogin();
    if (sensorGeolocation == null) {
      return minutesSinceLogin >= 1;
    } else {
      return DateTime.now().difference(sensorGeolocation.createdOn).inMinutes > maxMinutesBetweenLocations;
    }
  }

  Future restartLocationService() async {
    (await SharedPreferences.getInstance()).setInt('restart_unix_timestamp', DateTime.now().millisecondsSinceEpoch);
    final notifier = container.read(introLocationNotifierProvider);
    final locationPermission = await Geolocator.checkPermission();
    if (locationPermission != LocationPermission.always && locationPermission != LocationPermission.whileInUse) await notifier.askLocationPermission();
    if (Platform.isIOS) await CallbackHandler.startIOSService();
    if (Platform.isAndroid) await container.read(foregroundServiceProvider).startForegroundService();
  }
}
