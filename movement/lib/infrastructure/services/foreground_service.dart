import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../main.dart';
import '../../providers.dart';
import '../repositories/dtos/enums/log_type.dart';
import '../repositories/log_repository.dart';

Future createCallBackIsolate() async {
  WidgetsFlutterBinding.ensureInitialized();
  await startMethodChannel();
}

class ForegroundService {
  Future startForegroundService() async {
    const channel = MethodChannel('com.example/background_service');
    final callbackHandle = PluginUtilities.getCallbackHandle(createCallBackIsolate)!;

    try {
      await channel.invokeMethod<void>('startService', callbackHandle.toRawHandle());
      await startMethodChannel();
    } catch (error) {
      await log('ForegroundService::startForegroundServiceAsync Error', error.toString(), LogType.Error);
    }
  }

  Future stopForegroundService() async {
    try {
      await const MethodChannel('com.example.flutter/foreground_service').invokeMethod<void>('stopForegroundService');
    } catch (error) {
      await log('ForegroundService::stopForegroundServiceAsync Error', error.toString(), LogType.Error);
    }
  }

  Future stopFused() async {
    try {
      await const MethodChannel('com.example.flutter/foreground_service').invokeMethod<void>('stopFused');
    } catch (error) {
      await log('ForegroundService::stopFused Error', error.toString(), LogType.Error);
    }
  }

  Future stopBalanced() async {
    try {
      await const MethodChannel('com.example.flutter/foreground_service').invokeMethod<void>('stopBalanced');
    } catch (error) {
      await log('ForegroundService::stopBalanced Error', error.toString(), LogType.Error);
    }
  }

  Future stopNormal() async {
    try {
      await const MethodChannel('com.example.flutter/foreground_service').invokeMethod<void>('stopNormal');
    } catch (error) {
      await log('ForegroundService::stopNormal Error', error.toString(), LogType.Error);
    }
  }

  Future completeWeek() async {
    try {
      await const MethodChannel('com.example.flutter/foreground_service').invokeMethod<void>('weekCompleted');
    } catch (error) {
      await log('ForegroundService::weekCompleted Error', error.toString(), LogType.Error);
    }
  }

  Future useNormal() async {
    try {
      await const MethodChannel('com.example.flutter/foreground_service').invokeMethod<void>('useNormal');
    } catch (error) {
      await log('ForegroundService::useNormal Error', error.toString(), LogType.Error);
    }
  }

  Future useFused() async {
    try {
      await const MethodChannel('com.example.flutter/foreground_service').invokeMethod<void>('useFused');
    } catch (error) {
      await log('ForegroundService::useFused Error', error.toString(), LogType.Error);
    }
  }

  Future useBalanced() async {
    try {
      await const MethodChannel('com.example.flutter/foreground_service').invokeMethod<void>('useBalanced');
    } catch (error) {
      await log('ForegroundService::useBalanced Error', error.toString(), LogType.Error);
    }
  }

  Future<bool> isForegroundServiceRunning() async {
    try {
      final available = await const MethodChannel('com.example.flutter/foreground_service').invokeMethod<bool?>('isForegroundServiceRunning');

      if (available == null) {
        return false;
      }

      return available;
    } catch (error) {
      await log('ForegroundService::isForegroundServiceRunningAsync Error', error.toString(), LogType.Error);
      return false;
    }
  }
}

@pragma('vm:entry-point')
Future<void> startMethodChannel() async {
  try {
    const MethodChannel('com.example.flutter/location_info').setMethodCallHandler((call) async {
      await log('ForegroundService::startMethodChannel', 'method: ${call.method}}, arguments: ${call.arguments}', LogType.Flow);
      if (call.method == 'save') {
        final geolocationMap = jsonDecode(call.arguments as String) as Map<String, dynamic>;
        var delayInMiliseconds = 0;
        switch (geolocationMap['sensorType'] as String) {
          case 'normal':
            delayInMiliseconds = 0 + Random().nextInt(200);
            break;
          case 'gps':
            delayInMiliseconds = 200 + Random().nextInt(200);
            break;
          case 'fused':
            delayInMiliseconds = 400 + Random().nextInt(200);
            break;
          case 'balanced':
            delayInMiliseconds = 600 + Random().nextInt(200);
            break;
        }
        Future.delayed(Duration(milliseconds: delayInMiliseconds), () async {
          final stopClassifierNotifier = container.read(stopClassifierProvider);
          final deviceService = container.read(deviceServiceProvider);
          // final sensorService = container.read(sensorServiceProvider);
          // sensorService.checkIfShouldChooseSensor();
          final batteryLevel = await deviceService.getBatteryLevelAsync();
          await stopClassifierNotifier.addSensorGeolocation(
              latitude: geolocationMap['lat'] as double,
              longitude: geolocationMap['lon'] as double,
              accuracy: geolocationMap['accuracy'] as double,
              altitude: geolocationMap['altitude'] as double,
              bearing: geolocationMap['bearing'] as double,
              speed: geolocationMap['speed'] as double,
              sensorType: geolocationMap['sensorType'] as String,
              provider: geolocationMap['providers'] as String,
              batteryLevel: batteryLevel ?? 0);
        });
      }
    });
  } catch (error) {
    await log('ForegroundService::startMethodChannel Error', error.toString(), LogType.Error);
  }
}
