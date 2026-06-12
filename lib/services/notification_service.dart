import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  // ✅ Init once
  static Future<void> init() async {
    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
    InitializationSettings(android: androidInit);

    await _plugin.initialize(settings);
  }

  // ✅ Show notification
  static Future<void> show(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      "bus_alerts",
      "Bus Alerts",
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
    NotificationDetails(android: androidDetails);

    await _plugin.show(0, title, body, details);
  }
}