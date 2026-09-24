import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rental_appartment/data/models/booking.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const String _themeKey = 'user_theme_mode';
  static const String _localeKey = 'user_locale_code';

  final String _baseUrl = "http://10.130.61.158:8000/api";

  bool isLoading = false;
  List<Booking> _myBookings = [];
  List<Booking> get myBookings => _myBookings;

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> fetchMyBookings() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        debugPrint("⚠️ Token not found!");
        _myBookings = [];
        notifyListeners();
        return;
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/bookings'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        _myBookings = data.map((b) => Booking.fromMap(b)).toList();
        notifyListeners();
      } else if (response.statusCode == 401) {
        debugPrint("⚠️ Unauthenticated! Check token or backend.");
        _myBookings = [];
        notifyListeners();
      } else {
        debugPrint("⚠️ Error ${response.statusCode}: ${response.body}");
        _myBookings = [];
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Fetch Error: $e");
      _myBookings = [];
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _myBookings = [];
    notifyListeners();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final savedTheme = prefs.getString(_themeKey);
    _themeMode = (savedTheme == 'dark') ? ThemeMode.dark : ThemeMode.light;

    final savedLocale = prefs.getString(_localeKey);
    if (savedLocale != null) _locale = Locale(savedLocale);
  }

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _saveSetting(_themeKey, isDark ? 'dark' : 'light');
    notifyListeners();
  }

  void setLocale(String languageCode) {
    _locale = Locale(languageCode);
    _saveSetting(_localeKey, languageCode);
    notifyListeners();
  }

  Future<void> _saveSetting(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  String getLocalizedText(String en, String ar) {
    return _locale.languageCode == 'ar' ? ar : en;
  }
}
