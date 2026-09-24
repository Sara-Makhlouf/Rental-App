import 'dart:ui';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/booking.dart';

class BookingController extends GetxController {
  final isLoading = false.obs;
  final bookings = <Booking>[].obs;

  final String baseUrl = 'http://10.225.63.158:8000/api';

  // ============================================================
  // Cancel booking
  // ============================================================

  Future<bool> cancelBooking(int bookingId) async {
    isLoading.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.delete(
        Uri.parse('$baseUrl/bookings/$bookingId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final index = bookings.indexWhere((b) => b.id == bookingId);

        if (index != -1) {
          bookings[index].status = 'cancelled';
          bookings.refresh();
        }

        Get.snackbar(
          'Cancelled',
          'Booking has been cancelled successfully',
          backgroundColor: const Color(0xFFBBF1D2),
          colorText: const Color(0xFF25313C),
        );

        return true;
      }

      final error = json.decode(response.body);

      Get.snackbar(
        'Notice',
        error['message'] ?? 'Cannot cancel booking at this time',
        backgroundColor: const Color(0xFFFFC5AA),
        colorText: const Color(0xFF25313C),
      );

      return false;
    } catch (e) {
      Get.snackbar('Error', 'Server connection failed');

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // Update booking date
  // ============================================================

  Future<bool> updateBookingDate(
    int bookingId,
    String checkIn,
    String checkOut,
    bool applyFine,
  ) async {
    isLoading.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.put(
        Uri.parse('$baseUrl/bookings/$bookingId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'check_in': checkIn,
          'check_out': checkOut,
          'has_fine': applyFine,
        }),
      );

      if (response.statusCode == 200) {
        final index = bookings.indexWhere((b) => b.id == bookingId);

        if (index != -1) {
          bookings[index].date = '$checkIn to $checkOut';
          bookings[index].status = 'pending';
          bookings.refresh();
        }

        Get.snackbar(
          'Success',
          applyFine
              ? 'Booking updated with fine applied'
              : 'Booking updated successfully',
          backgroundColor: const Color(0xFFBBF1D2),
          colorText: const Color(0xFF25313C),
        );

        await fetchBookings();

        return true;
      }

      final error = json.decode(response.body);

      Get.snackbar(
        'Notice',
        error['message'] ?? 'Unable to update booking',
        backgroundColor: const Color(0xFFFFC5AA),
        colorText: const Color(0xFF25313C),
      );

      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to server');

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // Create booking
  // ============================================================

  Future<bool> createBooking(
    int apartmentId,
    String checkIn,
    String checkOut,
    int guests,
  ) async {
    isLoading.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse('$baseUrl/bookings'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'apartment_id': apartmentId,
          'check_in': checkIn,
          'check_out': checkOut,
          'guests': guests,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final resData = json.decode(response.body);

        final b = resData['booking'] ?? {};
        final apartment = b['apartment'] ?? {};

        double parsedPrice = 0.0;

        final rawPrice = b['total_price'] ?? apartment['price_per_night'] ?? 0;

        if (rawPrice is String) {
          parsedPrice = double.tryParse(rawPrice) ?? 0;
        } else if (rawPrice is num) {
          parsedPrice = rawPrice.toDouble();
        }

        bookings.add(
          Booking(
            id: b['id'] ?? 0,
            title: apartment['title'] ?? 'New booking',
            date:
                '${b['check_in'] ?? checkIn} to ${b['check_out'] ?? checkOut}',
            price: parsedPrice,
            status: b['status'] ?? 'pending',
            image:
                apartment['images_urls'] != null &&
                    (apartment['images_urls'] as List).isNotEmpty
                ? apartment['images_urls'][0]
                : 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
          ),
        );

        bookings.refresh();

        Get.snackbar(
          'Success',
          'Booking created successfully',
          backgroundColor: const Color(0xFFBBF1D2),
          colorText: const Color(0xFF25313C),
        );

        return true;
      }

      Get.snackbar('Error', 'Server failed to create booking');

      return false;
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // Fetch bookings
  // ============================================================

  Future<void> fetchBookings() async {
    isLoading.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('$baseUrl/bookings'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        bookings.assignAll(data.map((json) => Booking.fromMap(json)).toList());
      }
    } catch (e) {
      print('Fetch Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // Parse price
  // ============================================================

  double parsePrice(dynamic price) {
    if (price == null) return 0;

    if (price is String) {
      return double.tryParse(price) ?? 0;
    }

    return (price as num).toDouble();
  }
}
