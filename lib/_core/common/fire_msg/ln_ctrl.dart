import 'dart:convert';
import 'dart:io';

import 'package:e_com/_core/_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LNService {
  static final _nPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    if (Platform.isAndroid) {
      final androidImpl = _nPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await androidImpl?.requestNotificationsPermission();
    }
    if (Platform.isIOS) {
      final iosImpl = _nPlugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      await iosImpl?.requestPermissions(alert: true, badge: true, sound: true);
    }

    final settings = InitializationSettings(
      android: const AndroidInitializationSettings("@mipmap/launcher_icon"),
      iOS: DarwinInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) {
          if (payload == null) return;
          final data = json.decode(payload);
          OnDeviceNotification.openPageFromLN(data);
        },
      ),
    );

    _nPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload == null) return;
        final data = json.decode(details.payload!);
        OnDeviceNotification.openPageFromLN(data);
      },
    );
  }

  /// Display a local notification from a message map
  static Future<void> displayNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          "main_channel",
          "Main Channel",
          groupKey: AppDefaults.appName,
          setAsGroupSummary: true,
          importance: Importance.max,
          playSound: true,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      );

      await _nPlugin.show(
        id,
        title,
        body,
        details,
        payload: data != null ? json.encode(data) : null,
      );
    } catch (e, s) {
      talk.ex(e, s, 'error on displayNotification');
    }
  }
}
