import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rentalapp_admin/constant.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AdminGetController extends GetxController {
  // قائمة المستخدمين المعلقين
  var pendingUsers = <dynamic>[].obs;
  var isLoading = true.obs;

  // متغيرات التصفح
  var currentPage = 1.obs;
  var lastPage = 1.obs;
  var total = 0.obs;
  var perPage = 10.obs;
  var hasNextPage = false.obs;
  var hasPrevPage = false.obs;

  // الرابط الأساسي للسيرفر (تأكد أن الـ IP صحيح دائماً)
  //final String baseUrl = "http://10.24.129.158:8000/api";

  @override
  void onInit() {
    super.onInit();
    // لا نستدعي fetchPendingUsers هنا لأننا ننتظر التحقق من المصادقة أولاً
  }

  // دالة مساعدة للحصول على الهيدرز مع التوكن
  Future<Map<String, String>> _getHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  // 1. جلب قائمة المستخدمين المعلقين مع دعم التصفح
  Future<void> fetchPendingUsers({int? page}) async {
    isLoading(true);
    try {
      final headers = await _getHeaders();
      String url = "$baseUrl/pending-users";
      if (page != null) {
        url += "?page=$page";
      }

      var response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // معالجة الاستجابة مع التصفح
        if (data['data'] != null) {
          pendingUsers.value = data['data'];
          currentPage.value = data['current_page'] ?? 1;
          lastPage.value = data['last_page'] ?? 1;
          total.value = data['total'] ?? 0;
          perPage.value = data['per_page'] ?? 10;
          hasNextPage.value = data['next_page_url'] != null;
          hasPrevPage.value = data['prev_page_url'] != null;
        } else if (data is List) {
          // دعم للاستجابة القديمة (قائمة مباشرة)
          pendingUsers.value = data;
        } else if (data['pending_users'] != null) {
          // دعم للاستجابة القديمة (مفتاح pending_users)
          pendingUsers.value = data['pending_users'];
        }
      } else if (response.statusCode == 401) {
        _showErrorSnackbar("انتهت صلاحية الجلسة، يرجى تسجيل الدخول مرة أخرى");
        // يمكن إضافة إعادة توجيه لصفحة تسجيل الدخول هنا
      } else {
        _showErrorSnackbar("فشل جلب البيانات: ${response.statusCode}");
      }
    } catch (e) {
      _showErrorSnackbar("خطأ في الاتصال بالسيرفر");
      print("Error fetching users: $e");
    } finally {
      isLoading(false);
    }
  }

  // الانتقال للصفحة التالية
  Future<void> nextPage() async {
    if (hasNextPage.value && currentPage.value < lastPage.value) {
      await fetchPendingUsers(page: currentPage.value + 1);
    }
  }

  // الانتقال للصفحة السابقة
  Future<void> previousPage() async {
    if (hasPrevPage.value && currentPage.value > 1) {
      await fetchPendingUsers(page: currentPage.value - 1);
    }
  }

  // الانتقال لصفحة محددة
  Future<void> goToPage(int page) async {
    if (page >= 1 && page <= lastPage.value) {
      await fetchPendingUsers(page: page);
    }
  }

  // 2. الموافقة على مستخدم
  Future<void> approveUser(int id) async {
    try {
      final headers = await _getHeaders();
      var response = await http.post(
        Uri.parse("$baseUrl/approve-user/$id"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // إعادة تحميل الصفحة الحالية
        await fetchPendingUsers(page: currentPage.value);
        Get.snackbar(
          "نجاح",
          "تمت الموافقة على الحساب بنجاح",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        _showErrorSnackbar("فشل في إتمام العملية");
      }
    } catch (e) {
      _showErrorSnackbar("حدث خطأ غير متوقع");
    }
  }

  // 3. رفض مستخدم
  Future<void> rejectUser(int id) async {
    try {
      final headers = await _getHeaders();
      var response = await http.post(
        Uri.parse("$baseUrl/reject-user/$id"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // إعادة تحميل الصفحة الحالية
        await fetchPendingUsers(page: currentPage.value);
        Get.snackbar(
          "تم الرفض",
          "تم حذف طلب التسجيل بنجاح",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      } else {
        _showErrorSnackbar("فشل في رفض الطلب");
      }
    } catch (e) {
      _showErrorSnackbar("حدث خطأ في الاتصال");
    }
  }

  // دالة مختصرة لعرض التنبيهات الحمراء
  void _showErrorSnackbar(String msg) {
    Get.snackbar(
      "تنبيه",
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
  }

  void refreshAfterRegister() {
    fetchPendingUsers();
  }
}
