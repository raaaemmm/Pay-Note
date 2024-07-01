import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pay_note/controllers/sign_up_controller.dart';
import 'package:pay_note/controllers/theme_mode_controller.dart';
import 'package:shimmer/shimmer.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final _signUpController = Get.put(SignUpController());
  final _themeModeController = Get.put(ThemeModeController());

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(15.0),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                // text
                Center(
                  child: Shimmer.fromColors(
                    baseColor: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                    highlightColor: _themeModeController.isDark ? Colors.white : Colors.pink,
                    child: Text(
                      'signup your account'.tr,
                      style: GoogleFonts.kantumruyPro(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                
                // form
                GetBuilder<SignUpController>(
                  builder: (_) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        children: [
                    
                          // profile image
                          const SizedBox(height: 60.0),
                          GestureDetector(
                            onTap: () {
                              _signUpController.selectImage();
                            },
                            child: _signUpController.userProfile != null 
                              ? Stack(
                                clipBehavior: Clip.none,
                                children: [
                                    Container(
                                      height: 160.0,
                                      width: 160.0,
                                      decoration: BoxDecoration(
                                        color: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                          width: 3.0,
                                        ),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: FileImage(
                                            _signUpController.userProfile!,
                                          )
                                        )
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
                              : Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    height: 160.0,
                                    width: 160.0,
                                    decoration: BoxDecoration(
                                      color: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                        width: 3.0,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.image,
                                      size: 35.0,
                                      color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
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
                          ),
                    
                          // name
                          const SizedBox(height: 60.0),
                          TextFormField(
                            controller: _name,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(14.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
                              prefixIcon: Icon(
                                Icons.person,
                                color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                              ),
                              hintText: 'name'.tr,
                              hintStyle: GoogleFonts.kantumruyPro(
                                fontSize: 16.0,
                                color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                              )
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
                            controller: _phone,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(14.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
                              prefixIcon: Icon(
                                Icons.phone_android,
                                color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                              ),
                              hintText: 'phone'.tr,
                              hintStyle: GoogleFonts.kantumruyPro(
                                fontSize: 16.0,
                                color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                              )
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'oops! please enter your phone'.tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                    
                          // email
                          const SizedBox(height: 10.0),
                          TextFormField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
                              prefixIcon: Icon(
                                Icons.email,
                                color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                              ),
                              hintText: 'email'.tr,
                              hintStyle: GoogleFonts.kantumruyPro(
                                fontSize: 16.0,
                                color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                              )
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'oops! please enter your email'.tr;
                              } else if (!GetUtils.isEmail(value)) {
                                return 'oops! type it as email only'.tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                    
                          // password
                          const SizedBox(height: 10.0),
                          TextFormField(
                            controller: _password,
                            obscureText: _signUpController.obscureText,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
                              prefixIcon: Icon(
                                Icons.password,
                                color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _signUpController.showAndHidePassword();
                                },
                                icon: Icon(
                                  _signUpController.obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                  color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                ),
                              ),
                              hintText: 'password'.tr,
                              hintStyle: GoogleFonts.kantumruyPro(
                                fontSize: 15.0,
                                color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'oops! please enter your password'.tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                    
                          // sign up button
                          const SizedBox(height: 15.0),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                _signUpController.signUp(
                                    name: _name.text.trim(),
                                    email: _email.text.trim(),
                                    phone: _phone.text.trim(),
                                    password: _password.text.trim(),
                                );
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 50.0,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
                              ),
                              child: _signUpController.isLoading
                                ? LoadingAnimationWidget.prograssiveDots(
                                    color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                    size: 25.0,
                                  )
                                : Row (
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'sign up'.tr,
                                        style: GoogleFonts.kantumruyPro(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      const SizedBox(width: 10.0),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                      )
                                    ],
                              ),
                            ),
                          ),
                    
                          // back to sign in screen
                          const SizedBox(height: 60.0),
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 50.0,
                                  width: 50.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
                                  ),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                  ),
                                ),
                                Text(
                                  'or sign in account now'.tr,
                                  style: GoogleFonts.kantumruyPro(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
