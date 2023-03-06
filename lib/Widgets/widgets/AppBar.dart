import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_fonts/google_fonts.dart';

Widget AppBarLogo(String title, BuildContext context) {
  return Card(
    child: Container(
      color: Colors.white60,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            title,
            style:  GoogleFonts.montserrat(
              fontSize: 5.w,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          ),
        ),
      ),

  );
}
