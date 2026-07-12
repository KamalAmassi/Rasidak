import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:rasidak/features/customer/logic/entity/customer.dart';
import 'package:rasidak/features/debt/logic/entity/debt.dart';
import 'package:rasidak/features/payment/logic/entity/payment.dart';

class PdfExportService {
  static Future<void> exportCustomerDebts({
    required Customer customer,
    required List<Debt> debts,
    required List<Payment> payments,
  }) async {
    final fontData = await rootBundle.load("assets/fonts/Cairo-Regular.ttf");
    final boldFontData = await rootBundle.load("assets/fonts/Cairo-Bold.ttf");

    final arabicFont = pw.Font.ttf(fontData);
    final arabicBoldFont = pw.Font.ttf(boldFontData);

    final pdf = pw.Document();

    final totalDebts = debts.fold<double>(0, (sum, d) => sum + d.amount);
    final totalPayments = payments.fold<double>(0, (sum, p) => sum + p.amount);
    final remaining = totalDebts - totalPayments;

    pdf.addPage(
      pw.MultiPage(
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(
          base: arabicFont,
          bold: arabicBoldFont,
        ),
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              "تقرير ديون ومدفوعات الزبون",
              style: pw.TextStyle(fontSize: 22, font: arabicBoldFont),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              "اسم الزبون: ${customer.name}",
              style: pw.TextStyle(fontSize: 16, font: arabicFont),
            ),
            pw.Text(
              "رقم الهاتف: ${customer.phone}",
              style: pw.TextStyle(fontSize: 14, font: arabicFont),
            ),
            pw.Divider(thickness: 1),
          ],
        ),
        build: (context) => [
          // --- قسم سجل الديون ---
          pw.Text(
            "سجل الديون",
            style: pw.TextStyle(fontSize: 18, font: arabicBoldFont),
          ),
          pw.SizedBox(height: 8),

          if (debts.isEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 8),
              child: pw.Text(
                "لا يوجد ديون مسجلة",
                style: pw.TextStyle(font: arabicFont, fontSize: 13),
              ),
            )
          else
            pw.Table(
              border: pw.TableBorder.all(width: 0.5),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    _cell("التاريخ", arabicBoldFont, isHeader: true),
                    _cell("الوصف", arabicBoldFont, isHeader: true),
                    _cell("المبلغ", arabicBoldFont, isHeader: true),
                  ],
                ),
                ...debts.map((d) => pw.TableRow(
                  children: [
                    _cell(
                      "${d.date.day}/${d.date.month}/${d.date.year}",
                      arabicFont,
                    ),
                    _cell(
                      d.description.isEmpty ? "-" : d.description,
                      arabicFont,
                    ),
                    _cell("${d.amount} NIS", arabicFont),
                  ],
                )),
              ],
            ),

          pw.SizedBox(height: 8),
          pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(
              "إجمالي الديون: ${totalDebts.toStringAsFixed(2)} NIS",
              style: pw.TextStyle(fontSize: 14, font: arabicBoldFont),
            ),
          ),

          pw.SizedBox(height: 24),
          pw.Divider(thickness: 1),
          pw.SizedBox(height: 8),

          // --- قسم سجل المدفوعات ---
          pw.Text(
            "سجل المدفوعات",
            style: pw.TextStyle(fontSize: 18, font: arabicBoldFont),
          ),
          pw.SizedBox(height: 8),

          if (payments.isEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 8),
              child: pw.Text(
                "لا يوجد مدفوعات مسجلة",
                style: pw.TextStyle(font: arabicFont, fontSize: 13),
              ),
            )
          else
            pw.Table(
              border: pw.TableBorder.all(width: 0.5),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.green100),
                  children: [
                    _cell("تاريخ التسديد", arabicBoldFont, isHeader: true),
                    _cell("المبلغ", arabicBoldFont, isHeader: true),
                  ],
                ),
                ...payments.map((p) => pw.TableRow(
                  children: [
                    _cell(
                      "${p.date.day}/${p.date.month}/${p.date.year}",
                      arabicFont,
                    ),
                    _cell("${p.amount} NIS", arabicFont),
                  ],
                )),
              ],
            ),

          pw.SizedBox(height: 8),
          pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(
              "إجمالي المدفوعات: ${totalPayments.toStringAsFixed(2)} NIS",
              style: pw.TextStyle(fontSize: 14, font: arabicBoldFont),
            ),
          ),

          pw.SizedBox(height: 24),
          pw.Divider(thickness: 1.5),
          pw.SizedBox(height: 12),

          // --- الرصيد النهائي المتبقي ---
          pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey200,
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Text(
                "الرصيد المتبقي: ${remaining.toStringAsFixed(2)} NIS",
                style: pw.TextStyle(fontSize: 18, font: arabicBoldFont),
              ),
            ),
          ),
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'debts_${customer.name}.pdf',
    );
  }

  static pw.Widget _cell(String text, pw.Font font, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        textDirection: pw.TextDirection.rtl,
        textAlign: pw.TextAlign.right,
        style: pw.TextStyle(
          font: font,
          fontSize: isHeader ? 13 : 12,
        ),
      ),
    );
  }
}