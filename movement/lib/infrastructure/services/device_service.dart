import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:battery_info/battery_info_plugin.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import '../../main.dart';
import '../../providers.dart';
import '../repositories/dtos/device_dto.dart';
import '../repositories/dtos/enums/log_type.dart';
import '../repositories/log_repository.dart';

class DeviceService {
  static const platform = MethodChannel('com.example.flutter/device_info');

  Future<DeviceDTO?> getDeviceAsync() async {
    try {
      if (Platform.isAndroid) {
        final json = await platform.invokeMethod<String>('getDeviceInfo');
        final device = DeviceDTO.fromMap(jsonDecode(json!) as Map<String, dynamic>);

        device.width = window.physicalSize.width;
        device.height = window.physicalSize.height;
        device.widthLogical = window.physicalSize.width / window.devicePixelRatio;
        device.heightLogical = window.physicalSize.height / window.devicePixelRatio;

        return device;
      } else if (Platform.isIOS) {
        final info = await DeviceInfoPlugin().iosInfo;
        final deviceDTO = DeviceDTO(
          brand: info.model,
          version: info.systemVersion,
          device: info.name,
          model: info.systemName,
          androidId: 'd',
          product: 'd',
          sdk: 'd',
          secureId: 'd',
        );

        return deviceDTO;
      }
    } catch (error) {
      await log('DeviceService::getDeviceAsync', error.toString(), LogType.Error);
      return null;
    }
    return null;
  }

  Future<int?> getBatteryLevelAsync() async {
    try {
      if (Platform.isAndroid) {
        final batteryLevel = await platform.invokeMethod<int>('getBatteryLevel');

        return batteryLevel;
      } else if (Platform.isIOS) {
        final batteryLevel = await (BatteryInfoPlugin().iosBatteryInfo);
        return batteryLevel?.batteryLevel;
      }
    } catch (error) {
      await log('DeviceService::getBatteryLevelAsync', error.toString(), LogType.Error);
      return 0;
    }
    return null;
  }

  Future<List<double>?> getCurrentLocationAsync() async {
    try {
      if (Platform.isAndroid) {
        final position = await GeolocatorPlatform.instance.getCurrentPosition();
        final locaties = [position.latitude, position.longitude];

        return locaties;
      } else if (Platform.isIOS) {
        final position = await GeolocatorPlatform.instance.getCurrentPosition();
        final locaties = [position.latitude, position.longitude];

        return locaties;
      }
    } catch (error) {
      await log('DeviceService::getCurrentLocationAsync', 'unable to access', LogType.Error);
      final list = <double>[];
      list.add(52.058745);
      list.add(4.539478);

      return List.empty();
    }
    return null;
  }

  Future<void> addSensorLocation() async {
    try {
      late final Position position;
      if (Platform.isAndroid) {
        position = await GeolocatorPlatform.instance.getCurrentPosition();
      } else if (Platform.isIOS) {
        position = await GeolocatorPlatform.instance.getCurrentPosition();
      }
      final stopClassifierNotifier = container.read(stopClassifierProvider);
      final deviceService = container.read(deviceServiceProvider);
      final batteryLevel = await deviceService.getBatteryLevelAsync();
      await stopClassifierNotifier.addSensorGeolocation(
          latitude: position.latitude,
          longitude: position.longitude,
          accuracy: position.accuracy,
          altitude: position.altitude,
          bearing: 0,
          speed: position.speed,
          sensorType: 'GeolocatorPlatform',
          provider: 'GeolocatorPlatform',
          batteryLevel: batteryLevel ?? 0);
    } catch (error) {}
  }

  Future getPermissionAsync() async {
    try {
      await Geolocator.requestPermission();
      //TODO: implement scenario where user does not provide permission
    } catch (error) {
      await log('DeviceService::getPermissionAsync', error.toString(), LogType.Error);
    }
  }
}
