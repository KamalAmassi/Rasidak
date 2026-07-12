import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rasidak/core/constants/app_color.dart';
import 'package:rasidak/core/localization/language_controller.dart';
import 'package:rasidak/core/routes/app_pages.dart';
import 'package:rasidak/features/customer/logic/entity/customer.dart';
import 'package:rasidak/features/payment/logic/Controller/payment_controller.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController amount = TextEditingController();
  final lang = Get.find<LanguageController>();
  final paymentController = Get.find<PaymentController>();
  late Customer customer;

  @override
  void initState() {
    super.initState();
    customer = Get.arguments as Customer;
  }

  @override
  void dispose() {
    amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final double titleFontSize = (w * 0.065).clamp(22.0, 28.0);
    final double labelFontSize = (w * 0.042).clamp(14.0, 18.0);
    final double buttonFontSize = (w * 0.045).clamp(16.0, 20.0);
    final double borderRadius = (w * 0.035).clamp(12.0, 18.0);
    final double buttonHeight = (h * 0.07).clamp(48.0, 60.0);
    final double horizontalPadding = w * 0.06;

    final now = DateTime.now();
    final formattedDate = "${now.day}/${now.month}/${now.year}";

    return Obx(() => Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
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
                  const Spacer(),
                  Text(
                    lang.t("تسديد دين"),
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                ],
              ),

              SizedBox(height: h * 0.03),

              // --- بطاقة الزبون + الرصيد الحالي ---
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(w * 0.04),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      customer.name,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: AppColors.backgroundColor,
                        fontSize: (w * 0.055).clamp(18.0, 24.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: h * 0.008),
                    Text(
                      lang.t("الرصيد المتبقي الحالي"),
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: labelFontSize * 0.85,
                      ),
                    ),
                    Text(
                      "${customer.totalDebt} NIS",
                      style: TextStyle(
                        color: AppColors.accentGold,
                        fontSize: (w * 0.07).clamp(24.0, 30.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: h * 0.04),

              // --- المبلغ ---
              Text(
                lang.t("المبلغ المراد تسديده"),
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: labelFontSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
              SizedBox(height: h * 0.01),
              TextFormField(
                controller: amount,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: TextStyle(color: AppColors.primaryText, fontSize: 18),
                decoration: InputDecoration(
                  hintText: "0.0 NIS",
                  filled: true,
                  fillColor: AppColors.cardColor,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(color: AppColors.borderColor),
                  ),
                ),
              ),

              SizedBox(height: h * 0.03),

              // --- التاريخ (تلقائي، للقراءة فقط) ---
              Text(
                lang.t("تاريخ التسديد"),
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: labelFontSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
              SizedBox(height: h * 0.01),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, size: 18, color: AppColors.secondaryText),
                    const SizedBox(width: 8),
                    Text(
                      formattedDate,
                      style: TextStyle(color: AppColors.primaryText, fontSize: 16),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              InkWell(
                onTap: () async {
                  final value = double.tryParse(amount.text.trim());

                  if (value == null || value <= 0) {
                    Get.snackbar(
                      lang.t("تنبيه"),
                      lang.t("الرجاء إدخال مبلغ التسديد"),
                    );
                    return;
                  }

                  if (value > customer.totalDebt) {
                    Get.snackbar(
                      lang.t("تنبيه"),
                      lang.t("المبلغ أكبر من الرصيد المتبقي"),
                    );
                    return;
                  }

                  final success = await paymentController.addPayment(
                    customerId: customer.id,
                    customerName: customer.name,
                    amount: value,
                  );

                  if (success) {
                    Get.toNamed(AppRoutes.home);
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
                  child: paymentController.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    lang.t("تأكيد التسديد"),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: h * 0.03),
            ],
          ),
        ),
      ),
    ));
  }
}