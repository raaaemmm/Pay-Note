import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pay_note/views/screens/home_screen.dart';
import 'package:pay_note/views/screens/setting_screen.dart';
import 'package:pay_note/views/screens/state_screen.dart';

class HomeController extends GetxController {
  int defaultIndex = 0;

  void selectedIndex(int index){
    defaultIndex = index;
    update();
  }

  // screen
  List<Widget> screens = [
    HomeScreen(),
    StateScreen(),
    Settingscreen(),
  ];
}