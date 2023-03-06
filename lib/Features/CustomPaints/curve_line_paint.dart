import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CurveLine extends CustomPainter {
  final Color _color;

  CurveLine({required Color color}) : _color = color;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = _color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    var _path = Path();
    _path.moveTo(size.width * 0.5, size.height * 0.12);
    _path.arcToPoint(Offset(size.width * 1, size.height * 0.52),
        radius: Radius.circular(10), clockwise: true);

    canvas.drawPath(_path, paint);

    // TODO: implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}

class WheelPainter extends CustomPainter {
  Path getWheelPath(double wheelSize, double fromRadius, double toRadius) {
    return new Path()
      ..moveTo(wheelSize, wheelSize)
      ..arcTo(
          Rect.fromCircle(
            radius: wheelSize,
            center: Offset(wheelSize, wheelSize * 0.2),
          ),
          fromRadius,
          toRadius,
          true);
  }

  Paint getColoredPaint(Color color) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..color = color;
    return paint;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double wheelSize = 100;
    double nbElem = 6;
    double radius = (2 * pi) / nbElem;

    canvas.drawPath(
        getWheelPath(wheelSize, 0, radius), getColoredPaint(Colors.red));
    canvas.drawPath(getWheelPath(wheelSize, radius, radius),
        getColoredPaint(Colors.purple));
    canvas.drawPath(getWheelPath(wheelSize, radius * 2, radius),
        getColoredPaint(Colors.blue));
    canvas.drawPath(getWheelPath(wheelSize, radius * 3, radius),
        getColoredPaint(Colors.green));
    canvas.drawPath(getWheelPath(wheelSize, radius * 4, radius),
        getColoredPaint(Colors.yellow));
    canvas.drawPath(getWheelPath(wheelSize, radius * 5, radius),
        getColoredPaint(Colors.orange));
    canvas.drawLine(Offset(60, radius), Offset(radius * 0.2, 10),
        getColoredPaint(Colors.red));
    canvas.drawLine(
        Offset(50, radius), Offset(radius, 10), getColoredPaint(Colors.red));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class CutomClass extends StatelessWidget {
  const CutomClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FittedBox(
          child: SizedBox(
            width: 200,
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomPaint(
                  painter: WheelPainter(),
                ),
                SpinKitRipple(color: Colors.red,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
