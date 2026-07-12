import 'package:flutter/material.dart';

class AppSize {

  final double height;
  final double width;

  AppSize(BuildContext context)
      : height = MediaQuery.of(context).size.height,
        width = MediaQuery.of(context).size.width;

}