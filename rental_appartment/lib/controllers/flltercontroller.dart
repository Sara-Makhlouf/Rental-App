import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterController extends GetxController {
  var apartments = <Map<String, dynamic>>[].obs;

  var filteredApartments = <Map<String, dynamic>>[].obs;

  var selectedLocation = RxnString();
  var selectedType = RxnString();
  var priceRange = const RangeValues(0, 5000).obs;
  var bedrooms = 0.obs;

  var furnished = false.obs;
  var parking = false.obs;
  var balcony = false.obs;
  var petFriendly = false.obs;

  var searchText = ''.obs;

  void applyFilter() {
    filteredApartments.value = apartments.where((ap) {
      final matchLocation =
          selectedLocation.value == null ||
          ap['location'] == selectedLocation.value;

      final matchType =
          selectedType.value == null || ap['type'] == selectedType.value;

      final matchPrice =
          ap['price'] >= priceRange.value.start &&
          ap['price'] <= priceRange.value.end;

      final matchBedrooms = ap['bedrooms'] >= bedrooms.value;

      final matchFurnished = !furnished.value || ap['furnished'] == true;

      final matchParking = !parking.value || ap['parking'] == true;

      final matchBalcony = !balcony.value || ap['balcony'] == true;

      final matchPet = !petFriendly.value || ap['petFriendly'] == true;

      final matchSearch = ap['name'].toString().toLowerCase().contains(
        searchText.value.toLowerCase(),
      );

      return matchLocation &&
          matchType &&
          matchPrice &&
          matchBedrooms &&
          matchFurnished &&
          matchParking &&
          matchBalcony &&
          matchPet &&
          matchSearch;
    }).toList();
  }

  void resetFilter() {
    selectedLocation.value = null;
    selectedType.value = null;
    priceRange.value = const RangeValues(0, 5000);
    bedrooms.value = 0;
    furnished.value = false;
    parking.value = false;
    balcony.value = false;
    petFriendly.value = false;
    searchText.value = '';
    filteredApartments.value = apartments;
  }
}
