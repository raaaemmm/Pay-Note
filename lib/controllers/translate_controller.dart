import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranslateController extends GetxController {
  late SharedPreferences prefs;

  @override
  void onInit() {
    super.onInit();
    _loadLanguageFromLocal();
  }

  // load language from SharedPreferences
  Future<void> _loadLanguageFromLocal() async {
    prefs = await SharedPreferences.getInstance();
    update();
  }

  // check if the current language is English
  bool get isEnglish {
    return prefs.getString('language') == 'en';
  }

  // get the current locale
  Locale get locale {
    if (isEnglish) {
      return const Locale('en', 'US');
    } else {
      return const Locale('km', 'KH');
    }
  }

  // change the language and save it to SharedPreferences
  Future<void> changeLanguage() async {
    if (isEnglish) {
      await prefs.setString('language', 'km');
    } else {
      await prefs.setString('language', 'en');
    }
    update();
    Get.updateLocale(locale);
  }
}
