import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rasidak/core/constants/app_color.dart';
import 'package:rasidak/features/auth/logic/controller/authController.dart';
import 'package:rasidak/features/customer/logic/customer_controller.dart';
import 'package:rasidak/features/customer/logic/entity/customer.dart';
import 'package:rasidak/features/debt/logic/Controller/debt_controller.dart';
import 'package:rasidak/features/debt/logic/export/excel_export_service.dart';
import 'package:rasidak/features/debt/logic/export/pdf_export_service.dart';
import 'package:rasidak/features/payment/logic/Controller/payment_controller.dart';


enum ExportFormat { pdf, excel }

class ExportCustomerPicker {
  static void show(BuildContext context, {required ExportFormat format}) {
    final customerController = Get.find<CustomerController>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _PickerContent(
        customerController: customerController,
        format: format,
      ),
    );
  }
}

class _PickerContent extends StatefulWidget {
  final CustomerController customerController;
  final ExportFormat format;

  const _PickerContent({
    required this.customerController,
    required this.format,
  });

  @override
  State<_PickerContent> createState() => _PickerContentState();
}

class _PickerContentState extends State<_PickerContent> {
  bool isExporting = false;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Obx(() {
          final customers = widget.customerController.customers;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  widget.format == ExportFormat.pdf
                      ? "اختر الزبون لتصدير PDF"
                      : "اختر الزبون لتصدير Excel",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
              ),
              if (isExporting)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              if (!isExporting)
                Expanded(
                  child: customers.isEmpty
                      ? Center(
                    child: Text(
                      "لا يوجد زبائن",
                      style: TextStyle(color: AppColors.secondaryText),
                    ),
                  )
                      : ListView.builder(
                    controller: scrollController,
                    itemCount: customers.length,
                    itemBuilder: (context, index) {
                      final customer = customers[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primaryColor,
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(
                          customer.name,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "${customer.totalDebt} NIS",
                          textDirection: TextDirection.rtl,
                        ),
                        onTap: () => _exportCustomer(customer),
                      );
                    },
                  ),
                ),
            ],
          );
        });
      },
    );
  }

  Future<void> _exportCustomer(Customer customer) async {
    final uid = Get.find<AuthController>().uid;
    if (uid == null) return;

    setState(() => isExporting = true);

    try {
      final debtController = Get.find<DebtController>();
      final debts = await debtController.repository.getDebts(
        uid: uid,
        customerId: customer.id,
      );
      final payments = await Get.find<PaymentController>().repository.getPayments(
        uid: uid,
        customerId: customer.id,
      );

      if (widget.format == ExportFormat.pdf) {
        await PdfExportService.exportCustomerDebts(
          customer: customer,
          debts: debts,
          payments: payments,
        );
      } else {
        await ExcelExportService.exportCustomerDebts(
          customer: customer,
          debts: debts,
          payments: payments,
        );
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    } finally {
      if (mounted) setState(() => isExporting = false);
    }
  }
}