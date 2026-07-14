import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:rasidak/core/constants/app_color.dart";
import "package:rasidak/core/localization/language_controller.dart";
import "package:rasidak/features/customer/logic/customer_controller.dart";
import "package:rasidak/features/debt/logic/Controller/debt_controller.dart";
import "package:rasidak/features/debt/logic/entity/debt.dart";
import "package:rasidak/features/home/logic/HomeController.dart";

class NewDebt extends StatefulWidget {
  const NewDebt({super.key});

  @override
  State<NewDebt> createState() => _NewDebtState();
}

class _NewDebtState extends State<NewDebt> {
  final TextEditingController amount = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController notes = TextEditingController();
  final controller = Get.find<DebtController>();
  final homeController = Get.find<HomeController>();
  final lang = Get.find<LanguageController>();
  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    amount.dispose();
    description.dispose();
    notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final double titleFontSize = (w * 0.042).clamp(14.0, 20.0);
    final double inputFontSize = (w * 0.038).clamp(13.0, 18.0);
    final double hintFontSize = (w * 0.038).clamp(13.0, 18.0);
    final double buttonFontSize = (w * 0.048).clamp(16.0, 22.0);
    final double prefixFontSize = (w * 0.042).clamp(14.0, 20.0);
    final double headingFontSize = (w * 0.065).clamp(20.0, 30.0);
    final double subFontSize = (w * 0.040).clamp(13.0, 18.0);
    final double nameFontSize = (w * 0.060).clamp(18.0, 26.0);

    final double padding = (w * 0.030).clamp(12.0, 28.0);
    final double borderRadius = (w * 0.038).clamp(12.0, 20.0);

    final double buttonHeight = (h * 0.075).clamp(48.0, 64.0);
    final double customerHeight = (h * 0.13).clamp(90.0, 130.0);
    final double avatarRadius = (w * 0.065).clamp(28.0, 44.0);
    final double avatarIconSize = (w * 0.10).clamp(32.0, 52.0);

    Widget buildCustomerPicker(
      CustomerController customerController,
      DebtController debtController,
    ) {
      return Obx(() {
        if (customerController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (customerController.customers.isEmpty) {
          return Center(
            child: Obx(() => Text(
                  lang.t("لا يوجد زبائن"),
                  style: const TextStyle(fontSize: 18),
                )),
          );
        }

        return ListView.builder(
          itemCount: customerController.customers.length,
          itemBuilder: (context, index) {
            final customer = customerController.customers[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primaryColor,
                child: const Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                customer.name,
                textDirection: TextDirection.rtl,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text(
                "${customer.totalDebt} NIS",
                textDirection: TextDirection.rtl,
                style: TextStyle(color: AppColors.secondaryText),
              ),
              onTap: () {
                debtController.selectedCustomer.value = customer;
                Get.back();
              },
            );
          },
        );
      });
    }

    Widget buildTopPage() {
      final debtController = Get.find<DebtController>();
      final customerController = Get.find<CustomerController>();

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => Text(
                lang.t("إضافة دين جديد"),
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: headingFontSize,
                  fontWeight: FontWeight.bold,
                ),
              )),
          SizedBox(height: h * 0.012),
          Obx(() => GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(w * 0.05),
                      ),
                    ),
                    builder: (_) =>
                        buildCustomerPicker(customerController, debtController),
                  );
                },
                child: Container(
                  height: customerHeight,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    color: AppColors.secondaryColor,
                  ),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      SizedBox(width: w * 0.025),
                      CircleAvatar(
                        backgroundColor: AppColors.accentGold,
                        radius: avatarRadius,
                        child: Icon(
                          Icons.person,
                          color: AppColors.primaryColor,
                          size: avatarIconSize,
                        ),
                      ),
                      SizedBox(width: w * 0.06),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            lang.t("العميل المختار"),
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: subFontSize,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            debtController.selectedCustomer.value?.name ??
                                lang.t("اضغط لاختيار الزبون"),
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: nameFontSize,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(left: w * 0.03),
                        child: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white70,
                          size: (w * 0.08).clamp(24.0, 40.0),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      );
    }

    Widget buildBoxField() {
      final debtController = Get.find<DebtController>();
      InputDecoration fieldDecoration({required String hint, Widget? prefix}) {
        return InputDecoration(
          hintText: hint,
          hintStyle:
              TextStyle(color: AppColors.primaryText, fontSize: hintFontSize),
          filled: true,
          fillColor: AppColors.cardColor,
          prefix: prefix,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: w * 0.03,
            vertical: h * 0.015,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        );
      }

      Widget label(String key) => Padding(
            padding: EdgeInsets.only(bottom: h * 0.006),
            child: Obx(() => Text(
                  lang.t(key),
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          );

      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: padding,
          vertical: h * 0.018,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(borderRadius),
            topRight: Radius.circular(borderRadius),
          ),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              label("مبلغ الدين"),
              TextFormField(
                controller: amount,
                keyboardType: const TextInputType.numberWithOptions(),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: inputFontSize, color: AppColors.primaryText),
                decoration: fieldDecoration(
                  hint: "1200 NIS",
                  prefix: Text(
                    "NIS |",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: prefixFontSize,
                    ),
                  ),
                ),
              ),
              SizedBox(height: h * 0.018),
              label("وصف المشتريات (إختياري)"),
              TextFormField(
                controller: description,
                keyboardType: TextInputType.text,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: inputFontSize, color: AppColors.primaryText),
                maxLines: 2,
                minLines: 2,
                decoration: fieldDecoration(hint: "حليب , خبز , جبنة"),
              ),
              SizedBox(height: h * 0.018),
              label("التاريخ (للقراءة فقط)"),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.03,
                  vertical: h * 0.015,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Icon(Icons.calendar_today,
                        size: 18, color: AppColors.secondaryText),
                    SizedBox(width: w * 0.02),
                    Text(
                      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                      style: TextStyle(
                        fontSize: inputFontSize,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: h * 0.018),
              SizedBox(height: h * 0.018),
              label("ملاحظات اضافية (إختياري)"),
              TextFormField(
                controller: notes,
                keyboardType: TextInputType.text,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: inputFontSize, color: AppColors.primaryText),
                maxLines: 2,
                minLines: 2,
                decoration: fieldDecoration(hint: "اي ملاحظات اخرى"),
              ),
              SizedBox(height: h * 0.025),
              InkWell(
                onTap: () async {
                  if (debtController.selectedCustomer.value == null) {
                    Get.snackbar(
                      lang.t('تنبيه'),
                      lang.t('الرجاء اختيار الزبون أولاً'),
                    );
                    return;
                  }

                  if (amount.text.trim().isEmpty) {
                    Get.snackbar(
                      lang.t('تنبيه'),
                      lang.t('الرجاء إدخال مبلغ الدين'),
                    );
                    return;
                  }

                  final debt1 = Debt(
                    id: '',
                    amount: double.tryParse(amount.text.trim()) ?? 0,
                    description: description.text.trim(),
                    notes: notes.text.trim(),
                    date: selectedDate,
                    createdAt: DateTime.now(),
                  );

                  await debtController.addDebt(
                    customerId: debtController.selectedCustomer.value!.id,
                    debt: debt1,
                  );

                  if (!debtController.isLoading.value) {
                    homeController.goHome();
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
                  child: Obx( () => debtController.isLoading.value
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            lang.t("حفظ"),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: buttonFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: h * 0.015),
            ],
          ),
        ),
      );
    }

    return Obx(() => Padding(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.05,
            vertical: h * 0.015,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              buildTopPage(),
              SizedBox(height: h * 0.015),
              Expanded(child: buildBoxField()),
            ],
          ),
        ));
  }
}
