
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'colors.dart';
SizedBox addVerticalSpace(double space){
  return SizedBox(height: space);
}


SizedBox addHorizontalSpace(double space){
  return SizedBox(width: space);
}

Widget showloader(){
  return SpinKitRipple(color: AppColor.PrimaryAccentColor,size: 90,);
}
