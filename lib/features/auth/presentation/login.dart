import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rasidak/core/constants/app_color.dart';
import 'package:rasidak/core/localization/language_controller.dart';
import 'package:rasidak/core/routes/app_pages.dart';
import 'package:rasidak/features/auth/logic/controller/authController.dart';
import 'package:rasidak/features/customer/logic/customer_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final authController = Get.find<AuthController>();
  final lang = Get.find<LanguageController>();
  bool obscurePassword = true;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final double logoSize = (w * 0.35).clamp(100.0, 160.0);
    final double titleFontSize = (w * 0.075).clamp(24.0, 32.0);
    final double subtitleFontSize = (w * 0.045).clamp(15.0, 18.0);
    final double labelFontSize = (w * 0.042).clamp(14.0, 18.0);
    final double buttonFontSize = (w * 0.045).clamp(16.0, 20.0);
    final double borderRadius = (w * 0.035).clamp(12.0, 18.0);
    final double buttonHeight = (h * 0.07).clamp(48.0, 60.0);
    final double horizontalPadding = w * 0.06;

    return Obx(() => Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: h * 0.04),

              Center(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      width: logoSize,
                      height: logoSize,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: h * 0.012),
                    Text(
                      "رصيدك",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: titleFontSize,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: h * 0.05),

              Text(
                lang.t("تسجيل الدخول"),
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: titleFontSize * 0.75,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
              SizedBox(height: h * 0.01),
              Text(
                lang.t("سجّل دخولك للمتابعة"),
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: subtitleFontSize,
                  color: AppColors.secondaryText,
                ),
              ),

              SizedBox(height: h * 0.04),

              _buildLabel(lang.t("البريد الإلكتروني"), labelFontSize),
              SizedBox(height: h * 0.008),
              _buildTextField(
                controller: email,
                hint: lang.t("ادخل بريدك الإلكتروني"),
                icon: Icons.email_outlined,
                borderRadius: borderRadius,
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: h * 0.02),

              _buildLabel(lang.t("كلمة المرور"), labelFontSize),
              SizedBox(height: h * 0.008),
              _buildTextField(
                controller: password,
                hint: lang.t("ادخل كلمة المرور"),
                icon: Icons.lock_outline,
                borderRadius: borderRadius,
                obscureText: obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.secondaryText,
                  ),
                  onPressed: () {
                    setState(() => obscurePassword = !obscurePassword);
                  },
                ),
              ),

              SizedBox(height: h * 0.04),

              InkWell(
                onTap: () async {
                  if (email.text.trim().isEmpty) {
                    Get.snackbar(
                      lang.t("تنبيه"),
                      lang.t("الرجاء إدخال البريد الإلكتروني"),
                    );
                    return;
                  }
                  if (password.text.trim().isEmpty) {
                    Get.snackbar(
                      lang.t("تنبيه"),
                      lang.t("الرجاء إدخال كلمة المرور"),
                    );
                    return;
                  }

                  final success = await authController.login(
                    email: email.text.trim(),
                    password: password.text.trim(),
                  );

                  if (success) {
                    Get.find<CustomerController>().fetchCustomers();
                    Get.offAllNamed(AppRoutes.home);
                  }
                },
                borderRadius: BorderRadius.circular(borderRadius),
                child: Container(
                  height: buttonHeight,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    color: AppColors.primaryColor,
                  ),
                  child: Obx(() => authController.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    lang.t("دخول"),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ),
              ),

              SizedBox(height: h * 0.03),

              // --- رابط إنشاء حساب ---
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.toNamed('/signup');
                      },
                      child: Text(
                        lang.t("أنشئ حساباً"),
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: subtitleFontSize,
                        ),
                      ),
                    ),
                    Text(
                      lang.t("ليس لديك حساب؟"),
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: subtitleFontSize,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: h * 0.03),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildLabel(String text, double fontSize) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryText,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required double borderRadius,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      style: TextStyle(color: AppColors.primaryText),
      decoration: InputDecoration(
        hintText: hint,
        hintTextDirection: TextDirection.rtl,
        hintStyle: TextStyle(color: AppColors.hintText, fontSize: 14),
        filled: true,
        fillColor: AppColors.cardColor,
        prefixIcon: Icon(icon, color: AppColors.secondaryText),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
        ),
      ),
    );
  }
}