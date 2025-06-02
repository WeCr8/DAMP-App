
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _localNotifications.initialize(initSettings);
  }

  static Future<void> showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails('damp_channel', 'DAMP Alerts', importance: Importance.high, priority: Priority.high);
    const notificationDetails = NotificationDetails(android: androidDetails);
    await _localNotifications.show(0, title, body, notificationDetails);
  }
}
