import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import '../../../Constants/ConstantVariables.dart';

class CustomLoader extends StatefulWidget {
  const CustomLoader(
      {Key? key, required String imagePath, required Color color})
      : _customLoaderImage = imagePath,
        _color = color,
        super(key: key);
  final String _customLoaderImage;
  final Color _color;

  @override
  State<CustomLoader> createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader>
    with TickerProviderStateMixin {
  late AnimationController _controller, _waveController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      reverseDuration: Duration(seconds: 3),
      duration: Duration(
        seconds: 3,
      ),
    );
    _waveController = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: Duration(seconds: 3),

    )..forward()..repeat();
    _animation = Tween<double>(begin: 1, end: 0.1 * pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    )
      ..addListener(() {})
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });

    _controller.forward();
  }

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.orange.withOpacity(1 - _waveController.value),width: 5),

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: CurvedAnimation(
        parent: _waveController,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _buildContainer(50 * _waveController.value),
            _buildContainer(100 * _waveController.value),
            _buildContainer(150 * _waveController.value),
            _buildContainer(200 * _waveController.value),



            ClipOval(
              child: Container(
                width:  90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // color: ConstantsVar.appColor.withOpacity(1 - (_controller.value)),
                ),
                child: Image.asset(
                  widget._customLoaderImage,
                ),
              ),
            ),
          ],
        );
      },
    );

    //   Stack(
    //   alignment: Alignment.center,
    //   children: [
    //     _buildContainer(100 * _controller.value),
    //     _buildContainer(150 * _controller.value),
    //     _buildContainer(200 * _controller.value),
    //     _buildContainer(250 * _controller.value),
    //     ScaleTransition(
    //       scale: _animation,
    //       child: ClipOval(
    //         child: Container(
    //           decoration: BoxDecoration(
    //             shape: BoxShape.circle,
    //           ),
    //           child: Image.asset(
    //             widget._customLoaderImage,
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    _waveController.dispose();
    super.dispose();
  }
}
