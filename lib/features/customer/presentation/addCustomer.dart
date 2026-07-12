import 'package:flutter/material.dart';
import 'package:rasidak/core/constants/app_color.dart';
import 'package:get/get.dart';
import 'package:rasidak/core/localization/language_controller.dart';
import 'package:rasidak/features/customer/logic/customer_controller.dart';
import 'package:rasidak/features/customer/logic/entity/customer.dart';
import 'package:rasidak/features/customer/presentation/widget/TextFieldWidget.dart';
import 'package:rasidak/features/home/logic/HomeController.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({super.key});

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final TextEditingController name = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController notes = TextEditingController();

  late final CustomerController controller;
  final homeController = Get.find<HomeController>();
  final lang = Get.find<LanguageController>();

  @override
  void initState() {
    controller = Get.find<CustomerController>();
    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    phoneNumber.dispose();
    notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final double titleFontSize    = (w * 0.055).clamp(20.0, 24.0);
    final double labelFontSize    = (w * 0.042).clamp(14.0, 18.0);
    final double badgeFontSize    = (w * 0.036).clamp(12.0, 15.0);
    final double separatorSize    = (w * 0.036).clamp(12.0, 15.0);
    final double balanceFontSize  = (w * 0.040).clamp(14.0, 17.0);
    final double buttonFontSize   = (w * 0.040).clamp(14.0, 18.0);
    final double borderRadius     = (w * 0.030).clamp(10.0, 16.0);
    final double padding          = (w * 0.030).clamp(12.0, 22.0);
    final double buttonHeight     = (h * 0.065).clamp(44.0, 56.0);
    final double balanceBoxHeight = (h * 0.075).clamp(48.0, 60.0);

    Widget buildLabel(String labelKey, String badgeKey) {
      return Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "(${lang.t(badgeKey)})",
            style: TextStyle(fontSize: badgeFontSize, color: AppColors.secondaryText),
          ),
          Text(
            " : ",
            style: TextStyle(
              fontSize: separatorSize,
              color: AppColors.primaryText,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            lang.t(labelKey),
            style: TextStyle(
              fontSize: labelFontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
        ],
      ));
    }

    return Obx(() => Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            lang.t("إضافة زبون جديد"),
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
            textDirection: TextDirection.rtl,
          ),

          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: h - titleFontSize - (padding * 2) - 60,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          buildLabel("أسم الزبون", "إلزامي"),
                          SizedBox(height: h * 0.006),
                          TextFieldWidget(
                            hintText: lang.t("ادخل اسم الزبون"),
                            controller: name,
                            minLineNum: 1,
                            maxLineNum: 1,
                          ),
                        ],
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          buildLabel("رقم الهاتف", "إلزامي"),
                          SizedBox(height: h * 0.006),
                          TextFieldWidget(
                            hintText: lang.t("ادخل رقم الهاتف"),
                            controller: phoneNumber,
                            minLineNum: 1,
                            maxLineNum: 1,
                          ),
                        ],
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          buildLabel("ملاحظات", "إختياري"),
                          SizedBox(height: h * 0.006),
                          TextFieldWidget(
                            hintText: lang.t("ادخل ملاحظات"),
                            controller: notes,
                            minLineNum: 3,
                            maxLineNum: 3,
                          ),
                        ],
                      ),

                      Container(
                        height: balanceBoxHeight,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(borderRadius),
                          color: AppColors.backgroundColor,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 20,
                              spreadRadius: 2,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Text(
                          lang.t("الرصيد الحالي : 0 شيكل"),
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: balanceFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      InkWell(
                        onTap: () async {
                          if (name.text.trim().isEmpty) {
                            Get.snackbar(
                              lang.t("تنبيه"),
                              lang.t("الرجاء إدخال اسم الزبون"),
                            );
                            return;
                          }
                          final customer = Customer(
                            id: "",
                            name: name.text.trim(),
                            phone: phoneNumber.text.trim(),
                            notes: notes.text.trim(),
                            totalDebt: 0,
                            debtLevel: "simple",
                            lastUpdate: DateTime.now(),
                          );
                          await controller.addCustomer(customer);
                          homeController.goHome();
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
                          child: Text(
                            lang.t("حفظ الزبون"),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: buttonFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}