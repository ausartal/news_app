import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeControllerProvider =
    StateNotifierProvider<ThemeController, bool>((ref) {
  return ThemeController();
});

class ThemeController extends StateNotifier<bool> {
  ThemeController() : super(false) {
    _load();
  }

  Future<void> _load() async {
    final preferences = await SharedPreferences.getInstance();
    state = preferences.getBool(_key) ?? false;
  }

  Future<void> toggleTheme() async {
    state = !state;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_key, state);
  }

  static const String _key = 'theme_is_dark';
}
