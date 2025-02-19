import 'package:flutter/material.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class ThemePreloader {
  static const String _themeKey = 'theme_mode';
  static ThemePreloader? _instance;
  
  final _completer = Completer<bool>();
  bool? _preloadedTheme;
  bool _isPreloading = false;

  static ThemePreloader get instance => _instance ??= ThemePreloader();

  Future<bool> get preloadedTheme => _completer.future;

  void startPreload() {
    if (!_completer.isCompleted && !_isPreloading) {
      _isPreloading = true;
      _preloadTheme();
    }
  }

  Future<void> _preloadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _preloadedTheme = prefs.getBool(_themeKey);
      
      if (!_completer.isCompleted) {
        _completer.complete(_preloadedTheme ?? false);
      }
    } catch (e) {
      debugPrint('Theme preload error: $e');
      if (!_completer.isCompleted) {
        _completer.complete(false);
      }
    } finally {
      _isPreloading = false;
    }
  }

  void reset() {
    if (!_completer.isCompleted) {
      _preloadedTheme = null;
    }
  }

  bool get isPreloaded => _preloadedTheme != null;
}