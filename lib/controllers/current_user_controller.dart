import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pay_note/controllers/state_controller.dart';
import 'package:pay_note/controllers/transaction_controller.dart';
import 'package:pay_note/services/firebase_service.dart';
import 'package:pay_note/services/transaction_service.dart';
import 'package:pay_note/views/auths/sign_in_screen.dart';
import 'package:share_plus/share_plus.dart';
import '../models/user_model.dart';

class CurrentUserController extends GetxController {
  
  final _auth = FirebaseAuth.instance;
  final _transactionService = TransactionService();
  final _firebaseService = FirebaseService();

  File? userProfile; 
  bool isLoading = false;
  bool isUpdating = false;
  bool isDownloading = false;
  bool isSharing = false;
  bool isDeleting = false;
  bool isSigningOut = false;
  UserModel? currentUser;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    listenToAuthChanges();
  }

  void listenToAuthChanges() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        initCurrentUser(user.uid);
      } else {
        currentUser = null;
        update();
      }
    });
  }

  Future<void> initCurrentUser(String userId) async {
    try {
      isLoading = true;
      update();

      UserModel? userModel = await _firebaseService.getUser(userId: userId);
      currentUser = userModel;
      if (currentUser != null) {

        nameController.text = currentUser!.name ?? '';
        phoneController.text = currentUser!.phone ?? '';
        
        Get.put(TransactionController()).getTransactionsForSelectedDate();
        Get.put(StateController()).fetchTransactionsByMonthAndYear();
      }
      update();

    } catch (e) {
      debugPrint("Error initializing current user: 👉 $e");
      currentUser = null;
      update();
    } finally {
      isLoading = false;
      update();
    }
  }
  
  //delete user account along with their data
  Future<void> deleteUserAccount() async {
    try {
      if (currentUser != null) {

        isDeleting = true;
        update();

        // delete all user categories
        await _transactionService.deleteAllCategories(
          userId: currentUser!.id.toString(),
        );

        // delete all user transactions
        await _transactionService.deleteAllTransactions(
          userId: currentUser!.id.toString(),
        );

        // delete user document from Firestore
        await _firebaseService.deleteUser(
          userId: currentUser!.id.toString(),
        );

        // delete user from Firebase Authentication
        await _firebaseService.deleteAuthUser();

        currentUser = null;
        update();

        showMessage('account deleted successfully'.tr, Colors.green);
        debugPrint('Account deleted successfully...!');
        Get.offAll(() => SignInScreen());
      } else {
        debugPrint('User not logged in...!');
      }
    } catch (e) {
      debugPrint("Error deleting user account: 👉 $e");
      showMessage('failed to delete account. please try again'.tr, Colors.red);
    } finally {
      isDeleting = false;
      update();
    }
  }


  Future<void> updateUser({
    required String name,
    required String phone,
  }) async {
    try {
      isUpdating = true;
      update();

      if (currentUser != null) {
        String profilePhotoUrl = currentUser!.profilePhotoUrl ?? '';

        if (userProfile != null) {
          // Upload new profile photo and get the URL
          String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
          profilePhotoUrl = await _firebaseService.uploadUpdatedUserProfile(
            imageFile: userProfile!,
            fileName: fileName,
          ) ?? profilePhotoUrl;
        }

        await _firebaseService.updateUser(
          userId: currentUser!.id.toString(),
          name: name,
          phone: phone,
          profilePhoto: profilePhotoUrl,
        );

        // Update local user model
        currentUser!.name = name;
        currentUser!.phone = phone;
        currentUser!.profilePhotoUrl = profilePhotoUrl;
        update();

        debugPrint('User data updated successfully!');
        showMessage('account updated successfully'.tr, Colors.green);
      } else {
        debugPrint('User not logged in...!');
      }
    } catch (e) {
      debugPrint("Error updating user data: 👉 $e");
      showMessage('failed to update account. please try again'.tr, Colors.red);
    } finally {
      isUpdating = false;
      update();
    }
  }

  Future<void> signOutUser() async {
    try {
      isSigningOut = true;
      update();

      await _firebaseService.signOut();
      currentUser = null;
      update();
      
      debugPrint('Signed out success!');
      Get.offAll(() => SignInScreen());
      showMessage('signed out success'.tr, Colors.green);

    } catch (e) {
      debugPrint("Error signing out: 👉 $e");
      showMessage('failed to sign out. please try again'.tr, Colors.red);
    } finally {
      isSigningOut = false;
      update();
    }
  }

  // save image
  Future<void> saveImage(String imageUrl) async {
    final dio = Dio();
    final String imageName = DateTime.now().toString();

    try {
      isDownloading = true;
      update();

      final response = await dio.get(
        imageUrl,
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(minutes: 1),
          validateStatus: (status) => status! < 500,
        ),
      );

      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 100,
        name: 'pay-note/$imageName',
      );

      print('Result: 👉 $result');
      Get.back();
      showMessage('image downloaded'.tr, Colors.teal);
    } catch (e) {
      print('Error saving image: $e');
      showMessage('error saving image'.tr, Colors.red);
    } finally {
      isDownloading = false;
      update();
    }
  }

    // share image
  Future<void> shareImage(String imageUrl) async {
    try {
      isSharing = true;
      update();

      final Dio dio = Dio();
      final Directory tempDir = await getTemporaryDirectory();
      final String imageName = DateTime.now().toString();
      final String tempFilePath = '${tempDir.path}/$imageName.jpg';

      await dio.download(imageUrl, tempFilePath);

      // share the temporary image file
      await Share.shareXFiles([XFile(tempFilePath)]);

      // after sharing, delete the temporary image file
      File(tempFilePath).deleteSync();
    } catch (e) {
      showMessage('error sharing image'.tr, Colors.red);
    } finally {
      isSharing = false;
      update();
    }
  }

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
