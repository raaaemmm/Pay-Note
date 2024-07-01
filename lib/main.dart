import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pay_note/controllers/current_user_controller.dart';
import 'package:pay_note/controllers/theme_mode_controller.dart';
import 'package:pay_note/controllers/translate_controller.dart';
import 'package:pay_note/firebase_options.dart';
import 'package:pay_note/translations/language_translation.dart';
import 'package:pay_note/views/auths/show_loading_screen.dart';
import 'package:pay_note/views/auths/sign_in_screen.dart';
import 'package:pay_note/views/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // store data into local storage device (Offline storage - Local)
  await SharedPreferences.getInstance();

  // firebase service (Online storage - Cloud)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _translationController = Get.put(TranslateController());
  final _themeModeController = Get.put(ThemeModeController());
  final _userController = Get.put(CurrentUserController());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeModeController>(
      builder: (_) {
        return GetMaterialApp(
          title: 'Pay Note - Tracking your dialy Income & Expense',
          debugShowCheckedModeBanner: false,
          theme: _themeModeController.theme,
          translations: LanguageTranslation(),
          locale: _translationController.locale,
          fallbackLocale: _translationController.locale,
          home: GetBuilder<CurrentUserController>(
            builder: (_) => _userController.isLoading ? const ShowLoadingScreen() : _userController.currentUser != null ? Home() : SignInScreen(),
          ),
        );
      },
    );
  }
}
