import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pay_note/controllers/current_user_controller.dart';
import 'package:pay_note/controllers/excel_controller.dart';
import 'package:pay_note/controllers/theme_mode_controller.dart';
import 'package:pay_note/controllers/translate_controller.dart';
import 'package:pay_note/views/screens/profile_screen.dart';
import 'package:pay_note/views/screens/view_category_screen.dart';

class Settingscreen extends StatelessWidget {
  Settingscreen({super.key});

  final _translationController = Get.put(TranslateController());
  final _themeModeController = Get.put(ThemeModeController());
  final _userController = Get.put(CurrentUserController());
  final _excelController = Get.put(ExcelController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _themeModeController.isDark ? Colors.transparent : Theme.of(context).primaryColor,
        scrolledUnderElevation: 0.0,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'setting'.tr,
          style: GoogleFonts.kantumruyPro(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [

            // user profile
            GestureDetector(
              onTap: () {
                Get.to(()=> ProfileScreen(user: _userController.currentUser!));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 15.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    // left contents
                    Row(
                      children: [

                        // user profile photo
                        Hero(
                          tag: _userController.currentUser?.id.toString() ?? '',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: _userController.currentUser?.profilePhotoUrl ?? '',
                              height: 50.0,
                              width: 50.0,
                              placeholder: (context, url) {
                                return Center(
                                  child: LoadingAnimationWidget.prograssiveDots(
                                    color: _themeModeController.isDark
                                      ? Colors.white
                                      : Theme.of(context).primaryColor,
                                    size: 20.0,
                                  ),
                                );
                              },
                              errorWidget: (context, url, error) {
                                return const Center(
                                  child: Icon(
                                    Icons.error_outline,
                                    color: Colors.pink,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        // group text
                        const SizedBox(width: 15.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _userController.currentUser?.name ?? '',
                              style: GoogleFonts.kantumruyPro(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: _themeModeController.isDark? Colors.white : Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              'view your profile'.tr,
                              style: GoogleFonts.kantumruyPro(
                                fontSize: 15.0,
                                color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),

                    // right content
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                    )
                  ],
                ),
              ),
            ),

            // category
            const SizedBox(height: 10.0),
            GestureDetector(
              onTap: () {
                Get.to(()=> ViewCategoryScreen());
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 15.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    // left contents
                    Row(
                      children: [

                        // catgori icons
                        CircleAvatar(
                          backgroundColor: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
                          radius: 25.0,
                          child: Icon(
                            Icons.category_outlined,
                            color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                          ),
                        ),

                        // group text
                        const SizedBox(width: 15.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'category'.tr,
                              style: GoogleFonts.kantumruyPro(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              'view your categories'.tr,
                              style: GoogleFonts.kantumruyPro(
                                fontSize: 15.0,
                                color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),

                    // right content
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                    )
                  ],
                ),
              ),
            ),

            // change language
            const SizedBox(height: 10.0),
            GetBuilder<TranslateController>(
              builder: (_) {
                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      isDismissible: true,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return changeLanguages(context: context);
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 15.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                
                        // left contents
                        Row(
                          children: [
                
                            // language icon
                            CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                              radius: 25.0,
                              child: Image.asset(
                                _translationController.isEnglish ? 'images/English.png' : 'images/Khmer.png',
                                height: 30.0,
                                width: 30.0,
                              ),
                            ),
                
                            // group text
                            const SizedBox(width: 15.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'language'.tr,
                                  style: GoogleFonts.kantumruyPro(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                  ),
                                ),
                                Text(
                                  _translationController.isEnglish ? 'english'.tr : 'khmer'.tr,
                                  style: GoogleFonts.kantumruyPro(
                                    fontSize: 15.0,
                                    color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                
                        // right content
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                        )
                      ],
                    ),
                  ),
                );
              }
            ),

            // change theme mode
            const SizedBox(height: 10.0),
            GetBuilder<ThemeModeController>(
              builder: (_) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 15.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                                
                      // left contents
                      Row(
                        children: [
                                
                          // theme icon
                          CircleAvatar(
                            backgroundColor: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
                            radius: 25.0,
                            child: Icon(
                              _themeModeController.isDark ? Icons.dark_mode : Icons.light_mode,
                              color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                            ),
                          ),
                                
                          // group text
                          const SizedBox(width: 15.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'theme'.tr,
                                style: GoogleFonts.kantumruyPro(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                ),
                              ),
                              Text(
                                _themeModeController.isDark ? 'dark'.tr : 'light'.tr,
                                style: GoogleFonts.kantumruyPro(
                                  fontSize: 15.0,
                                  color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                                
                      // toggle button
                      Switch(
                        value: _themeModeController.isDark,
                        onChanged: (value) {
                          _themeModeController.changeThemeMode();
                        },
                        activeTrackColor: Colors.white,
                        inactiveTrackColor: Theme.of(context).primaryColor,
                        trackOutlineColor: const MaterialStatePropertyAll(Colors.white),

                        inactiveThumbColor: Colors.white,
                        activeColor: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                );
              }
            ),

            // export data to excel
            const SizedBox(height: 10.0),
            GetBuilder<ExcelController>(
              initState: (state) {
                _excelController.fetchTransactions();
              },
              builder: (_) {
                return GestureDetector(
                  onTap: () {
                    _excelController.exportTransactionsToExcel();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 15.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                
                        // left contents
                        Row(
                          children: [
                
                            // catgori icons
                            CircleAvatar(
                              backgroundColor: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
                              radius: 25.0,
                              child: _excelController.isExporting
                                ? LoadingAnimationWidget.prograssiveDots(
                                    color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                    size: 20.0,
                                  )
                                : Icon(
                                  Icons.download,
                                  color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                )
                            ),
                
                            // group text
                            const SizedBox(width: 15.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'export data'.tr,
                                  style: GoogleFonts.kantumruyPro(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                  ),
                                ),
                                Text(
                                  'export data to excel'.tr,
                                  style: GoogleFonts.kantumruyPro(
                                    fontSize: 15.0,
                                    color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                
                        // right content
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                        )
                      ],
                    ),
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  // change language
  Widget changeLanguages({
    required BuildContext context,
  }) {
    return Container(
      height: 270.0,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // center dot
          const SizedBox(height: 15.0),
          Center(
            child: Container(
              height: 3.0,
              width: MediaQuery.of(context).size.width / 4.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.2),
              ),
            ),
          ),

          //
          const SizedBox(height: 40.0),
          Text(
            'select language'.tr,
            style: GoogleFonts.kantumruyPro(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
            ),
          ),

          // khmer language
          const SizedBox(height: 15.0),
          GestureDetector(
            onTap: () {
              _translationController.changeLanguage();
            },
            child: Container(
              height: 55.0,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _translationController.isEnglish
                      ? Colors.transparent
                      : _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                  width: 1.0,
                ),
                color: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  // left conetnt
                  Row(
                    children: [
                      Image.asset(
                        'images/Khmer.png',
                        width: 30.0,
                        height: 30.0,
                      ),
                      const SizedBox(width: 15.0),
                      Text(
                        'khmer'.tr,
                        style: GoogleFonts.kantumruyPro(
                          fontSize: 15.0,
                          color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),

                  // right content
                  Icon(
                    _translationController.isEnglish ? null : Icons.done,
                    color: _translationController.isEnglish ? null : _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                    size: 20.0,
                  ),
                ],
              ),
            ),
          ),

          // english language
          const SizedBox(height: 10.0),
          GestureDetector(
            onTap: () {
              _translationController.changeLanguage();
            },
            child: Container(
              height: 55.0,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _translationController.isEnglish
                      ? _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor
                      : Colors.transparent,
                  width: 1.0,
                ),
                color: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  // left content
                  Row(
                    children: [
                      Image.asset(
                        'images/English.png',
                        width: 30.0,
                        height: 30.0,
                      ),
                      const SizedBox(width: 15.0),
                      Text(
                        'english'.tr,
                        style: GoogleFonts.kantumruyPro(
                          fontSize: 15.0,
                          color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),

                  // left content
                  Icon(
                    _translationController.isEnglish ? Icons.done : null,
                    color: _translationController.isEnglish ? _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor : null,
                    size: 20.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}