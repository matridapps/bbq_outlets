// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'Card_Flip.dart';



class SampleAnimation extends StatefulWidget {
  const SampleAnimation({
    Key? key,
  }) : super(key: key);

  @override
  _SampleAnimationState createState() => _SampleAnimationState();
}

enum ScoreWidgetStatus { HIDDEN, BECOMING_VISIBLE, VISIBLE, BECOMING_INVISIBLE }

class _SampleAnimationState extends State<SampleAnimation>
    with TickerProviderStateMixin {
  int _counter = 0;
  double _sparklesAngle = 0.0;
  ScoreWidgetStatus _scoreWidgetStatus = ScoreWidgetStatus.HIDDEN;
  final duration = const Duration(milliseconds: 400);
  final oneSecond = const Duration(seconds: 1);
  late Random random;
  Timer? holdTimer, scoreOutETA;
  late AnimationController scoreInAnimationController,
      scoreOutAnimationController,
      scoreSizeAnimationController,
      sparklesAnimationController;
  late Animation scoreOutPositionAnimation, sparklesAnimation;

  @override
  initState() {
    super.initState();
    random = Random();
    scoreInAnimationController = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);
    scoreInAnimationController.addListener(() {
      setState(() {}); // Calls render function
    });

    scoreOutAnimationController =
        AnimationController(vsync: this, duration: duration);
    scoreOutPositionAnimation = Tween(begin: 100.0, end: 150.0).animate(
        CurvedAnimation(
            parent: scoreOutAnimationController, curve: Curves.easeOut));
    scoreOutPositionAnimation.addListener(() {
      setState(() {});
    });
    scoreOutAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scoreWidgetStatus = ScoreWidgetStatus.HIDDEN;
      }
    });

    scoreSizeAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    scoreSizeAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        scoreSizeAnimationController.reverse();
      }
    });
    scoreSizeAnimationController.addListener(() {
      setState(() {});
    });

    sparklesAnimationController =
        AnimationController(vsync: this, duration: duration);
    sparklesAnimation = CurvedAnimation(
        parent: sparklesAnimationController, curve: Curves.easeIn);
    sparklesAnimation.addListener(() {
      setState(() {});
    });
  }

  @override
  dispose() {
    super.dispose();
    scoreInAnimationController.dispose();
    scoreOutAnimationController.dispose();
  }

  void increment(Timer? t) {
    scoreSizeAnimationController.forward(from: 0.0);
    sparklesAnimationController.forward(from: 0.0);
    setState(() {
      _counter++;
      _sparklesAngle = random.nextDouble() * (2 * pi);
    });
  }

  void onTapDown(TapDownDetails tap) {
    if (scoreOutETA != null) {
      scoreOutETA!.cancel(); // We do not want the score to vanish!
    }

    if (_scoreWidgetStatus == ScoreWidgetStatus.BECOMING_INVISIBLE) {
      // We tapped down while the widget was flying up. Need to cancel that animation.
      scoreOutAnimationController.stop(canceled: true);
      _scoreWidgetStatus = ScoreWidgetStatus.VISIBLE;
    } else if (_scoreWidgetStatus == ScoreWidgetStatus.HIDDEN) {
      Future.delayed(const Duration(seconds: 2)).whenComplete(
          () => _scoreWidgetStatus = ScoreWidgetStatus.BECOMING_VISIBLE);
      scoreInAnimationController.forward(from: 0.0);
    }
    increment(null);

    // User pressed the button. This can be a tap or a hold.

    // Take care of tap
    //    holdTimer = Timer.periodic(duration, increment); // Takes care of hold
  }

  void onTapUp(TapUpDetails tap) {
    // User removed his finger from button.
    scoreOutETA = Timer(oneSecond, () {
      scoreOutAnimationController.forward(from: 0.0);
      _scoreWidgetStatus = ScoreWidgetStatus.BECOMING_INVISIBLE;
    });
    holdTimer!.cancel();
  }

  Widget getScoreButton() {
    var scorePosition = 0.0;
    var scoreOpacity = 0.0;
    var extraSize = 0.0;
    switch (_scoreWidgetStatus) {
      case ScoreWidgetStatus.HIDDEN:
        break;
      case ScoreWidgetStatus.BECOMING_VISIBLE:
      case ScoreWidgetStatus.VISIBLE:
        scorePosition = scoreInAnimationController.value * 100;
        scoreOpacity = scoreInAnimationController.value;
        extraSize = scoreSizeAnimationController.value * 3;
        break;
      case ScoreWidgetStatus.BECOMING_INVISIBLE:
        scorePosition = scoreOutPositionAnimation.value;
        scoreOpacity = 1.0 - scoreOutAnimationController.value;
    }

    var stackChildren = <Widget>[];

    var firstAngle = _sparklesAngle;
    var sparkleRadius = (sparklesAnimationController.value * 50);
    var sparklesOpacity = (1 - sparklesAnimation.value);

    // for (int i = 0; i < 5; ++i) {
    //   var currentAngle = (firstAngle + ((2 * pi) / 5) * (i));
    // var sparklesWidget = Positioned(
    //   child: Transform.rotate(
    //       angle: currentAngle - pi / 2,
    //       child: Opacity(
    //           opacity: sparklesOpacity.toDouble(),
    //           child: Image.asset(
    //             "BBQ_Images/sparkles.png",
    //             width: 14.0,
    //             height: 14.0,
    //           ))),
    //   left: (sparkleRadius * cos(currentAngle)) + 20,
    //   top: (sparkleRadius * sin(currentAngle)) + 20,
    // );
    // stackChildren.add(sparklesWidget);
    // }

    stackChildren.add(Opacity(
        opacity: scoreOpacity,
        child: Container(
            height: 50.0 + extraSize,
            width: 50.0 + extraSize,
            decoration: const ShapeDecoration(
              shape: CircleBorder(side: BorderSide.none),
              color: Colors.pink,
            ),
            child: Center(
                child: Text(
              "+" + _counter.toString(),
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0),
            )))));

    var widget = Positioned(
        child: Stack(
          clipBehavior: Clip.none, alignment: FractionalOffset.center,
          children: stackChildren,
        ),
        bottom: scorePosition);
    return widget;
  }

  Widget getClapButton({required double width}) {
    // Using custom gesture detector because we want to keep increasing the claps
    // when user holds the button.

    var extraSize = 0.0;
    if (_scoreWidgetStatus == ScoreWidgetStatus.VISIBLE ||
        _scoreWidgetStatus == ScoreWidgetStatus.BECOMING_VISIBLE) {
      extraSize = scoreSizeAnimationController.value * 3;
    }
    return GestureDetector(
        onTapUp: onTapUp,
        onTapDown: onTapDown,
        child: Container(
            height: (40) + extraSize,
            width: (width - 10) + extraSize,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.pink, width: 1.0),
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(color: Colors.pink, blurRadius: 8.0)
                ]),
            child: const Center(child: Text('Add to cart'))));
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child:  Stack(
          clipBehavior: Clip.none, alignment: FractionalOffset.center,
          children: <Widget>[
            getScoreButton(),
            getClapButton(
              width: _width * .4,
            ),
          ],
        ),
      ),
    );
  }
}
