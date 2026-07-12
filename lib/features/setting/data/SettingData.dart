// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:rasidak/core/constants/app_color.dart';
import 'package:rasidak/features/setting/logic/model/ContactUsModel.dart';
import 'package:rasidak/features/setting/logic/model/helpCenterModel.dart';
import 'package:rasidak/features/setting/logic/model/settingModel.dart';

class SettingData {
  List<SettingModel>data1=[
    SettingModel("اللغة", "لغة التطبيق", Icons.language,AppColors.primaryText),
    SettingModel("الوضع الليلي", "تفعيل الوضع الليلي", Icons.nightlight,AppColors.primaryText),
    SettingModel("الإشعارات", "تنبيهات الديون والمدفوعات", Icons.notifications,AppColors.primaryText),
  ];

 
  List<SettingModel>data2=[
    SettingModel("تصدير ك PDF", "تقارير الديون والمدفوعات", Icons.picture_as_pdf_outlined,Colors.red),
    SettingModel("تصدير ك Excel", "بيانات منظمة وقابلة للتعديل", Icons.table_chart_outlined,AppColors.accentGreen)
  ];
  
  List<SettingModel>data3 = [
    SettingModel("مركز المساعدة", "", Icons.assignment_late_outlined, AppColors.primaryColor),
    SettingModel("تواصل معنا", "", Icons.messenger, Colors.green),
    SettingModel("تقييم التطبيق", "", Icons.star, Colors.orange),
    SettingModel("مشاركة التطبيق", "", Icons.share, AppColors.primaryText)
  ];


  List<HelpCenterModel> helpCenterData = [
    HelpCenterModel(
      "كيف اضافة دين جديد؟",
      "من الصفحة الرئيسية اضغط على أيقونة new أو اختر زبون، حدد المبلغ والوصف والتاريخ، ثم اضغط حفظ.",
    ),
    HelpCenterModel(
      "طريقة تحصيل الديون",
      "افتح صفحة تفاصيل الزبون واضغط على زر تسديد، ثم أدخل المبلغ المسدد ليتم تحديث الرصيد تلقائياً.",
    ),
    HelpCenterModel(
      "كيف اضافة ديون؟",
      "اضغط على زر إضافة دين، اختر الزبون من القائمة، أدخل تفاصيل الدين، ثم اضغط حفظ.",
    ),
    HelpCenterModel(
      "إدارة الديون",
      "يمكنك من صفحة تفاصيل كل زبون متابعة سجل ديونه، تسديد المبالغ، أو إضافة ديون جديدة بكل سهولة.",
    ),
  ];


  List <ContactUsModel> ContactUsData =[
    ContactUsModel("Email","info@rasidak",Icons.email,AppColors.primaryColor),
    ContactUsModel("Phone","+970592108317",Icons.phone,Colors.blue),
    ContactUsModel("WhatsApp","WhatsApp Business",Icons.messenger_outline,AppColors.accentGreen),
  ];

  List<Map<String, String>> sharingData = [
    {"value": "12K+", "label": "مستخدمين نشطين"},
    {"value": "12K+", "label": "عمليات ناجحة"},
    {"value": "13K+", "label": "مستخدمين"},
    {"value": "18K+", "label": "عمليات أخرى"},
  ];
}