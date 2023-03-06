// ignore_for_file: prefer_typing_uninitialized_variables, file_names

import 'package:BBQOUTLETS/AppPages/HomeScreen/HomeScreen.dart';
import 'package:BBQOUTLETS/AppPages/LoginScreen/LoginScreen.dart';
import 'package:BBQOUTLETS/AppPages/MagentoAdminApis/AdminApis.dart';
import 'package:BBQOUTLETS/AppPages/MagentoAdminApis/CustomerApis.dart';
import 'package:BBQOUTLETS/AppPages/NewxxLogin/NewSignUp.dart';
import 'package:BBQOUTLETS/Constants/ConstantVariables.dart';
import 'package:BBQOUTLETS/new_screen/new_home_screen/new_home_screen.dart';
import 'package:BBQOUTLETS/utils/ApiCalls/ApiCalls.dart';
import 'package:BBQOUTLETS/utils/CartBadgeCounter/CartBadgetLogic.dart';
import 'package:BBQOUTLETS/utils/utils/build_config.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
// import 'package:notification_permissions/notification_permissions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  String name = "BBQ_Images/bbqologomaster.png";
  var permGranted = "granted";
  var permDenied = "denied";
  var permUnknown = "unknown";
  var permProvisional = "provisional";
  bool shouldScaleDown = true; // c
  final width = 200.0;
  final height = 300.0;
  late AnimationController animationController;
  var animation;

  Future initilaize() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => setState(() {}));
    animationController.forward();

    AdminApis.getAdminToken(context: context).then(
      (value) async => await Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => const NewHomeScreen(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: FlutterSizer(
        builder: (context, orientation, screenType) {
          return Scaffold(
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: animation.value * width,
                    height: animation.value * height,
                    child: Hero(
                      tag: logoTag,
                      transitionOnUserGestures: true,
                      child: Image.asset(
                        name,
                        width: animation.value * width,
                        height: animation.value * height,
                      ),
                    ),
                  ),
                  SpinKitCircle(
                    itemBuilder: (context, index) {
                      return const DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future getCustomerId() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    if (ConstantsVar.prefs.getString('userId') != null) {
      ConstantsVar.customerID = ConstantsVar.prefs.getString('userId')!;
    }
    return ConstantsVar.customerID;
  }
}
