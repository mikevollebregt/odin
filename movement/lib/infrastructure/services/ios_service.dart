import 'dart:io';
import 'dart:ui';

import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart' as BackAcc;

import '../../main.dart';
import '../../providers.dart';

class CallbackHandler {
  static Future<void> iosCallback(LocationDto locationDto) async {
    final stopClassifierNotifier = container.read(stopClassifierProvider);
    final deviceService = container.read(deviceServiceProvider);

    final batteryLevel = await deviceService.getBatteryLevelAsync();
    await stopClassifierNotifier.addSensorGeolocation(
        latitude: locationDto.latitude,
        longitude: locationDto.longitude,
        accuracy: locationDto.accuracy,
        altitude: locationDto.altitude,
        bearing: 0,
        speed: locationDto.speed,
        sensorType: '',
        provider: 'ios',
        batteryLevel: batteryLevel ?? 0);
  }

  static Future<void> startIOSService() async {
    if (Platform.isIOS && await BackgroundLocator.isServiceRunning()) {
      await BackgroundLocator.registerLocationUpdate(
        CallbackHandler.iosCallback,
        initDataCallback: <String, int>{'countInit': 1},
        initCallback: CallbackHandler.init,
        iosSettings: const IOSSettings(showsBackgroundLocationIndicator: true),
      );

      await BackgroundLocator.isServiceRunning();
    }
  }

  static Future<void> stopIOSService() async {
    if (Platform.isIOS && await BackgroundLocator.isServiceRunning()) {
      await BackgroundLocator.unRegisterLocationUpdate();

      await BackgroundLocator.isServiceRunning();
    }
  }

  static const String isolateName = 'LocatorIsolate';

  static Future<void> init(Map<dynamic, dynamic> params) async {
    final send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(null);
  }
}
