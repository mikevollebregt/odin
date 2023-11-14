import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../infrastructure/repositories/dtos/enums/log_type.dart';
import '../../infrastructure/repositories/log_repository.dart';

class AppRetainWidget extends StatelessWidget {
  const AppRetainWidget({Key? key, this.child}) : super(key: key);

  final Widget? child;

  final _channel = const MethodChannel('com.example/app_retain');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          if (Navigator.of(context).canPop()) {
            return true;
          } else {
            await log('App closed', 'app is removed from the background', LogType.Flow);
            await await _channel.invokeMethod<Future<void>>('sendToBackground');
            return false;
          }
        } else {
          return true;
        }
      },
      child: child!,
    );
  }
}
