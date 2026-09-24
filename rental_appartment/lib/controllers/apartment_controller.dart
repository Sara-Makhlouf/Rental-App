import 'dart:io';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/apartment.dart';
import '../core/services/api_services.dart';

class ApartmentController extends GetxController {
  var isLoading = false.obs;
  final AuthService _service = AuthService();

  RxList<Apartment> apartments = <Apartment>[].obs;
  String token = "";

  @override
  void onInit() {
    super.onInit();
    _loadTokenAndFetch();
  }

  Future<void> _loadTokenAndFetch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';

    print("ApartmentController token: $token");

    if (token.isNotEmpty) {
      fetchApartments();
    } else {
      Get.snackbar("Error", "Token not found. Please login again.");
    }
  }

  Future<void> fetchApartments() async {
      if (token.isEmpty) {
      print("Cannot fetch apartments: token is empty");
      return;
    }

    try {
      final data = await _service.getApartments(token);
      apartments.assignAll(data);

      print("Fetched ${data.length} apartments:");
      for (var apt in data) {
        print(
          "Apartment ID: ${apt.id}, Title: ${apt.title}, Price: ${apt.pricePerNight}",
        );
      }
    } catch (e) {
      print("Error fetching apartments: $e");
      Get.snackbar("Error", "Failed to load apartments");
    }
  }

  Future<bool> addNewApartment({
    required String title,
    required String description,
    required String address,
    required String price,
    required String bedrooms,
    required String bathrooms,
    required List<File> images,
  }) async {
    if (token.isEmpty) {
      print("Cannot add apartment: token is empty");
      return false;
    }
    try {
      final apt = await _service.addApartment(
        token: token,
        title: title,
        description: description,
        address: address,
        price: price,
        bedrooms: bedrooms,
        bathrooms: bathrooms,
        images: images,
      );

      print("Apartment added successfully: ID ${apt.id}, Title: ${apt.title}");
      apartments.add(apt);
      return true;
    } catch (e) {
      print("Error adding apartment: $e");

      if (e is HttpException) {
        print("HttpException: ${e.message}");
      }

      return false;
    }
  }

  Future<void> deleteApartment(int id) async {
    if (token.isEmpty) {
      print("Cannot delete apartment: token is empty");
      return;
    }

    try {
      print("Deleting apartment ID $id with token: $token");
      final done = await _service.deleteApartment(
        token: token,
        apartmentId: id,
      );

      if (done) {
        apartments.removeWhere((a) => a.id == id);
        print("Apartment ID $id deleted successfully");
        Get.snackbar("Deleted", "Apartment removed");
      }
    } catch (e) {
      print("Error deleting apartment ID $id: $e");
      Get.snackbar("Error", "Delete failed");
    }
  }

  Future<void> updateApartment({
    required int apartmentId,
    String? title,
    String? description,
    String? address,
    String? price,
    String? bedrooms,
    String? bathrooms,
    String? type,
    List<File>? newImages,
    List<String>? oldImages,
  }) async {
    if (token.isEmpty) {
      print("Cannot update apartment: token is empty");
      return;
    }

    try {
      print("Updating apartment ID $apartmentId with token: $token");

      final done = await _service.updateApartment(
        token: token,
        apartmentId: apartmentId,
        title: title,
        description: description,
        address: address,
        price: price,
        bedrooms: bedrooms,
        bathrooms: bathrooms,
        type: type,
        newImages: newImages,
        oldImages: oldImages,
      );

      if (done) {
        await fetchApartments();
        Get.snackbar("Updated", "Apartment updated successfully");
        print("Apartment ID $apartmentId updated successfully");
      }
    } catch (e) {
      print("Error updating apartment ID $apartmentId: $e");
      Get.snackbar("Error", "Update failed");
    }
  }
}
