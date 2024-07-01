import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pay_note/services/firebase_service.dart';

class ForgotPasswordController extends GetxController {

  final _firebaseService = FirebaseService();

  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isClearText = false;

  // real time show & hide clear text button
  void showAndHideClearText(bool isVisible) {
    isClearText = isVisible;
    update();
  }

  void clearText(){
    emailController.clear();
    isClearText = false;
    update();
  }

  // forgot password
  Future<void> resetPassword({required String email}) async {
    try {
      isLoading = true;
      update();

      await _firebaseService.forgotPassword(email: email);

      showMessage('${'password reset email sent to'.tr}: $email', Colors.green);
      print('Password reset email sent to: 👉 $email');
    } catch (e) {
      showMessage('${'error sending password reset email'.tr}: $e', Colors.red);
      debugPrint("Error sending password reset email: 👉 $e");
    } finally {
      isLoading = false;
      update();
    }
  }

    // Show message
  void showMessage(String msg, Color color) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}