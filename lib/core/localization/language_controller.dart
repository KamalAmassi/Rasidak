import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rasidak/core/localization/app_translations.dart';

class LanguageController extends GetxController {
  final _box = GetStorage();
  RxString currentLang = 'ar'.obs;

  @override
  void onInit() {
    super.onInit();
    currentLang.value = _box.read('lang') ?? 'ar';
  }

  String t(String key) {
    return AppTranslations.translations[currentLang.value]?[key] ?? key;
  }

  void toggleLanguage() {
    currentLang.value = currentLang.value == 'ar' ? 'en' : 'ar';
    _box.write('lang', currentLang.value);
  }

  bool get isArabic => currentLang.value == 'ar';
}