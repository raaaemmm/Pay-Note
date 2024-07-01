import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pay_note/controllers/home_controller.dart';
import 'package:pay_note/controllers/theme_mode_controller.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final _homeController = Get.put(HomeController());
  final _themeModeController = Get.put(ThemeModeController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (_) {
        return Scaffold(
          body: _homeController.screens[_homeController.defaultIndex],
          bottomNavigationBar: CurvedNavigationBar(
            height: 60.0,
            backgroundColor: Colors.transparent,
            color: _themeModeController.isDark ? Colors.black.withOpacity(0.1) : Theme.of(context).primaryColor,
            buttonBackgroundColor: _themeModeController.isDark ? Colors.grey[800] : Theme.of(context).primaryColor,
            animationDuration: const Duration(milliseconds: 300),
            index: _homeController.defaultIndex,
            onTap: (newIndex) {
              _homeController.selectedIndex(newIndex);
            },
            items: [
              // Home icon
              Icon(
                Icons.home,
                color: _themeModeController.isDark ? Colors.white : Colors.white,
              ),
              
              // State icon
              Icon(
                Icons.bar_chart_rounded,
                color: _themeModeController.isDark ? Colors.white : Colors.white,
              ),
              
              // Setting icon
              Icon(
                Icons.settings,
                color: _themeModeController.isDark ? Colors.white : Colors.white,
              ),
            ],
          ),
        );
      }
    );
  }
}
