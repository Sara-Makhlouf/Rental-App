import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rental_appartment/data/models/apartment.dart';

class UserApartmentController extends GetxController {
  var apartments = <Apartment>[].obs;
  var isLoading = false.obs;

  final String baseUrl = "http://10.225.63.158:8000/api";

  Future<void> fetchPublicApartments() async {
    isLoading(true);
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/apartments'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        apartments.value = (data as List)
            .map((e) => Apartment.fromJson(e))
            .toList();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load apartments");
    } finally {
      isLoading(false);
    }
  }
}
