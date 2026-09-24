import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:rental_appartment/core/cubit/theme_cubit.dart';
import 'package:rental_appartment/core/services/notiefication_service.dart';
import 'package:rental_appartment/firebase_options.dart';
import 'package:rental_appartment/provider/fav_provider.dart';
import 'package:rental_appartment/provider/setting_provuider.dart';
import 'package:rental_appartment/screens2/homepage.dart';
import 'package:rental_appartment/theme/dark_theme.dart';
import 'package:http/http.dart' as http;
import 'package:rental_appartment/views/login_view.dart';
import 'dart:convert';

import 'package:rental_appartment/views/startingpage.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
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
    }
  });
  FirebaseMessaging.onBackgroundMessage(NotificationService.backgroundHandler);

  await NotificationService.init();
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    final data = message.data;
    if (data['type'] == 'booking') {
      Get.toNamed('/booking-details', arguments: data['id']);
    }
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> sendTokenToServer(String fcmToken, String userToken) async {
  try {
    await http.post(
      Uri.parse('http://YOUR_BACKEND_URL/api/save-fcm-token'),
      headers: {
        'Authorization': 'Bearer $userToken',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'fcm_token': fcmToken}),
    );
  } catch (e) {
    print('Failed to send FCM token: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return GetMaterialApp(
          getPages: [
            GetPage(name: '/login', page: () => const LoginView()),
            GetPage(name: '/home', page: () => const HomePage()),
          ],

          //  initialRoute: '/login',
          debugShowCheckedModeBanner: false,
          title: 'Rental Apartment App',

          theme: ThemeData.light(),
          darkTheme: darkTheme,
          themeMode: themeMode,
          home: OnboardingView(),
        );
      },
    );
  }
}
