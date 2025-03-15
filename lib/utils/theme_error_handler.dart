import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeErrorHandler {
  static const String _themeKey = 'theme_mode';
  static const String _backupKey = 'theme_mode_backup';

  static Future<bool> validateThemeState(bool currentTheme) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getBool(_themeKey);
      return savedTheme == null || savedTheme == currentTheme;
    } catch (e) {
      debugPrint('Theme validation error: $e');
      return false;
    }
  }

  static Future<bool> recoverThemeState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final platformBrightness = View.of(WidgetsBinding.instance.rootElement!).platformDispatcher.platformBrightness;
      final systemDarkMode = platformBrightness == Brightness.dark;
      
      await prefs.setBool(_themeKey, systemDarkMode);
      return systemDarkMode;
    } catch (e) {
      debugPrint('Theme recovery error: $e');
      return false;
    }
  }

  static Future<void> backupThemeState(bool currentTheme) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_backupKey, currentTheme);
    } catch (e) {
      debugPrint('Theme backup error: $e');
    }
  }

  static Future<bool?> restoreFromBackup() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_backupKey);
    } catch (e) {
      debugPrint('Theme backup restoration error: $e');
      return null;
    }
  }
}