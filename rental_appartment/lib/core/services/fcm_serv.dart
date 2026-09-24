import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initSettings = InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(initSettings);
  }

  static Future<void> saveToken({
    required int id,
    required bool isOwner,
  }) async {
    await _messaging.requestPermission();

    final token = await _messaging.getToken();
    if (token == null) return;

    await FirebaseFirestore.instance
        .collection(isOwner ? 'owners' : 'users')
        .doc(id.toString())
        .set({
          'fcmToken': token,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  static void listenForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification == null) return;

      _localNotifications.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'default_channel',
            'General Notifications',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    });
  }
}
