import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rental_appartment/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rental_appartment/data/models/message.dart';

class MessageService {
  static Future<Map<String, String>> getHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  static Future<List<MessageModel>> getMessages(int bookingId) async {
    final headers = await getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/bookings/$bookingId/messages'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['messages'] as List)
          .map((e) => MessageModel.fromJson(e))
          .toList();
    } else {
      throw Exception('فشل في جلب الرسائل: ${response.statusCode}');
    }
  }

  static Future<void> sendMessage(int bookingId, String messageText) async {
    final headers = await getHeaders();

    final response = await http.post(
      Uri.parse('$baseUrl/bookings/$bookingId/messages'),
      headers: headers,
      body: jsonEncode({'message': messageText}),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('فشل إرسال الرسالة: ${response.body}');
    }
  }

  static Future<List<dynamic>> getOwnerConversations() async {
    final headers = await getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/owner/conversations'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('فشل في جلب قائمة المحادثات');
    }
  }

  static Future<void> markAsRead(int messageId) async {
    final headers = await getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/messages/$messageId/read'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('فشل تحديث حالة القراءة');
    }
  }
}
