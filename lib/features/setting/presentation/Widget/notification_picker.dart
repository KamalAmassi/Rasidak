import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rasidak/core/constants/app_color.dart';
import 'package:rasidak/core/notifications/notification_service.dart';

class NotificationPicker {
  static void show(BuildContext context) {
    final notificationService = NotificationService();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _NotificationSheet(notificationService: notificationService),
    );
  }
}

class _NotificationSheet extends StatelessWidget {
  final NotificationService notificationService;
  const _NotificationSheet({required this.notificationService});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
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
              "الإشعارات",
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderColor, width: 1),
              ),
              child: Row(
                children: [
                  Icon(
                    notificationService.notificationsEnabled.value
                        ? Icons.notifications_active
                        : Icons.notifications_off,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      notificationService.notificationsEnabled.value
                          ? "الإشعارات مفعّلة"
                          : "الإشعارات مغلقة",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                  Switch(
                    value: notificationService.notificationsEnabled.value,
                    activeColor: AppColors.primaryColor,
                    onChanged: (value) {
                      notificationService.toggleNotifications(value);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}