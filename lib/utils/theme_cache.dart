import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCache {
  static const String _themeKey = 'theme_mode';
  static ThemeCache? _instance;
  
  final Map<String, Color> _colorCache = {};
  ThemeData? _lightTheme;
  ThemeData? _darkTheme;
  bool? _cachedTheme;

  static ThemeCache get instance => _instance ??= ThemeCache();

  Future<bool> loadTheme() async {
    if (_cachedTheme != null) return _cachedTheme!;
    
    final prefs = await SharedPreferences.getInstance();
    _cachedTheme = prefs.getBool(_themeKey) ?? false;
    return _cachedTheme!;
  }

  Future<void> saveTheme(bool isDark) async {
    if (_cachedTheme == isDark) return;
    
    _cachedTheme = isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }

  ThemeData? getCachedTheme(bool isDark) => isDark ? _darkTheme : _lightTheme;

  void cacheTheme(bool isDark, ThemeData theme) {
    if (isDark) {
      _darkTheme = theme;
    } else {
      _lightTheme = theme;
    }
  }

  Color? getCachedColor(String key) => _colorCache[key];

  void cacheColor(String key, Color color) => _colorCache[key] = color;

  void clearCache() {
    _cachedTheme = null;
    _colorCache.clear();
    _lightTheme = null;
    _darkTheme = null;
  }

  bool get hasCachedTheme => _cachedTheme != null;
  bool get hasColorCache => _colorCache.isNotEmpty;
  bool get hasThemeDataCache => _lightTheme != null || _darkTheme != null;
}