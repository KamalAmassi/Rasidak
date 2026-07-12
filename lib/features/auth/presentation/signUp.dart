import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rasidak/core/constants/app_color.dart';
import 'package:rasidak/core/localization/language_controller.dart';
import 'package:rasidak/core/routes/app_pages.dart';
import 'package:rasidak/features/auth/logic/controller/authController.dart';
import 'package:rasidak/features/customer/logic/customer_controller.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final authController = Get.find<AuthController>();
  final lang = Get.find<LanguageController>();
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final double titleFontSize = (w * 0.065).clamp(22.0, 28.0);
    final double subtitleFontSize = (w * 0.042).clamp(14.0, 17.0);
    final double labelFontSize = (w * 0.040).clamp(14.0, 17.0);
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
              SizedBox(height: h * 0.02),

              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.arrow_back, color: AppColors.primaryText),
                  ),
                ],
              ),

              SizedBox(height: h * 0.02),

              Text(
                lang.t("إنشاء حساب جديد"),
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
              SizedBox(height: h * 0.008),
              Text(
                "أنشئ حسابك وابدأ بإدارة ديون عملائك",
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: subtitleFontSize,
                  color: AppColors.secondaryText,
                ),
              ),

              SizedBox(height: h * 0.035),

              _buildLabel(lang.t("أسم الزبون"), labelFontSize),
              SizedBox(height: h * 0.008),
              _buildTextField(
                controller: name,
                hint: "ادخل اسمك الكامل",
                icon: Icons.person_outline,
                borderRadius: borderRadius,
              ),

              SizedBox(height: h * 0.02),

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

              SizedBox(height: h * 0.02),


              _buildLabel(lang.t("تأكيد كلمة المرور"), labelFontSize),
              SizedBox(height: h * 0.008),
              _buildTextField(
                controller: confirmPassword,
                hint: lang.t("أعد إدخال كلمة المرور"),
                icon: Icons.lock_outline,
                borderRadius: borderRadius,
                obscureText: obscureConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.secondaryText,
                  ),
                  onPressed: () {
                    setState(() => obscureConfirmPassword = !obscureConfirmPassword);
                  },
                ),
              ),

              SizedBox(height: h * 0.04),


              InkWell(
                onTap: () async {
                  if (name.text.trim().isEmpty) {
                    Get.snackbar(lang.t("تنبيه"), lang.t("الرجاء إدخال اسم الزبون"));
                    return;
                  }
                  if (email.text.trim().isEmpty) {
                    Get.snackbar(lang.t("تنبيه"), lang.t("الرجاء إدخال البريد الإلكتروني"));
                    return;
                  }
                  if (password.text.trim().length < 6) {
                    Get.snackbar(
                      lang.t("تنبيه"),
                      lang.t("كلمة المرور يجب أن تكون 6 أحرف على الأقل"),
                    );
                    return;
                  }
                  if (password.text.trim() != confirmPassword.text.trim()) {
                    Get.snackbar(
                      lang.t("تنبيه"),
                      lang.t("كلمة المرور غير متطابقة"),
                    );
                    return;
                  }

                  final success = await authController.signUp(
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
                    lang.t("إنشاء حساب"),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ),
              ),

              SizedBox(height: h * 0.03),


              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        lang.t("سجّل دخولك"),
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: subtitleFontSize,
                        ),
                      ),
                    ),
                    Text(
                      lang.t("لديك حساب بالفعل؟"),
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