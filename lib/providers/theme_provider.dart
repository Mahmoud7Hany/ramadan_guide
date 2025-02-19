import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _key = 'theme_mode';
  bool _isDarkMode = false;
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  bool get isDarkMode => _isDarkMode;
  bool get isInitialized => _isInitialized;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _isDarkMode = _prefs.getBool(_key) ?? false;
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('خطأ في تحميل الثيم: $e');
      // في حالة حدوث خطأ، نستخدم القيمة الافتراضية
      _isDarkMode = false;
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    try {
      _isDarkMode = !_isDarkMode;
      await _prefs.setBool(_key, _isDarkMode);
      notifyListeners();
    } catch (e) {
      debugPrint('خطأ في حفظ الثيم: $e');
      // إعادة القيمة إلى ما كانت عليه في حالة فشل الحفظ
      _isDarkMode = !_isDarkMode;
      notifyListeners();
    }
  }

  // إعادة تعيين الثيم إلى آخر قيمة محفوظة
  Future<void> resetToSavedTheme() async {
    try {
      final savedMode = _prefs.getBool(_key) ?? false;
      if (_isDarkMode != savedMode) {
        _isDarkMode = savedMode;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('خطأ في استعادة الثيم: $e');
    }
  }
}