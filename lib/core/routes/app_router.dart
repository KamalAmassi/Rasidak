// app_pages.dart

import 'package:get/get.dart';

import 'package:rasidak/core/routes/app_pages.dart';
import 'package:rasidak/features/auth/presentation/login.dart';
import 'package:rasidak/features/auth/presentation/signUp.dart';
import 'package:rasidak/features/debt/presentation/DebtDetails.dart';
import 'package:rasidak/features/debt/presentation/newDebt.dart';
import 'package:rasidak/features/home/presentation/HomePage.dart';
import 'package:rasidak/features/payment/presenation/PaymentPage.dart';
import 'package:rasidak/features/setting/presentation/ContactUs.dart';
import 'package:rasidak/features/setting/presentation/Rating.dart';
import 'package:rasidak/features/setting/presentation/SharingPage.dart';
import 'package:rasidak/features/setting/presentation/helpCenter.dart';
import 'package:rasidak/features/splash/presentation/SplashPage.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignUpPage(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const Homepage(),
    ),
    GetPage(
      name: AppRoutes.payment,
      page: () => const PaymentPage(),
    ),
    GetPage(
      name: AppRoutes.debetDetails,
      page: () => const DebtDetails(),
    ),
    GetPage(
      name: AppRoutes.addDebt,
      page: () => const NewDebt(),
    ),
    GetPage(
      name: AppRoutes.helpCenter,
      page: () => const HelpCenter(),
    ),
    GetPage(
      name: AppRoutes.contactUs,
      page: () => const ContactUs(),
    ),
    GetPage(
      name: AppRoutes.ratingPage,
      page: () => const Rating(),
    ),
    GetPage(
      name: AppRoutes.sharePage,
      page: () => const SharePage(),
    ),
  ];
}
