import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rasidak/core/constants/app_color.dart';
import 'package:rasidak/core/localization/language_controller.dart';
import 'package:rasidak/features/setting/data/SettingData.dart';
import 'package:rasidak/features/setting/presentation/Widget/CustomAppBar.dart';
import 'package:rasidak/features/setting/presentation/Widget/CustomButton.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Get.find<LanguageController>();

    return Obx(() => Scaffold(
      appBar: CustomAppBar(name: lang.t("تواصل معنا")),
      backgroundColor: AppColors.backgroundColor,
      body: ListView(
        children: [
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            itemCount: SettingData().ContactUsData.length,
            itemBuilder: (context, index) {
              final item = SettingData().ContactUsData[index];
              return _buildBox(
                lang,
                item.icon,
                item.color,
                item.title,
                item.subTitle,
              );
            },
          ),

          CustomButton(
            name: lang.t("إرسال رسالة"),
            callback: () {},
          ),

          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              lang.t("Company Information"),
              textDirection: TextDirection.ltr,
              style: TextStyle(
                color: AppColors.secondaryColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 5),
          _buildBoxInfo(lang),
        ],
      ),
    ));
  }

  Widget _buildBox(
      LanguageController lang,
      IconData icon,
      Color color,
      String titleKey,
      String subTitleKey,
      ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1.5, color: AppColors.borderColor),
        color: AppColors.cardColor,
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            height: 48,
            width: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 26, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  lang.t(titleKey),
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subTitleKey,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoxInfo(LanguageController lang) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            lang.t("رصيدك"),
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: AppColors.primaryText,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            lang.t("تطبيق ذكي واحترافي لإدارة الديون"),
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: AppColors.secondaryText,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Gaza, info@rasidak.com",
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: AppColors.secondaryText,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "+970592108317",
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: AppColors.secondaryText,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}