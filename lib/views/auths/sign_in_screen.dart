import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pay_note/controllers/sign_in_controller.dart';
import 'package:pay_note/controllers/theme_mode_controller.dart';
import 'package:pay_note/views/auths/forgot_password_screen.dart';
import 'package:pay_note/views/auths/sign_up_screen.dart';
import 'package:shimmer/shimmer.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final _signInController = Get.put(SignInController());
  final _themeModeController = Get.put(ThemeModeController());
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // logo
                Shimmer.fromColors(
                  baseColor: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                  highlightColor: _themeModeController.isDark ? Colors.white : Colors.pink,
                  enabled: true,
                  child: Image.asset(
                    'images/Money.png',
                    height: 150.0,
                    width: 150.0,
                  ),
                ),

                // welcome text
                Shimmer.fromColors(
                  baseColor: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                  highlightColor: _themeModeController.isDark ? Colors.white : Colors.pink,
                  child: Text(
                    'Welcome back to Sign In screen',
                    style: GoogleFonts.kantumruyPro(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                  highlightColor: _themeModeController.isDark ? Colors.white : Colors.pink,
                  child: Text(
                    'Tracking your Income & Expense here',
                    style: GoogleFonts.kantumruyPro(
                      fontSize: 15.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),

                // form
                const SizedBox(height: 25.0),
                GetBuilder<SignInController>(
                  builder: (_) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // email
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
                              ),
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
                            obscureText: _signInController.obscureText,
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
                                  _signInController.showAndHidePassword();
                                },
                                icon: Icon(
                                  _signInController.obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                ),
                              ),
                              hintText: 'password'.tr,
                              hintStyle: GoogleFonts.kantumruyPro(
                                fontSize: 16.0,
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
                    
                          // forgot password
                          const SizedBox(height: 5.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.to(()=> ForgotPasswordScreen());
                                },
                                child: Text(
                                  'forgot password'.tr,
                                  style: GoogleFonts.kantumruyPro(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                    
                          // sign in button
                          const SizedBox(height: 15.0),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                _signInController.signIn(
                                  email: _email.text.trim(),
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
                              child: _signInController.isLoading
                                ? LoadingAnimationWidget.prograssiveDots(
                                    color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                    size: 25.0,
                                  )
                                : Row (
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'sign in'.tr,
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
                    
                          // go to sign up screen
                          const SizedBox(height: 60.0),
                          GestureDetector(
                            onTap: () {
                              Get.to(()=> SignUpScreen());
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'or don\'t have account? sign up now'.tr,
                                  style: GoogleFonts.kantumruyPro(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 50.0,
                                  width: 50.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward,
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
