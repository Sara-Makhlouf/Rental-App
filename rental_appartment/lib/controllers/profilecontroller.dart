import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  var isLoading = true.obs;
  var userData = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    isLoading.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        Get.snackbar('Auth Error', 'No token found. Please login again.');
        return;
      }

      final response = await http.get(
        Uri.parse('http://10.225.63.158:8000/api/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        userData.value = json.decode(response.body);
      } else if (response.statusCode == 401) {
        Get.snackbar('Session Expired', 'Please login again');
        Get.offAllNamed('/login');
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch profile: ${response.statusCode}',
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Cannot connect to server');
    } finally {
      isLoading.value = false;
    }
  }
}
