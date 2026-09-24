import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:rental_appartment/constant.dart';
import 'package:rental_appartment/core/services/notiefication_service.dart';
import 'package:rental_appartment/core/validators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

class AuthController extends GetxController {
  var loading = false.obs;
  var user = Rxn<Map<String, dynamic>>();
  var message = RxnString();
  var errorMessage = RxnString();

  Future<void> logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }

      final _ = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      await prefs.remove('token');
      await prefs.remove('role');
      user.value = null;

      Get.offAllNamed('/login');

      Get.snackbar(
        'Success',
        'Logout Success',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      // Get.offAllNamed('/login');
      print("Logout Exception: $e");
    }
  }

  Future<bool> register(
    String firstName,
    String lastName,
    String phone,
    String pass,
    String dateOfBirth,
    String role,
    XFile? profilePicture,
    XFile? idPicture,
  ) async {
    message.value = null;

    if (firstName.isEmpty || lastName.isEmpty || dateOfBirth.isEmpty) {
      message.value = 'Please fill all required fields';
      return false;
    }

    if (!Validators.isPhone(phone)) {
      message.value = 'Invalid phone number';
      return false;
    }

    if (!Validators.isPassword(pass)) {
      message.value = 'Password must be at least 6 characters';
      return false;
    }

    if (profilePicture == null || idPicture == null) {
      message.value = 'Please upload both profile and ID photos';
      return false;
    }

    loading.value = true;

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/register'),
      );

      request.fields['first_name'] = firstName;
      request.fields['last_name'] = lastName;
      request.fields['phone'] = phone;
      request.fields['date_of_birth'] = dateOfBirth;
      request.fields['role'] = role;
      request.fields['password'] = pass;
      request.fields['password_confirmation'] = pass;

      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_picture',
          profilePicture.path,
          filename: basename(profilePicture.path),
        ),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'id_picture',
          idPicture.path,
          filename: basename(idPicture.path),
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        message.value = 'Registration submitted. Waiting for admin approval.';
        loading.value = false;
        return true;
      } else if (response.statusCode == 422) {
        if (data['errors'] != null) {
          message.value = data['errors'].values.first[0];
        } else {
          message.value = data['message'] ?? 'Registration failed';
        }
      } else {
        message.value = data['message'] ?? 'Registration failed';
      }
    } catch (e) {
      message.value = 'Cannot connect to server: $e';
    }

    loading.value = false;
    return false;
  }

  Future<bool> login(String phone, String pass) async {
    errorMessage.value = null;

    if (!Validators.isPhone(phone)) {
      errorMessage.value = 'Invalid phone number';
      return false;
    }

    if (!Validators.isPassword(pass)) {
      errorMessage.value = 'Password must be at least 6 characters';
      return false;
    }

    loading.value = true;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'phone': phone, 'password': pass}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);

        await prefs.setString('role', data['user']['role']);

        user.value = data['user'];
        await NotificationService.saveTokenToServer(
          userToken: data['token'],
          backendUrl: '$baseUrl/save-fcm-token',
        );

        NotificationService.init();
        NotificationService.listenForeground();
        NotificationService.listenNotificationClick();
        loading.value = false;
        return true;
      } else if (response.statusCode == 403) {
        errorMessage.value =
            'Account not verified. Please wait for admin approval.';
      } else if (response.statusCode == 401) {
        errorMessage.value = 'Invalid credentials';
      } else if (response.statusCode == 422) {
        if (data['errors'] != null) {
          errorMessage.value = data['errors'].values.first[0];
        } else {
          errorMessage.value = data['message'] ?? 'Login failed';
        }
      } else {
        errorMessage.value = data['message'] ?? 'Login failed';
      }
    } catch (e) {
      errorMessage.value = 'Cannot connect to server';
    }

    loading.value = false;
    return false;
  }
}
