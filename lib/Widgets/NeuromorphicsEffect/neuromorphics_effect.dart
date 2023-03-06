import 'package:flutter/material.dart';

mixin NeuromorphicsEffect {
  BoxDecoration getNeuromorphicsEffect(
          {required Color color, double? borderRadius = 12}) =>
      BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            offset: Offset(-6.0, -6.0),
            blurRadius: 10.0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(6.0, 6.0),
            blurRadius: 13.0,
          ),
        ],
        color: color,
        borderRadius: BorderRadius.circular(12.0),
      );
}
