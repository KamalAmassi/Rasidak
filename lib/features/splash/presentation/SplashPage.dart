import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rasidak/core/constants/app_color.dart';
import 'package:rasidak/core/routes/app_pages.dart';
import 'package:rasidak/features/auth/logic/controller/authController.dart';
import 'package:rasidak/features/customer/logic/customer_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ),
    );

    scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ),
    );

    controller.forward();

    Future.delayed(
      const Duration(seconds: 5),
          () {
        final authController = Get.find<AuthController>();

        if (authController.isLoggedIn) {
          Get.offAllNamed(AppRoutes.home);
        } else {
          Get.offAllNamed(AppRoutes.login);
        }
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                /// LOGO
                Container(
                  height: 300,
                  width: 300,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/logo.png",
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// APP NAME
                Text(
                  "Rasidak",
                  style: TextStyle(
                    color: AppColors.accentGold,
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 5,
                    fontStyle: FontStyle.italic,
                    shadows: [
                      Shadow(
                        blurRadius: 20,
                        color: Colors.black26,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                /// SUB TITLE
                Text(
                  "Manage your debts easily",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}