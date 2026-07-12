import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:rasidak/core/constants/app_color.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({super.key, required this.hintText, required this.controller, required this.minLineNum, required this.maxLineNum});
  final String hintText;
  final TextEditingController controller;
  final int minLineNum;
  final int maxLineNum;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 15,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          keyboardType: TextInputType.text,
          minLines: minLineNum,
          maxLines: maxLineNum,
          style: TextStyle(color: AppColors.primaryText),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.backgroundColor,
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppColors.primaryText,
              fontSize: 25,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: AppColors.borderColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
