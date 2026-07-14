import 'package:flutter/material.dart';
import 'package:rasidak/core/constants/app_color.dart';

class CustomButton extends StatelessWidget {
  final String name;
  final VoidCallback callback;

  const CustomButton({
    super.key,
    required this.name, required this.callback,
  });
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        height: 60,
        width: double.infinity,
        margin: EdgeInsets.all(15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(15)
        ),
        child: Text(name,textDirection: TextDirection.rtl,style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold
        ),),
      ),
    );
  }

}