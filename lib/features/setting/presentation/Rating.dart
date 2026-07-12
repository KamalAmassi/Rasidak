import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:rasidak/core/constants/app_color.dart';
import 'package:rasidak/core/localization/language_controller.dart';
import 'package:rasidak/features/setting/presentation/Widget/CustomAppBar.dart';
import 'package:rasidak/features/setting/presentation/Widget/CustomButton.dart';

class Rating extends StatelessWidget {
  const Rating({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;
    final lang = Get.find<LanguageController>();

    final double logoSize = (w * 0.40).clamp(120.0, 200.0);
    final double titleFontSize = (w * 0.075).clamp(22.0, 32.0);
    final double feedbackFontSize = (w * 0.060).clamp(18.0, 26.0);
    final double starSize = (w * 0.095).clamp(30.0, 42.0);
    final double horizontalPadding = w * 0.05;
    final double sectionSpacing = h * 0.025;

    TextEditingController comment = TextEditingController();

    return Obx(()=>Scaffold(
      appBar: CustomAppBar(name: lang.t("تقييم التطبيق")),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: sectionSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  width: logoSize,
                  height: logoSize,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: h * 0.008),
                Text(
                  "رصيدك",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: titleFontSize,
                    color: AppColors.primaryColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            SizedBox(height: sectionSpacing),
            _buildBoxRating(w, h, starSize, horizontalPadding),
            SizedBox(height: sectionSpacing),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(() => Text(
                    lang.t("FeedBack"),
                    style: TextStyle(
                      fontSize: feedbackFontSize,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  )),
                ],
              ),
            ),
            SizedBox(height: h * 0.012),
            _buildBoxField(comment, horizontalPadding, h, lang),
            SizedBox(height: sectionSpacing),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: SizedBox(
                width: double.infinity,
                child: Obx(() => CustomButton(
                  name: lang.t("إرسال التقييم"),
                  callback: () {},
                )),
              ),
            ),
            SizedBox(height: sectionSpacing),
          ],
        ),
      ),
    ));
  }

  Widget _buildBoxRating(
      double w,
      double h,
      double starSize,
      double horizontalPadding,
      ) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
      padding: EdgeInsets.symmetric(vertical: h * 0.025),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderColor, width: 1),
      ),
      child: RatingBar.builder(
        itemSize: starSize,
        initialRating: 3,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemBuilder: (context, _) => const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: (rating) {},
      ),
    );
  }

  Widget _buildBoxField(
      TextEditingController comment,
      double horizontalPadding,
      double h,
      LanguageController lang,
      ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Obx(() => TextFormField(
        controller: comment,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        textAlignVertical: TextAlignVertical.top,
        minLines: 5,
        maxLines: 5,
        decoration: InputDecoration(
          hintText: lang.t("هل يوجد لديك اي تعليق"),
          hintTextDirection: TextDirection.rtl,
          hintStyle: TextStyle(
            color: AppColors.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w300,
            fontFamily: "Cairo",
          ),
          contentPadding: EdgeInsets.all(h * 0.018),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.borderColor, width: 1.5),
          ),
        ),
      )),
    );
  }
}