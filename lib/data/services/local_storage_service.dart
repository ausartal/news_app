import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/article.dart';

class LocalStorageService {
  LocalStorageService(this._preferences);

  final SharedPreferences _preferences;

  static const _bookmarksKey = 'bookmarks_key';
  static const _themeKey = 'theme_is_dark';

  Future<void> saveBookmarks(List<Article> articles) async {
    final encoded =
        jsonEncode(articles.map((article) => article.toJson()).toList());
    await _preferences.setString(_bookmarksKey, encoded);
  }

  List<Article> loadBookmarks() {
    final raw = _preferences.getString(_bookmarksKey);
    if (raw == null || raw.isEmpty) {
      return <Article>[];
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Article.fromStoredJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveThemeMode(bool isDarkMode) async {
    await _preferences.setBool(_themeKey, isDarkMode);
  }

  bool loadThemeMode() => _preferences.getBool(_themeKey) ?? false;

  Future<void> saveCache(String key, Map<String, dynamic> payload) async {
    await _preferences.setString(key, jsonEncode(payload));
  }

  Map<String, dynamic>? loadCache(String key) {
    final raw = _preferences.getString(key);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    return null;
  }
}
