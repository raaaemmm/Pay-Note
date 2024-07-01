import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pay_note/services/firebase_service.dart';
import 'package:pay_note/views/auths/sign_in_screen.dart';

class SignUpController extends GetxController {
  
  final _firebaseService = FirebaseService();
  File? userProfile; 
  bool isLoading = false;
  bool obscureText = true;

  // default user profile image
  final String defaultProfilePhotoUrl = 'https://pbs.twimg.com/media/FO4RRcaWQAELKS7.jpg';

  Future<void> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      isLoading = true;
      update();

      // check if user selected a profile image
      String profilePhotoUrl;
      if (userProfile == null) {
        profilePhotoUrl = defaultProfilePhotoUrl; // use default profile photo
      } else {
        // upload user profile image and get URL
        String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        profilePhotoUrl = (await _firebaseService.uploadUserImage(
          fileName,
          userProfile!,
        )) ?? defaultProfilePhotoUrl; // use default profile photo if upload fails
      }

      // Perform sign-up with profile photo URL
      await _firebaseService.signUp(
        name: name,
        email: email,
        phone: phone,
        password: password,
        profilePhotoUrl: profilePhotoUrl,
      );

      debugPrint('Signed up success...!');
      showMessage('signed up success'.tr, Colors.blue);
      Get.off(()=> SignInScreen());  // Signed-up succeeds, get back to sign-in screen
    } catch (e) {
      debugPrint('Error signing up: 👉 $e');
      showMessage('failed to sign up. please try again'.tr, Colors.red);
    } finally {
      isLoading = false;
      update();
    }
  }

  // Show dialog to choose image from gallery or camera
  void selectImage() {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: SizedBox(
            height: 115.0,
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    getImageCamera();
                    Get.back();
                  },
                  leading: const Icon(Icons.camera_alt),
                  title: Text(
                    'camera'.tr,
                    style: GoogleFonts.kantumruyPro(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    getImageGallery();
                    Get.back();
                  },
                  leading: const Icon(Icons.image),
                  title: Text(
                    'gallery'.tr,
                    style: GoogleFonts.kantumruyPro(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Get image from Gallery
  void getImageGallery() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        userProfile = File(pickedFile.path);
        print('Selected image: $userProfile');
      } else {
        print('No image selected...!');
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
    }
    update();
  }

  // Get image from Camera
  void getImageCamera() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );
      if (pickedFile != null) {
        userProfile = File(pickedFile.path);
        print('Selected image: $userProfile');
      } else {
        print('No image selected...!');
      }
    } catch (e) {
      print('Error picking image from camera: $e');
    }
    update();
  }

  // Password show and hide
  void showAndHidePassword() {
    obscureText = !obscureText;
    update();
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
