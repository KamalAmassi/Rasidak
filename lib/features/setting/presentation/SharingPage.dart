import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rasidak/core/constants/app_color.dart';
import 'package:rasidak/core/localization/language_controller.dart';
import 'package:rasidak/features/setting/data/SettingData.dart';
import 'package:rasidak/features/setting/presentation/Widget/CustomAppBar.dart';
import 'package:rasidak/features/setting/presentation/Widget/CustomButton.dart';

class SharePage extends StatelessWidget {
  const SharePage({super.key});

  static const String shareLink = "rasidak.com/app";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;
    final lang = Get.find<LanguageController>();

    return Obx(()=>Scaffold(
      appBar: CustomAppBar(name: lang.t("شارك التطبيق")),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: h * 0.02),
        child: Column(
          children: [
            _buildTopBox(w, h, lang),
            SizedBox(height: h * 0.02),
            _buildShareLinkBox(context, w, h, lang),
            SizedBox(height: h * 0.02),
            _buildStatsGrid(w, h, lang),
            SizedBox(height: h * 0.025),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.025),
              child: SizedBox(
                width: double.infinity,
                child: Obx(() => CustomButton(
                  name: lang.t("شارك التطبيق"),
                  callback: () {},
                )),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildTopBox(double w, double h, LanguageController lang) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: w * 0.025),
      padding: EdgeInsets.all(w * 0.035),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        border: Border.all(color: AppColors.borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Obx(() => Text(
              lang.t(
                "رصيدك : إدارة ديون عملائك بسهولة، تتبع المعاملات والمدفوعات اليوم الأخير بسهولة.",
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: (w * 0.045).clamp(16.0, 20.0),
                fontWeight: FontWeight.bold,
              ),
            )),
          ),
          SizedBox(width: w * 0.03),
          Container(
            height: 150,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              image: const DecorationImage(
                image: AssetImage("assets/images/logo.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareLinkBox(
      BuildContext context,
      double w,
      double h,
      LanguageController lang,
      ) {
    void copyLink() {
      Clipboard.setData(const ClipboardData(text: shareLink));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lang.t("تم نسخ الرابط"))),
      );
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: w * 0.025),
      padding: EdgeInsets.symmetric(
        horizontal: w * 0.04,
        vertical: h * 0.012,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        border: Border.all(color: AppColors.borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Obx(() => Text(
            lang.t("شارك التطبيق"),
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: AppColors.primaryText,
              fontSize: (w * 0.045).clamp(16.0, 20.0),
              fontWeight: FontWeight.bold,
            ),
          )),
          SizedBox(height: h * 0.01),
          Row(
            children: [
              IconButton(
                onPressed: copyLink,
                icon: Icon(Icons.copy, color: AppColors.primaryColor),
              ),
              Expanded(
                child: Text(
                  shareLink,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 15,
                  ),
                ),
              ),
              IconButton(
                onPressed: copyLink,
                icon: Icon(Icons.copy, color: AppColors.primaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(double w, double h, LanguageController lang) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.025),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: SettingData().sharingData.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: w * 0.025,
          mainAxisSpacing: h * 0.015,
          childAspectRatio: 1.8,
        ),
        itemBuilder: (context, index) {
          return _buildStatBox(
            SettingData().sharingData[index]["value"]!,
            SettingData().sharingData[index]["label"]!,
            w,
            lang,
          );
        },
      ),
    );
  }

  Widget _buildStatBox(
      String value,
      String labelKey,
      double w,
      LanguageController lang,
      ) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        border: Border.all(color: AppColors.borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: (w * 0.05).clamp(18.0, 24.0),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Obx(() => Text(
            lang.t(labelKey),
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: AppColors.secondaryText,
              fontSize: 13,
            ),
          )),
        ],
      ),
    );
  }
}