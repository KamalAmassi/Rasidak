import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final PageController pageController = PageController();
  RxInt currentIndex = 0.obs;

  void jumpToPage(int index) {
    pageController.jumpToPage(index);
    currentIndex.value = index;
  }

  void goHome() {
    jumpToPage(0);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}