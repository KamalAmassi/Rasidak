import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rasidak/core/localization/language_controller.dart';
import 'package:rasidak/core/notifications/notification_service.dart';
import 'package:rasidak/core/theme/themeController.dart';
import 'package:rasidak/core/routes/app_pages.dart';
import 'package:rasidak/core/routes/app_router.dart';
import 'package:rasidak/features/auth/logic/controller/authController.dart';
import 'package:rasidak/features/debt/data/dataSource/debt_remote_datasource.dart';
import 'package:rasidak/features/debt/logic/Controller/debt_controller.dart';
import 'package:rasidak/features/debt/logic/repository/debt_repository_imp.dart';
import 'package:rasidak/features/home/logic/HomeController.dart';
import 'package:rasidak/features/payment/data/dataSource/payment_remote_datasource.dart';
import 'package:rasidak/features/payment/logic/Controller/payment_controller.dart';
import 'package:rasidak/features/payment/logic/repository/payment_repository_impl.dart';
import 'package:rasidak/firebase_options.dart';
import 'package:rasidak/features/customer/data/dataSource/customer_remote_datasource.dart';
import 'package:rasidak/features/customer/logic/customer_controller.dart';
import 'package:rasidak/features/customer/logic/repository/customer_repository_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;

  Get.put(AuthController());

  await NotificationService().init();

  final customerDataSource =
  CustomerRemoteDataSource(firestore);

  final customerRepository =
  CustomerRepositoryImpl(customerDataSource);

  Get.put(
    CustomerController(customerRepository),
  );

  final debtDataSource = DebtRemoteDataSource(firestore);
  final debtRepository = DebtRepositoryImpl(debtDataSource);

  final paymentDataSource = PaymentRemoteDataSource(firestore);
  final paymentRepository = PaymentRepositoryImpl(paymentDataSource);
  Get.put(PaymentController(paymentRepository));

  Get.put(DebtController(debtRepository));
  Get.put(HomeController());
  Get.put(LanguageController());
  Get.put(ThemeController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {ome
    return GetMaterialApp(
      title: 'Rasidak',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}