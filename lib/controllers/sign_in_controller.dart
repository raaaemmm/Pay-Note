import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pay_note/services/firebase_service.dart';
import 'package:pay_note/views/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInController extends GetxController {
  final _firebaseService = FirebaseService();
  bool isLoading = false;
  bool obscureText = true;

  // sign in
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      update();

      // perform sign-in
      await _firebaseService.signIn(email: email, password: password);

      debugPrint('Signed in success...!');
      showMessage('signed in success'.tr, Colors.blue);
      Get.offAll(() => Home());
      
    } on FirebaseAuthException catch (e) {
      debugPrint('Error signing in: 👉 ${e.code}');
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'Invalid email address!';
          break;
        case 'user-disabled':
          errorMessage = 'This user has been disabled!';
          break;
        case 'user-not-found':
          errorMessage = 'No user found with this email!';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password!';
          break;
        case 'invalid-credential':
          errorMessage = 'The supplied auth credential is incorrect or has expired!';
          break;
        default:
          errorMessage = 'An unknown error occurred! Please try again...!';
      }
      showMessage('Oops! $errorMessage', Colors.red);
    } catch (e) {
      debugPrint('Error signing in: 👉 $e');
      showMessage('failed to sign in. please try again'.tr, Colors.red);
    } finally {
      isLoading = false;
      update();
    }
  }

  // password show and hide
  void showAndHidePassword() {
    obscureText = !obscureText;
    update();
  }

  // show message
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
