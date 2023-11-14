import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  Future<void> createNotification() async {
    if (Platform.isAndroid) {
      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      const androidPlatformChannelSpecifics = AndroidNotificationDetails('cbs_channel', 'tracked locations notifications',
          channelDescription: 'notifications for movements and locations', importance: Importance.max, priority: Priority.high, ticker: 'ticker');

      const platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.show(0, 'Een nieuwe verplaatsing is waargenomen.', 'Valideer de verplaatsing', platformChannelSpecifics);
    }
  }
}
