// ignore_for_file: file_names

import 'package:BBQOUTLETS/AppPages/HomeScreen/HomeScreen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';

class StartingPoint extends StatefulWidget {
  const StartingPoint({Key? key}) : super(key: key);

  @override
  _StartingPointState createState() => _StartingPointState();
}

class _StartingPointState extends State<StartingPoint> {
  int _duration = 3000;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 4))
        .then((value) => setState(() => _duration = 1));

  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      nextScreen: const MyApp(),
      splashTransition: SplashTransition.rotationTransition,
      curve: Curves.decelerate,
      splash: Image.asset('BBQ_Images/bbqologomaster.png'),
    );
  }
}
