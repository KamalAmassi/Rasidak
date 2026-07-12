import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:rasidak/core/constants/app_color.dart";
import "package:rasidak/core/localization/language_controller.dart";
import "package:rasidak/features/setting/data/SettingData.dart";
import "package:rasidak/features/setting/presentation/Widget/CustomAppBar.dart";
import "package:rasidak/features/setting/presentation/Widget/CustomButton.dart";

class HelpCenter extends StatelessWidget {
  const HelpCenter({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Get.find<LanguageController>();

    return Obx(()=>Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(name: lang.t("مركز المساعدة")),
      body: Column(
        spacing: 10,
        children: [
          _buildSearchField(lang),
          Expanded(
            child: ListView.builder(
              itemCount: SettingData().helpCenterData.length,
              itemBuilder: (context, index) {
                final item = SettingData().helpCenterData[index];
                return _buildBox(
                  context,
                  lang,
                  item.Question,
                  item.Answer,
                );
              },
            ),
          ),
          Obx(() => CustomButton(
            name: lang.t("تواصل مع الدعم"),
            callback: () {},
          )),
        ],
      ),
    ));
  }

  Widget _buildSearchField(LanguageController lang) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Obx(() => TextFormField(
        textDirection: TextDirection.rtl,
        style: TextStyle(color: AppColors.primaryText),
        decoration: InputDecoration(
          hintText: lang.t("إبحث عن الاسئلة الشائعة"),
          hintStyle: TextStyle(color: AppColors.primaryText, fontSize: 20),
          hintTextDirection: TextDirection.rtl,
          suffixIcon: Icon(
            Icons.search,
            color: AppColors.primaryText,
            size: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.borderColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.borderColor, width: 1),
          ),
        ),
      )),
    );
  }

  Widget _buildBox(
      BuildContext context,
      LanguageController lang,
      String questionKey,
      String answer,
      ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderColor, width: 2),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 15),
          iconColor: AppColors.primaryColor,
          collapsedIconColor: AppColors.primaryText,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Obx(() => Text(
                  lang.t(questionKey),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                )),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  answer,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.secondaryText,
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}