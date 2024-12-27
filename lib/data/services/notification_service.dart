import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const initializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const init =
        InitializationSettings(android: initializationSettings);

    await localNotificationsPlugin.initialize(
      init,
      onDidReceiveNotificationResponse: (response) async {},
    );

    if (Platform.isAndroid) {
      await localNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    }
  }

  notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        importance: Importance.max,
      ),
    );
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return localNotificationsPlugin.show(
        id, title, body, await notificationDetails());
  }
}
