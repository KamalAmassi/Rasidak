import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rasidak/core/constants/app_color.dart';
import 'package:rasidak/core/localization/language_controller.dart';
import 'package:rasidak/core/routes/app_pages.dart';
import 'package:rasidak/features/customer/logic/customer_controller.dart';
import 'package:rasidak/features/customer/logic/entity/customer.dart';
import 'package:rasidak/features/debt/logic/Controller/debt_controller.dart';
import 'package:rasidak/features/debt/logic/entity/debt.dart';
import 'package:rasidak/features/home/logic/HomeController.dart';
import 'package:rasidak/features/payment/logic/Controller/payment_controller.dart';
import 'package:rasidak/features/payment/logic/entity/payment.dart';

class DebtDetails extends StatefulWidget {
  const DebtDetails({super.key});

  @override
  State<DebtDetails> createState() => _DebtDetailsState();
}

class _DebtDetailsState extends State<DebtDetails> {
  late Customer customer;
  final debtController = Get.find<DebtController>();
  final paymentController = Get.find<PaymentController>();
  final customerController = Get.find<CustomerController>();
  final homeController = Get.find<HomeController>();
  final lang = Get.find<LanguageController>();

  @override
  void initState() {
    super.initState();

    if (Get.arguments == null || Get.arguments is! Customer) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/home');
      });
      return;
    }

    customer = Get.arguments as Customer;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      debtController.fetchDebts(customerId: customer.id);
      paymentController.fetchPayments(customerId: customer.id);
    });
  }

  Customer get _liveCustomer {
    return customerController.customers.firstWhere(
          (c) => c.id == customer.id,
      orElse: () => customer,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(()=>Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Get.back(),
                            icon:  Icon(Icons.arrow_back,color: AppColors.primaryText,),
                          ),
                          const Spacer(),
                          Obx(() => Text(
                            "${lang.t("تفاصيل الزبون")}: ${customer.name}",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Obx(() {
                        final total = _liveCustomer.totalDebt; // ← بدل الحساب المحلي
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const SizedBox(width: 20),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "${lang.t("إجمالي الدين الحالي")}:",
                                    textDirection: TextDirection.rtl,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${total.toStringAsFixed(2)} NIS",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.accentGold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: AppColors.accentGold,
                                child: Icon(
                                  Icons.person,
                                  color: AppColors.borderColor,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 10),

                      Obx(() => Text(
                        lang.t("سجل الديون"),
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      )),

                      const SizedBox(height: 10),

                      Obx(() {
                        if (debtController.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (debtController.debts.isEmpty) {
                          return Center(
                            child: Text(
                              lang.t("لا يوجد ديون لهذا الزبون"),
                              style: const TextStyle(fontSize: 18),
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: debtController.debts.length,
                          itemBuilder: (context, index) {
                            final debt = debtController.debts[index];
                            return _buildDebtCard(debt);
                          },
                        );
                      }),

                      const SizedBox(height: 20),


                      Obx(() => Text(
                        lang.t("سجل المدفوعات"),
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      )),

                      const SizedBox(height: 10),

                      Obx(() {
                        if (paymentController.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (paymentController.payments.isEmpty) {
                          return Center(
                            child: Text(
                              lang.t("لا يوجد مدفوعات لهذا الزبون"),
                              style: const TextStyle(fontSize: 18),
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: paymentController.payments.length,
                          itemBuilder: (context, index) {
                            final payment = paymentController.payments[index];
                            return _buildPaymentCard(payment);
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: _buildButton(
                        AppColors.backgroundColor,
                        "تسديد سداد",
                        AppColors.accentGold,
                            () =>Get.toNamed(AppRoutes.payment, arguments: _liveCustomer)

                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: _buildButton(
                      AppColors.primaryColor,
                      "إضافة دين جديد",
                      AppColors.accentGold,
                          () => homeController.jumpToPage(2)
                      ,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildDebtCard(Debt debt) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildText("${debt.amount} NIS", "مبلغ الدين"),
          if (debt.description.isNotEmpty)
            _buildText(debt.description, "وصف المشتريات"),
          _buildText(
            "${debt.date.day}/${debt.date.month}/${debt.date.year}",
            "تاريخ الإضافة",
          ),
          if (debt.notes.isNotEmpty)
            _buildText(debt.notes, "ملاحظات"),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(Payment payment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.accentGreen.withOpacity(0.4), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildText("${payment.amount} NIS", "مبلغ الدفعة"),
              _buildText(
                "${payment.date.day}/${payment.date.month}/${payment.date.year}",
                "تاريخ التسديد",
              ),
            ],
          ),
          const SizedBox(width: 10),
          Icon(Icons.check_circle, color: AppColors.accentGreen, size: 26),
        ],
      ),
    );
  }

  Widget _buildText(String value, String labelKey) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            value,
            textDirection: TextDirection.rtl,
            style:  TextStyle(fontSize: 18, fontWeight: FontWeight.w300,color: AppColors.primaryText),
          ),
          Text(
            " : ",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: AppColors.primaryText),
          ),
          Obx(() => Text(
            lang.t(labelKey),
            textDirection: TextDirection.rtl,
            style:  TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: AppColors.primaryText),
          )),
        ],
      ),
    );
  }

  Widget _buildButton(Color buttonColor, String titleKey, Color textColor,VoidCallback callback) {
    return InkWell(
      onTap:callback,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderColor,width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          color: buttonColor,
        ),
        child: Obx(() => Text(
          lang.t(titleKey),
          textDirection: TextDirection.rtl,
          style: TextStyle(color: textColor, fontSize: 18),
        )),
      ),
    );
  }
}