import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pay_note/controllers/forgot_password_controller.dart';
import 'package:pay_note/controllers/theme_mode_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final _forgotPasswordController = Get.put(ForgotPasswordController());
  final _themeModeController = Get.put(ThemeModeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // back button
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: _themeModeController.isDark
                        ? Colors.white.withOpacity(0.1)
                        : Theme.of(context).primaryColor.withOpacity(0.1),
                  ),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: _themeModeController.isDark
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                  ),
                ),
              ),
          
              const SizedBox(height: 50.0),
              Text(
                'to reset your password account, please enter your email below'.tr,
                style: GoogleFonts.kantumruyPro(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: _themeModeController.isDark
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                ),
              ),
          
              const SizedBox(height: 30.0),
              GetBuilder<ForgotPasswordController>(

                builder: (_) {
                  return Form(
                    key: _forgotPasswordController.formKey,
                    child: Column(
                      children: [
                        // form
                        TextFormField(
                          controller: _forgotPasswordController.emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(15.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'email'.tr,
                            hintStyle: GoogleFonts.kantumruyPro(
                              fontSize: 15.0,
                              color: _themeModeController.isDark
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                            ),
                            prefixIcon: Icon(
                              Icons.email,
                              color: _themeModeController.isDark
                                      ? Colors.white
                                      : Theme.of(context).primaryColor,
                            ),
                            suffixIcon: Visibility(
                              visible: _forgotPasswordController.isClearText,
                              child: IconButton(
                                onPressed: () {
                                  _forgotPasswordController.clearText();
                                },
                                icon: Icon(
                                  Icons.clear,
                                  color: _themeModeController.isDark
                                      ? Colors.white
                                      : Theme.of(context).primaryColor.withOpacity(0.7),
                                ),
                              ),
                            ),
                            filled: true,
                            fillColor: _themeModeController.isDark
                                ? Colors.white.withOpacity(0.1)
                                : Theme.of(context).primaryColor.withOpacity(0.1),
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
                          onChanged: (query) {
                            _forgotPasswordController.showAndHideClearText(query.isNotEmpty);
                          },
                        ),
                            
                        // reset password button
                        const SizedBox(height: 20.0),
                        GestureDetector(
                          onTap: () {
                            if (_forgotPasswordController.formKey.currentState!.validate()) {
                              _forgotPasswordController.resetPassword(
                                email: _forgotPasswordController.emailController.text.trim(),
                              ).whenComplete(() => _forgotPasswordController.clearText());
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 50.0,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: _themeModeController.isDark
                                  ? Colors.white.withOpacity(0.1)
                                  : Theme.of(context).primaryColor.withOpacity(0.1),
                            ),
                            child: _forgotPasswordController.isLoading
                                ? LoadingAnimationWidget.prograssiveDots(
                                    color: _themeModeController.isDark
                                        ? Colors.white
                                        : Theme.of(context).primaryColor,
                                        
                                    size: 25.0,
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'reset'.tr,
                                        style: GoogleFonts.kantumruyPro(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: _themeModeController.isDark
                                              ? Colors.white
                                              : Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      const SizedBox(width: 10.0),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        color: _themeModeController.isDark
                                            ? Colors.white
                                            : Theme.of(context).primaryColor,
                                      )
                                    ],
                                  ),
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
    );
  }
}
