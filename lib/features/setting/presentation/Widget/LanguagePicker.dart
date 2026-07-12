import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rasidak/core/constants/app_color.dart';
import 'package:rasidak/core/localization/language_controller.dart';

class LanguagePicker {
  static void show(BuildContext context) {
    final lang = Get.find<LanguageController>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _LanguagePickerSheet(lang: lang),
    );
  }
}

class _LanguagePickerSheet extends StatelessWidget {
  final LanguageController lang;
  const _LanguagePickerSheet({required this.lang});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.borderColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Text(
              "اختر اللغة",
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 16),

            Obx(() => _buildOption(
              context,
              flag: "🇸🇦",
              title: "العربية",
              subtitle: "Arabic",
              isSelected: lang.isArabic,
              onTap: () {
                if (!lang.isArabic) lang.toggleLanguage();
                Navigator.pop(context);
              },
            )),

            const SizedBox(height: 10),

            Obx(() => _buildOption(
              context,
              flag: "🇬🇧",
              title: "English",
              subtitle: "الإنجليزية",
              isSelected: !lang.isArabic,
              onTap: () {
                if (lang.isArabic) lang.toggleLanguage();
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
      BuildContext context, {
        required String flag,
        required String title,
        required String subtitle,
        required bool isSelected,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.borderColor,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? AppColors.primaryColor.withOpacity(0.06)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            if (isSelected)
              Icon(Icons.check_circle, color: AppColors.primaryColor, size: 22)
            else
              const SizedBox(width: 22),
            const SizedBox(width: 12),
            Text(flag, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.primaryText,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}