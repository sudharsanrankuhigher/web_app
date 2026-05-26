import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webapp/app/app.locator.dart';

class ThemeService extends ChangeNotifier {
  static final ThemeService instance = ThemeService._internal();

  ThemeService._internal() {
    _loadThemePreference();
  }

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void _loadThemePreference() {
    try {
      final prefs = locator<SharedPreferences>();
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    } catch (e) {
      debugPrint('Error loading theme preference: $e');
      _isDarkMode = false;
    }
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    try {
      final prefs = locator<SharedPreferences>();
      await prefs.setBool('isDarkMode', _isDarkMode);
    } catch (e) {
      debugPrint('Error saving theme preference: $e');
    }
  }

  Future<void> setDarkMode(bool enable) async {
    if (_isDarkMode == enable) return;
    _isDarkMode = enable;
    notifyListeners();
    try {
      final prefs = locator<SharedPreferences>();
      await prefs.setBool('isDarkMode', _isDarkMode);
    } catch (e) {
      debugPrint('Error saving theme preference: $e');
    }
  }
}
