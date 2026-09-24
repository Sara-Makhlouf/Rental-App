import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:rental_appartment/constant.dart';
import 'package:rental_appartment/data/models/apartment.dart';

class AuthService {
  Future<List<Apartment>> getApartments(String token) async {
    final response = await http.get(
      Uri.parse("$baseUrl/apartments"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    print("GET Apartments status: ${response.statusCode}");
    print("GET Apartments body: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List data = body['data'] ?? [];
      print("Decoded apartments data: $data");

      return data.map((e) => Apartment.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load apartments: ${response.body}");
    }
  }

  Future<Apartment> addApartment({
    required String token,
    required String title,
    required String description,
    required String address,
    required String price,
    required String bedrooms,
    required String bathrooms,
    required List<File> images,
  }) async {
    final request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/apartments"),
    );

    request.headers["Authorization"] = "Bearer $token";

    request.fields.addAll({
      "title": title,
      "description": description,
      "address": address,
      "price_per_night": price,
      "bedrooms": bedrooms,
      "bathrooms": bathrooms,
    });

    print("ADD Apartment fields: ${request.fields}");

    for (var img in images) {
      print("Adding image: ${img.path}");
      request.files.add(
        await http.MultipartFile.fromPath("images[]", img.path),
      );
    }

    final response = await request.send();
    final body = await response.stream.bytesToString();

    print("ADD Apartment status: ${response.statusCode}");
    print("ADD Apartment body: $body");

    if (response.statusCode == 201) {
      return Apartment.fromJson(jsonDecode(body));
    } else {
      throw Exception("Failed to add apartment: $body");
    }
  }

  Future<bool> updateApartment({
    required String token,
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
    try {
      var uri = Uri.parse("$baseUrl/apartments/$apartmentId");

      var request = http.MultipartRequest("POST", uri);
      request.headers["Accept"] = "application/json";
      request.headers["Authorization"] = "Bearer $token";

      if (title != null) request.fields["title"] = title;
      if (description != null) request.fields["description"] = description;
      if (address != null) request.fields["address"] = address;
      if (price != null) request.fields["price_per_night"] = price;
      if (bedrooms != null) request.fields["bedrooms"] = bedrooms;
      if (bathrooms != null) request.fields["bathrooms"] = bathrooms;
      if (type != null) request.fields["type"] = type;
      if (oldImages != null && oldImages.isNotEmpty) {
        request.fields["old_images"] = oldImages.join(","); // حسب الـ API
      }

      if (newImages != null) {
        for (var img in newImages) {
          request.files.add(
            await http.MultipartFile.fromPath("images[]", img.path),
          );
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("UPDATE Apartment status: ${response.statusCode}");
      print("UPDATE Apartment body: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("Error updating apartment: $e");
      return false;
    }
  }

  Future<bool> deleteApartment({
    required String token,
    required int apartmentId,
  }) async {
    print("Deleting apartment ID $apartmentId with token: $token");

    final response = await http.delete(
      Uri.parse("$baseUrl/apartments/$apartmentId"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    print("DELETE Apartment status: ${response.statusCode}");
    print("DELETE Apartment body: ${response.body}");

    return response.statusCode == 200;
  }
}
