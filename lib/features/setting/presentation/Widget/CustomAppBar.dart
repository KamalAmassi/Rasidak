import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rasidak/core/constants/app_color.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;

  const CustomAppBar({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      centerTitle: true,
      elevation: 0.2,
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: Icon(
          Icons.arrow_back,
          size: 25,
          color: Colors.white,
        ),
      ),
      title: Text(
        name,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}