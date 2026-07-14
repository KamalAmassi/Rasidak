import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rasidak/core/constants/app_color.dart';
import 'package:rasidak/core/localization/language_controller.dart';
import 'package:rasidak/core/routes/app_pages.dart';
import 'package:rasidak/features/auth/logic/controller/authController.dart';
import 'package:rasidak/features/setting/data/SettingData.dart';
import 'package:rasidak/features/setting/presentation/Widget/LanguagePicker.dart';
import 'package:rasidak/features/setting/presentation/Widget/dark_mode_picker.dart';
import 'package:rasidak/features/setting/presentation/Widget/export_customer_picker.dart';
import 'package:rasidak/features/setting/presentation/Widget/notification_picker.dart';

// ignore: camel_case_types
class settingPage extends StatelessWidget {
  const settingPage({super.key});

  @override
  Widget build(BuildContext context) {
    SettingData data = SettingData();
    final lang = Get.find<LanguageController>();

    Widget buildTopPage() {
      return Container(
        height: 300,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Column(
          spacing: 7,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(() => Text(
                  lang.t('settings_title'),
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
            Spacer(),
            CircleAvatar(
              backgroundColor: AppColors.secondaryColor,
              radius: 40,
              child: Center(
                child: Text(
                  "أح",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Text(
              "أحمد محمد الخالدي",
              textDirection: TextDirection.rtl,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 22,
              ),
            ),
            Text(
              "+970 59 2108317",
              textDirection: TextDirection.ltr,
              style: TextStyle(
                color: Colors.white54,
                fontWeight: FontWeight.w400,
                fontSize: 22,
              ),
            ),
            Spacer(),
          ],
        ),
      );
    }

    Widget buildBox(String title, String subTitle, IconData icons, Color iconColor) {
      return IntrinsicHeight(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderColor, width: 1),
            color: AppColors.cardColor,
          ),
          child: ListTile(
            title: Obx(() => Text(
              lang.t(title),
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 18,
                color: AppColors.primaryText,
                fontWeight: FontWeight.bold,
              ),
            )),
            subtitle: subTitle.isEmpty
                ? null
                : Obx(() => Text(
              lang.t(subTitle),
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.primaryText,
              ),
            )),
            trailing: Icon(icons, color: iconColor),
            leading: IconButton(
              onPressed: () {
                switch (title) {
                  case "اللغة":
                    LanguagePicker.show(context);
                  case "الوضع الليلي":
                    DarkModePicker.show(context);
                  case "الإشعارات":
                    NotificationPicker.show(context);
                  case "مركز المساعدة":
                    Get.toNamed(AppRoutes.helpCenter);
                  case "تواصل معنا":
                    Get.toNamed(AppRoutes.contactUs);
                  case "تقييم التطبيق":
                    Get.toNamed(AppRoutes.ratingPage);
                  case "مشاركة التطبيق":
                    Get.toNamed(AppRoutes.sharePage);
                  case "تصدير ك PDF":
                    ExportCustomerPicker.show(context, format: ExportFormat.pdf);
                  case "تصدير ك Excel":
                    ExportCustomerPicker.show(context, format: ExportFormat.excel);
                }
              },
              icon: Icon(Icons.arrow_back_ios_new, color: iconColor, size: 12),
            ),
          ),
        ),
      );
    }

    Widget buildBottomPage() {
      return Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.backgroundColor),
        child: Column(
          spacing: 10,
          children: [
            Row(
              children: [
                Spacer(),
                Obx(() => Text(
                  lang.t("الإعدادات العامة"),
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 15, color: AppColors.primaryText),
                )),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: data.data1.length,
              itemBuilder: (context, index) {
                return buildBox(
                  data.data1[index].title,
                  data.data1[index].subTitle,
                  data.data1[index].icons,
                  data.data1[index].iconColor,
                );
              },
            ),
            Row(
              children: [
                Spacer(),
                Obx(() => Text(
                  lang.t("إدارة البيانات"),
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 15, color: AppColors.primaryText),
                )),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: data.data2.length,
              itemBuilder: (context, index) {
                return buildBox(
                  data.data2[index].title,
                  data.data2[index].subTitle,
                  data.data2[index].icons,
                  data.data2[index].iconColor,
                );
              },
            ),
            Row(
              children: [
                Spacer(),
                Obx(() => Text(
                  lang.t("الدعم والمساعدة"),
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 15, color: AppColors.primaryText),
                )),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: data.data3.length,
              itemBuilder: (context, index) {
                return buildBox(
                  data.data3[index].title,
                  data.data3[index].subTitle,
                  data.data3[index].icons,
                  data.data3[index].iconColor,
                );
              },
            ),

            SizedBox(height: 10),
            InkWell(
              onTap: () {
                Get.dialog(
                  AlertDialog(
                    title: Obx(() => Text(
                      lang.t("تسجيل الخروج"),
                      textDirection: TextDirection.rtl,
                    )),
                    content: Obx(() => Text(
                      lang.t("هل أنت متأكد من تسجيل الخروج؟"),
                      textDirection: TextDirection.rtl,
                    )),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Obx(() => Text(lang.t("إلغاء"))),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                          Get.find<AuthController>().logout();
                        },
                        child: Obx(() => Text(
                          lang.t("تسجيل الخروج"),
                          style: const TextStyle(color: Colors.red),
                        )),
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.withOpacity(0.3), width: 1),
                  color: AppColors.cardColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Obx(() => Text(
                      lang.t("تسجيل الخروج"),
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      );
    }

    return Obx(()=>SingleChildScrollView(
      child: Column(
        children: [
          buildTopPage(),
          buildBottomPage(),
        ],
      ),
    ));
  }
}