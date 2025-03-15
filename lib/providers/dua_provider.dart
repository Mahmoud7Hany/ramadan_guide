import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dua.dart';

class DuaProvider with ChangeNotifier {
  List<Dua> _duas = [];
  SharedPreferences? _prefs;
  static const String _duasKey = 'duas';
  static const String _firstRunKey = 'duas_first_run';

  List<Dua> get duas => _duas;
  List<Dua> get favoriteDuas => _duas.where((dua) => dua.isFavorite).toList();
  
  List<Dua> duasByCategory(String category) {
    if (category == 'favorites') {
      return favoriteDuas;
    }
    return _duas;
  }

  DuaProvider() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    final isFirstRun = _prefs?.getBool(_firstRunKey) ?? true;
    
    if (isFirstRun) {
      await _addDefaultDuas();
      await _prefs?.setBool(_firstRunKey, false);
    } else {
      _loadDuas();
    }
  }

  Future<void> _addDefaultDuas() async {
    final now = DateTime.now();
    final defaultDuas = [
      Dua(
        id: '${now.millisecondsSinceEpoch}',
        text: 'اللَّهُمَّ لَكَ صُمْتُ، وَعَلَى رِزْقِكَ أَفْطَرْتُ',
        description: 'دعاء الإفطار',
        createdAt: now,
      ),
      Dua(
        id: '${now.millisecondsSinceEpoch + 1}',
        text: 'اللهم إنك عفو تحب العفو فاعف عني',
        description: 'دعاء ليلة القدر',
        createdAt: now,
      ),
      Dua(
        id: '${now.millisecondsSinceEpoch + 2}',
        text: 'اللهم اجعل صيامي فيه صيام الصائمين وقيامي فيه قيام القائمين',
        description: 'دعاء الصيام',
        createdAt: now,
      ),
    ];

    _duas = defaultDuas;
    await _saveDuas();
    notifyListeners();
  }

  void _loadDuas() {
    try {
      final duasJson = _prefs?.getStringList(_duasKey) ?? [];
      _duas = duasJson.map((json) => Dua.fromJson(jsonDecode(json))).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading duas: $e');
      _duas = [];
      notifyListeners();
    }
  }

  Future<void> _saveDuas() async {
    try {
      final duasJson = _duas.map((dua) => jsonEncode(dua.toJson())).toList();
      await _prefs?.setStringList(_duasKey, duasJson);
    } catch (e) {
      debugPrint('Error saving duas: $e');
    }
  }

  Future<void> addDua(String text, String description) async {
    final dua = Dua(
      id: DateTime.now().toString(),
      text: text,
      description: description,
      createdAt: DateTime.now(),
    );
    _duas.add(dua);
    await _saveDuas();
    notifyListeners();
  }

  Future<void> updateDua(String id, String text, String description) async {
    final index = _duas.indexWhere((dua) => dua.id == id);
    if (index != -1) {
      _duas[index] = _duas[index].copyWith(
        text: text,
        description: description,
      );
      await _saveDuas();
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String id) async {
    final index = _duas.indexWhere((dua) => dua.id == id);
    if (index != -1) {
      _duas[index] = _duas[index].copyWith(
        isFavorite: !_duas[index].isFavorite,
      );
      await _saveDuas();
      notifyListeners();
    }
  }

  Future<void> deleteDua(String id) async {
    _duas.removeWhere((dua) => dua.id == id);
    await _saveDuas();
    notifyListeners();
  }
}