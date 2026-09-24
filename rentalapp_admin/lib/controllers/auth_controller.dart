import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var isAuthenticated = false.obs;

  final String baseUrl = "http://10.225.63.158:8000/api";

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  // التحقق من حالة المصادقة
  Future<void> checkAuthStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    isAuthenticated.value = token != null && token.isNotEmpty;
  }

  // تسجيل الدخول
  Future<bool> login(String phone, String password) async {
    isLoading(true);
    try {
      var response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({'phone': phone, 'password': password}),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // حفظ التوكن والمعلومات
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('user', json.encode(data['user']));

        // التحقق من أن المستخدم admin
        if (data['user']['role'] == 'admin') {
          isAuthenticated.value = true;
          isLoading(false);
          return true;
        } else {
          await logout();
          Get.snackbar(
            "تنبيه",
            "ليس لديك صلاحية للوصول إلى لوحة التحكم",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
          isLoading(false);
          return false;
        }
      } else {
        var errorData = json.decode(response.body);
        String errorMessage = errorData['message'] ?? 'فشل تسجيل الدخول';
        Get.snackbar(
          "خطأ",
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        isLoading(false);
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "حدث خطأ في الاتصال بالسيرفر",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      isLoading(false);
      return false;
    }
  }

  // تسجيل الخروج
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    isAuthenticated.value = false;
  }

  // الحصول على معلومات المستخدم
  Future<Map<String, dynamic>?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    if (userJson != null) {
      return json.decode(userJson);
    }
    return null;
  }
}
