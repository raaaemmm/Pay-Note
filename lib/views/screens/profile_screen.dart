import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pay_note/controllers/current_user_controller.dart';
import 'package:pay_note/controllers/theme_mode_controller.dart';
import 'package:pay_note/models/user_model.dart';
import 'package:pay_note/views/screens/update_user_form.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key, required this.user});

  final UserModel user;
  final _userController = Get.put(CurrentUserController());
  final _themeModeController = Get.put(ThemeModeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _themeModeController.isDark
            ? Colors.transparent
            : Theme.of(context).primaryColor,
        scrolledUnderElevation: 0.0,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
        title: Text(
          'profile'.tr,
          style: GoogleFonts.kantumruyPro(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundColor: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Colors.white,
            child: IconButton(
              icon: Icon(
                Icons.edit,
                color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
              ),
              onPressed: () {
                showModalBottomSheet(
                  isDismissible: true,
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return UpdateUserForm(user: user);
                  },
                );
              },
            ),
          ),
          const SizedBox(width: 15.0),
        ],
      ),
      body: GetBuilder<CurrentUserController>(
        initState: (state) {
          _userController.listenToAuthChanges();
        },
        builder: (_) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [

                // profile & cover photo
                Stack(
                  alignment: Alignment.bottomLeft,
                  clipBehavior: Clip.none,
                  children: [

                    // cover
                    Container(
                      alignment: Alignment.center,
                      height: 220.0,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                      ),
                      child: Shimmer.fromColors(
                        baseColor: Theme.of(context).primaryColor,
                        highlightColor: Colors.pink,
                        child: Image.asset(
                          'images/Money.png',
                          height: 100.0,
                          width: 100.0,
                        ),
                      ),
                    ),

                    // profile
                    Positioned(
                      left: 15.0,
                      bottom: - 70.0,
                      child: Hero(
                        tag: _userController.currentUser?.id.toString() ?? '',
                        child: GestureDetector(
                          onTap: () {
                            Get.to(
                              () => Stack(
                                alignment: Alignment.topRight,
                                children: [
                                              
                                  // view photo
                                  Hero(
                                    tag: _userController.currentUser?.id.toString() ?? '',
                                    child: PhotoView(
                                      loadingBuilder: (context, event) {
                                        return Center(
                                          child: LoadingAnimationWidget.prograssiveDots(
                                            color: Colors.white,
                                            size: 30.0,
                                          ),
                                        );
                                      },
                                      imageProvider: CachedNetworkImageProvider(
                                        _userController.currentUser?.profilePhotoUrl ?? '',
                                      ),
                                    ),
                                  ),
                                              
                                  // group button
                                  GetBuilder<CurrentUserController>(
                                    builder: (_) {
                                      return SafeArea(
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                                            
                                              // share photo
                                              CircleAvatar(
                                                backgroundColor: Colors.white,
                                                child: IconButton(
                                                  onPressed: () {
                                                    _userController.shareImage(user.profilePhotoUrl ?? '');
                                                  },
                                                  icon: Center(
                                                    child: _userController.isSharing
                                                        ? LoadingAnimationWidget.prograssiveDots(
                                                            color: Theme.of(context).primaryColor,
                                                            size: 20.0,
                                                          )
                                                        : Icon(
                                                            Icons.share,
                                                            size: 20.0,
                                                            color: Theme.of(context).primaryColor,
                                                          ),
                                                  ),
                                                ),
                                              ),
                                                            
                                              // save photo
                                              const SizedBox(width: 8.0),
                                              CircleAvatar(
                                                backgroundColor: Colors.white,
                                                child: IconButton(
                                                  onPressed: () {
                                                    _userController.saveImage(user.profilePhotoUrl ?? '');
                                                  },
                                                  icon: Center(
                                                    child: _userController.isDownloading
                                                        ? LoadingAnimationWidget
                                                            .prograssiveDots(
                                                            color: Theme.of(context).primaryColor,
                                                            size: 20.0,
                                                          )
                                                        : Icon(
                                                            Icons.save_alt,
                                                            color: Theme.of(context).primaryColor,
                                                          ),
                                                  ),
                                                ),
                                              ),
                                                            
                                              // back
                                              const SizedBox(width: 8.0),
                                              CircleAvatar(
                                                backgroundColor: Colors.white,
                                                child: IconButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  icon: Icon(
                                                    Icons.close,
                                                    size: 25.0,
                                                    color: Theme.of(context).primaryColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  )
                                ],
                              ),
                            );
                          },
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
                                    Icons.image,
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

                    // user name & email
                    Positioned(
                      bottom: - 60.0,
                      left: 190.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // user name
                          Text(
                            _userController.currentUser?.name ?? '',
                            style: GoogleFonts.kantumruyPro(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: _themeModeController.isDark
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                            ),
                          ),

                          // user email
                          Text(
                            _userController.currentUser?.email ?? '',
                            style: GoogleFonts.kantumruyPro(
                              fontSize: 15.0,
                              color: _themeModeController.isDark
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),


                // group info
                const SizedBox(height: 90.0),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [

                      // phone number
                      const SizedBox(height: 30.0),
                      Container(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: _themeModeController.isDark
                              ? Colors.white.withOpacity(0.1)
                              : Theme.of(context).primaryColor.withOpacity(0.1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // left content
                            Row(
                              children: [
                                Icon(
                                  Icons.phone_android,
                                  color: _themeModeController.isDark
                                      ? Colors.white
                                      : Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 10.0),
                                Text(
                                  'phone'.tr,
                                  style: GoogleFonts.kantumruyPro(
                                    fontSize: 15.0,
                                    color: _themeModeController.isDark
                                        ? Colors.white
                                        : Theme.of(context).primaryColor,
                                  ),
                                )
                              ],
                            ),

                            // right content
                            Text(
                              _userController.currentUser?.phone ?? '',
                              style: GoogleFonts.kantumruyPro(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: _themeModeController.isDark
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // delete account
                      const SizedBox(height: 10.0),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return GetBuilder<CurrentUserController>(
                                builder: (_) {
                                  return AlertDialog(
                                    title: Text(
                                      'confirmation'.tr,
                                      style: GoogleFonts.kantumruyPro(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    content: Text(
                                      'are you sure you want to Delete your account? Your data will delete, and can\'t restore it back'.tr,
                                      style: GoogleFonts.kantumruyPro(
                                        fontSize: 15.0,
                                        color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text(
                                          'no'.tr,
                                          style: GoogleFonts.kantumruyPro(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.pink,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _userController.deleteUserAccount();
                                        },
                                        child: Text(
                                          _userController.isDeleting ? 'deleting'.tr : 'yes'.tr,
                                          style: GoogleFonts.kantumruyPro(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15.0),
                          height: 50.0,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: _themeModeController.isDark
                                ? Colors.white.withOpacity(0.1)
                                : Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete,
                                color: _themeModeController.isDark
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                'delete account'.tr,
                                style: GoogleFonts.kantumruyPro(
                                  fontSize: 15.0,
                                  color: _themeModeController.isDark
                                      ? Colors.white
                                      : Theme.of(context).primaryColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      // sign out
                      const SizedBox(height: 10.0),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return GetBuilder<CurrentUserController>(
                                builder: (_) {
                                  return AlertDialog(
                                    title: Text(
                                      'confirmation'.tr,
                                      style: GoogleFonts.kantumruyPro(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    content: Text(
                                      'are you sure you want to Sign Out of your account'.tr,
                                      style: GoogleFonts.kantumruyPro(
                                        fontSize: 15.0,
                                        color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text(
                                          'no'.tr,
                                          style: GoogleFonts.kantumruyPro(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.pink,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _userController.signOutUser();
                                          Get.back();
                                        },
                                        child: Text(
                                          _userController.isSigningOut ? 'signing out'.tr : 'yes'.tr,
                                          style: GoogleFonts.kantumruyPro(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15.0),
                          height: 50.0,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: _themeModeController.isDark
                                ? Colors.white.withOpacity(0.1)
                                : Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.logout,
                                color: _themeModeController.isDark
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                'sign out'.tr,
                                style: GoogleFonts.kantumruyPro(
                                  fontSize: 15.0,
                                  color: _themeModeController.isDark
                                      ? Colors.white
                                      : Theme.of(context).primaryColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
