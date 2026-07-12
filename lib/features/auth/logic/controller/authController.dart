import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:rasidak/core/routes/app_pages.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Rxn<User> currentUser = Rxn<User>();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    currentUser.bindStream(_auth.authStateChanges());
  }

  String? get uid => currentUser.value?.uid;
  bool get isLoggedIn => currentUser.value != null;

  Future<bool> signUp({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return true;
    } on FirebaseAuthException catch (e) {
      print("=== FIREBASE AUTH ERROR CODE: ${e.code} ===");
      print("=== FIREBASE AUTH ERROR MESSAGE: ${e.message} ===");
      Get.snackbar('خطأ', _mapError(e.code));
      return false;
    } catch (e) {
      print("=== GENERIC ERROR: $e ===");
      Get.snackbar('خطأ', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return true;
    } on FirebaseAuthException catch (e) {
      Get.snackbar('خطأ', _mapError(e.code));
      return false;
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed(AppRoutes.login);
  }

  String _mapError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'هذا البريد الإلكتروني مستخدم بالفعل';
      case 'invalid-email':
        return 'صيغة البريد الإلكتروني غير صحيحة';
      case 'weak-password':
        return 'كلمة المرور ضعيفة جداً';
      case 'user-not-found':
        return 'لا يوجد حساب بهذا البريد الإلكتروني';
      case 'wrong-password':
      case 'invalid-credential':
        return 'كلمة المرور غير صحيحة';
      default:
        return 'حدث خطأ، حاول مجدداً';
    }
  }
}