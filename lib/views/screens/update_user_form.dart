import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pay_note/controllers/current_user_controller.dart';
import 'package:pay_note/controllers/theme_mode_controller.dart';
import 'package:pay_note/models/user_model.dart';

class UpdateUserForm extends StatelessWidget {
  UpdateUserForm({super.key, required this.user});

  final UserModel user;
  final _userController = Get.put(CurrentUserController());
  final _themeModeController = Get.put(ThemeModeController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        body: GetBuilder<CurrentUserController>(
          initState: (state) {
            _userController.listenToAuthChanges();
          },
          builder: (_) {
            return Form(
              key: _userController.formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    
                    // center dot
                    const SizedBox(height: 15.0),
                    Center(
                      child: Container(
                        height: 5.0,
                        width: MediaQuery.of(context).size.width / 3.5,
                        decoration: BoxDecoration(
                          color: _themeModeController.isDark
                              ? Colors.white.withOpacity(0.1)
                              : Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),

                    // select photo
                    const SizedBox(height: 70.0),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          _userController.selectImage();
                        },
                        child: _userController.userProfile != null
                            ? Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    height: 160.0,
                                    width: 160.0,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: _themeModeController.isDark
                                            ? Colors.white
                                            : Theme.of(context).primaryColor,
                                        width: 3.0,
                                      ),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: FileImage(
                                          _userController.userProfile!,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 5.0,
                                    right: 5.0,
                                    child: Container(
                                      height: 40.0,
                                      width: 40.0,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                        shape: BoxShape.circle,
                                        color: _themeModeController.isDark
                                            ? Colors.white
                                            : Theme.of(context).primaryColor,
                                      ),
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 20.0,
                                        color: _themeModeController.isDark
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Hero(
                                tag: _userController.currentUser?.id.toString() ?? '',
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      height: 160.0,
                                      width: 160.0,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: _themeModeController.isDark
                                              ? Colors.white
                                              : Theme.of(context).primaryColor,
                                          width: 3.0,
                                        ),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: CachedNetworkImageProvider(
                                            _userController.currentUser?.profilePhotoUrl ?? '',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 5.0,
                                      right: 5.0,
                                      child: Container(
                                        height: 40.0,
                                        width: 40.0,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.white,
                                          ),
                                          shape: BoxShape.circle,
                                          color: _themeModeController.isDark
                                              ? Colors.white
                                              : Theme.of(context).primaryColor,
                                        ),
                                        child: Icon(
                                          Icons.camera_alt,
                                          size: 20.0,
                                          color: _themeModeController.isDark
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),

                    // name
                    const SizedBox(height: 60.0),
                    TextFormField(
                      controller: _userController.nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(
                          Icons.person,
                          color: _themeModeController.isDark
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                        ),
                        hintText: 'name'.tr,
                        hintStyle: GoogleFonts.kantumruyPro(
                          fontSize: 15.0,
                          color: _themeModeController.isDark
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                        ),
                        filled: true,
                        fillColor: _themeModeController.isDark
                            ? Colors.white.withOpacity(0.1)
                            : Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'oops! please enter your name'.tr;
                        } else {
                          return null;
                        }
                      },
                    ),

                    // phone number
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _userController.phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(
                          Icons.phone_android,
                          color: _themeModeController.isDark
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                        ),
                        hintText: 'phone'.tr,
                        hintStyle: GoogleFonts.kantumruyPro(
                          fontSize: 15.0,
                          color: _themeModeController.isDark
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                        ),
                        filled: true,
                        fillColor: _themeModeController.isDark
                            ? Colors.white.withOpacity(0.1)
                            : Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'oops! please enter your phone'.tr;
                        } else {
                          return null;
                        }
                      },
                    ),

                    // update button
                    const SizedBox(height: 15.0),
                    GestureDetector(
                      onTap: () {
                        if (_userController.formKey.currentState!.validate()) {
                          _userController.updateUser(
                            name: _userController.nameController.text.trim(),
                            phone: _userController.phoneController.text.trim(),
                          ).whenComplete(
                            (){
                              _userController.nameController.clear();
                              _userController.phoneController.clear();
                              Get.back();
                            }
                          );
                        }
                      },
                      child: Container(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: _userController.isUpdating
                            ? LoadingAnimationWidget.prograssiveDots(
                              color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                              size: 25.0,
                            )
                            : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'update'.tr,
                                  style: GoogleFonts.kantumruyPro(
                                    color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                )
                              ],
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
