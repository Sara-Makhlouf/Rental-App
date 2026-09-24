import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static Future<void> saveTokenToServer({
    required String userToken,
    required String backendUrl,
  }) async {
    final fcmToken = await _messaging.getToken();
    if (fcmToken == null) return;

    try {
      await http.post(
        Uri.parse(backendUrl),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'fcm_token': fcmToken}),
      );
      print('✅ FCM Token Saved: $fcmToken');
    } catch (e) {
      print('❌ Error saving token: $e');
    }
  }

  static Future<void> backgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  static Future<void> init() async {
    await _messaging.requestPermission();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        _handleNotificationPayload(details.payload);
      },
    );

    listenForeground();
    listenNotificationClick();
  }

  static void listenForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          payload: jsonEncode(message.data),
        );
      }
    });
  }

  static void listenNotificationClick() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNavigation(message.data);
    });

    _messaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _handleNavigation(message.data);
      }
    });
  }

  static void _handleNotificationPayload(String? payload) {
    if (payload != null) {
      Map<String, dynamic> data = jsonDecode(payload);
      _handleNavigation(data);
    }
  }

  static void _handleNavigation(Map<String, dynamic> data) {
    if (data['type'] == 'booking') {
      Get.toNamed('/booking-details', arguments: data['id']);
    }
  }
}
