import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
class CustomTextStyle {
  static var textFormFieldRegular = TextStyle(
      fontSize: 2.2.w,
      fontFamily: "Helvetica",
      color: Colors.black,
      fontWeight: FontWeight.w400);

  static var textFormFieldLight =
      textFormFieldRegular.copyWith(fontWeight: FontWeight.w200);

  static var textFormFieldMedium =
      textFormFieldRegular.copyWith(fontWeight: FontWeight.w500);

  static var textFormFieldSemiBold =
      textFormFieldRegular.copyWith(fontWeight: FontWeight.w600);

  static var textFormFieldBold =
      textFormFieldRegular.copyWith(fontWeight: FontWeight.w700);

  static var textFormFieldBlack =
      textFormFieldRegular.copyWith(fontWeight: FontWeight.w900,fontSize: 2.2.w);
}

class Utils {
  static getSizedBox(double? width, double? height) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}
