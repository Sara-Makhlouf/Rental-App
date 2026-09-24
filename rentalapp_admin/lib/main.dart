import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentalapp_admin/admin_dashboard.dart';
import 'package:rentalapp_admin/controllers/admin_controller.dart';
import 'package:rentalapp_admin/controllers/auth_controller.dart';
import 'package:rentalapp_admin/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(AuthController());
  Get.put(AdminGetController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Dashboard',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AdminDashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Obx(() {
      if (authController.isAuthenticated.value) {
        return const AdminDashboard();
      } else {
        return const LoginScreen();
      }
    });
  }
}
