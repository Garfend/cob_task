import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for caching data using SharedPreferences
class CacheService {
  final SharedPreferences _prefs;

  CacheService(this._prefs);

  // Keys for caching
  static const String _themeKey = 'theme_mode';

  /// 0 = light, 1 = dark, 2 = system
  Future<bool> saveThemeMode(int mode) async {
    return await _prefs.setInt(_themeKey, mode);
  }

  int? getThemeMode() {
    return _prefs.getInt(_themeKey);
  }

  Future<bool> cacheJson(String key, Map<String, dynamic> data) async {
    final jsonString = json.encode(data);
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final saved = await _prefs.setString(key, jsonString);
    await _prefs.setInt('${key}_time', timestamp);

    return saved;
  }

  Map<String, dynamic>? getCachedJson(String key) {
    final jsonString = _prefs.getString(key);
    if (jsonString == null) return null;

    try {
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  bool isCacheValid(String key, Duration maxAge) {
    final timestamp = _prefs.getInt('${key}_time');
    if (timestamp == null) return false;

    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final age = now.difference(cacheTime);

    return age < maxAge;
  }

  Future<bool> clearCache(String key) async {
    await _prefs.remove('${key}_time');
    return await _prefs.remove(key);
  }

  Future<bool> clearAllCache() async {
    return await _prefs.clear();
  }

  Future<bool> saveString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<bool> saveInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  Future<bool> saveBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }
}
