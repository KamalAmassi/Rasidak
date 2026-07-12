import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  final _box = GetStorage();
  RxBool notificationsEnabled = true.obs;

  Future<void> init() async {
    tz_data.initializeTimeZones();

    notificationsEnabled.value = _box.read('notificationsEnabled') ?? true;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(initSettings);

    // طلب صلاحية الإشعارات (مهم لـ Android 13+)
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
    _box.write('notificationsEnabled', value);

    if (!value) {
      cancelAll();
    }
  }

  // إشعار فوري
  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    if (!notificationsEnabled.value) return;

    const androidDetails = AndroidNotificationDetails(
      'rasidak_instant_channel',
      'إشعارات فورية',
      channelDescription: 'إشعارات تأكيد العمليات',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(id, title, body, details);
  }

  // تذكير مجدول لوقت لاحق
  Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    if (!notificationsEnabled.value) return;

    const androidDetails = AndroidNotificationDetails(
      'rasidak_reminder_channel',
      'تذكيرات الديون',
      channelDescription: 'تذكيرات بمواعيد تحصيل الديون',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // إلغاء تذكير محدد (مثلاً لو تم تسديد الدين قبل موعد التذكير)
  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }

  // إلغاء كل الإشعارات
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}