import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:rasidak/features/customer/logic/entity/customer.dart';
import 'package:rasidak/features/debt/logic/entity/debt.dart';
import 'package:rasidak/features/payment/logic/entity/payment.dart';

class ExcelExportService {
  static Future<void> exportCustomerDebts({
    required Customer customer,
    required List<Debt> debts,
    required List<Payment> payments,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel['سجل الديون والمدفوعات'];
    excel.delete('Sheet1');

    sheet.isRTL = true;

    final titleStyle = CellStyle(
      bold: true,
      fontSize: 16,
      horizontalAlign: HorizontalAlign.Right,
      fontColorHex: ExcelColor.fromHexString('#1E3A5F'),
    );

    final sectionTitleStyle = CellStyle(
      bold: true,
      fontSize: 14,
      horizontalAlign: HorizontalAlign.Right,
      fontColorHex: ExcelColor.fromHexString('#1E3A5F'),
    );

    final labelStyle = CellStyle(
      bold: true,
      horizontalAlign: HorizontalAlign.Right,
    );

    final valueStyle = CellStyle(
      horizontalAlign: HorizontalAlign.Right,
    );

    final headerStyle = CellStyle(
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      backgroundColorHex: ExcelColor.fromHexString('#1E3A5F'),
      fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
    );

    final paymentHeaderStyle = CellStyle(
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      backgroundColorHex: ExcelColor.fromHexString('#22C55E'),
      fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
    );

    final cellStyle = CellStyle(
      horizontalAlign: HorizontalAlign.Center,
    );

    final totalStyle = CellStyle(
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      backgroundColorHex: ExcelColor.fromHexString('#F5F7FA'),
    );

    final remainingStyle = CellStyle(
      bold: true,
      fontSize: 14,
      horizontalAlign: HorizontalAlign.Center,
      backgroundColorHex: ExcelColor.fromHexString('#FFF3CD'),
    );

    int row = 0;

    // --- العنوان الرئيسي ---
    sheet.appendRow([TextCellValue('تقرير ديون ومدفوعات الزبون')]);
    sheet.merge(
      CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row),
      CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row),
    );
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
        .cellStyle = titleStyle;
    row++;

    sheet.appendRow([]);
    row++;

    // --- بيانات الزبون ---
    sheet.appendRow([
      TextCellValue(customer.name),
      TextCellValue('اسم الزبون :'),
    ]);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
        .cellStyle = valueStyle;
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
        .cellStyle = labelStyle;
    row++;

    sheet.appendRow([
      TextCellValue(customer.phone),
      TextCellValue('رقم الهاتف :'),
    ]);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
        .cellStyle = valueStyle;
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
        .cellStyle = labelStyle;
    row++;

    sheet.appendRow([]);
    row++;

    // --- قسم سجل الديون ---
    sheet.appendRow([TextCellValue('سجل الديون')]);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
        .cellStyle = sectionTitleStyle;
    row++;

    sheet.appendRow([
      TextCellValue('المبلغ (NIS)'),
      TextCellValue('الوصف'),
      TextCellValue('التاريخ'),
    ]);
    for (var col = 0; col < 3; col++) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row))
          .cellStyle = headerStyle;
    }
    row++;

    double totalDebts = 0;
    for (var debt in debts) {
      sheet.appendRow([
        DoubleCellValue(debt.amount),
        TextCellValue(debt.description.isEmpty ? "-" : debt.description),
        TextCellValue(
          "${debt.date.day}/${debt.date.month}/${debt.date.year}",
        ),
      ]);
      for (var col = 0; col < 3; col++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row))
            .cellStyle = cellStyle;
      }
      totalDebts += debt.amount;
      row++;
    }

    sheet.appendRow([
      DoubleCellValue(totalDebts),
      TextCellValue(''),
      TextCellValue('إجمالي الديون :'),
    ]);
    for (var col = 0; col < 3; col++) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row))
          .cellStyle = totalStyle;
    }
    row++;

    sheet.appendRow([]);
    row++;
    sheet.appendRow([]);
    row++;

    // --- قسم سجل المدفوعات ---
    sheet.appendRow([TextCellValue('سجل المدفوعات')]);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
        .cellStyle = sectionTitleStyle;
    row++;

    sheet.appendRow([
      TextCellValue('المبلغ (NIS)'),
      TextCellValue('تاريخ التسديد'),
    ]);
    for (var col = 0; col < 2; col++) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row))
          .cellStyle = paymentHeaderStyle;
    }
    row++;

    double totalPayments = 0;
    for (var payment in payments) {
      sheet.appendRow([
        DoubleCellValue(payment.amount),
        TextCellValue(
          "${payment.date.day}/${payment.date.month}/${payment.date.year}",
        ),
      ]);
      for (var col = 0; col < 2; col++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row))
            .cellStyle = cellStyle;
      }
      totalPayments += payment.amount;
      row++;
    }

    sheet.appendRow([
      DoubleCellValue(totalPayments),
      TextCellValue('إجمالي المدفوعات :'),
    ]);
    for (var col = 0; col < 2; col++) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row))
          .cellStyle = totalStyle;
    }
    row++;

    sheet.appendRow([]);
    row++;
    sheet.appendRow([]);
    row++;

    // --- الرصيد المتبقي النهائي ---
    final remaining = totalDebts - totalPayments;
    sheet.appendRow([
      DoubleCellValue(remaining),
      TextCellValue('الرصيد المتبقي :'),
    ]);
    for (var col = 0; col < 2; col++) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row))
          .cellStyle = remainingStyle;
    }

    // عرض الأعمدة
    sheet.setColumnWidth(0, 16);
    sheet.setColumnWidth(1, 30);
    sheet.setColumnWidth(2, 18);

    // حفظ الملف
    final bytes = excel.save();
    if (bytes == null) return;

    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/debts_${customer.name}.xlsx';
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    await Share.shareXFiles(
      [XFile(filePath)],
      text: 'سجل ديون ومدفوعات ${customer.name}',
    );
  }
}