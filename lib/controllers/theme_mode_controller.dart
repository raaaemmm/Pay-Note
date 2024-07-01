import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeController extends GetxController {
  late SharedPreferences prefs;

  @override
  void onInit() {
    super.onInit();
    _loadThemeModeFromLocal();
  }

  // load theme mode from SharedPreferences (local)
  Future<void> _loadThemeModeFromLocal() async {
    prefs = await SharedPreferences.getInstance();
    update();
  }

  // check if dark mode is enabled
  bool get isDark {
    return prefs.getBool('dark-mode') ?? false;
  }

  // get the current theme
  ThemeData get theme {
    if (isDark) {
      return ThemeData.dark(useMaterial3: true).copyWith(
        primaryColor: Colors.teal.shade900,
      );
    } else {
      return ThemeData.light(useMaterial3: true).copyWith(
        primaryColor: Colors.teal.shade900,
      );
    }
  }

  void changeThemeMode() {
    bool isDarkMode = !isDark;
    // Save the new theme mode to SharedPreferences
    prefs.setBool('dark-mode', isDarkMode);
    update();
  }
}
