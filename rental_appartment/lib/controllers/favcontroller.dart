import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rental_appartment/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rental_appartment/data/models/apartment.dart';

class FavoriteController extends GetxController {
  final RxList<Apartment> favorites = <Apartment>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFavorites();
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  bool isFavorite(dynamic apartmentId) {
    return favorites.any(
      (item) => item.id.toString() == apartmentId.toString(),
    );
  }

  Future<void> fetchFavorites() async {
    String? token = await _getToken();

    if (token == null || token.isEmpty) return;

    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/favorites'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['favorites'] != null && body['favorites']['data'] != null) {
          var data = body['favorites']['data'] as List;
          favorites.assignAll(data.map((e) => Apartment.fromJson(e)).toList());
        } else if (body is List) {
          favorites.assignAll(body.map((e) => Apartment.fromJson(e)).toList());
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavorite(Apartment apartment) async {
    String? token = await _getToken();
    if (token == null) {
      Get.snackbar("تنبيه", "سجل دخولك أولاً");
      return;
    }

    final apartmentId = apartment.id;
    final bool wasFav = isFavorite(apartmentId);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/apartments/$apartmentId/favorite'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"apartment_id": apartmentId.toString()}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (wasFav) {
          favorites.removeWhere(
            (item) => item.id.toString() == apartmentId.toString(),
          );
        } else {
          favorites.add(apartment);
        }
        Get.snackbar(
          "Success",
          wasFav ? "تمت الإزالة من المفضلة" : "تمت الإضافة للمفضلة",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar("خطأ", "فشل التحديث: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("خطأ اتصال", "تعذر الوصول للسيرفر");
    }
  }
}
