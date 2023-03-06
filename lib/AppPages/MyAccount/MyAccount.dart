// ignore_for_file: file_names

import 'package:BBQOUTLETS/AppPages/ChangePassword/ChangePassword.dart';
import 'package:BBQOUTLETS/AppPages/HomeScreen/HomeScreen.dart';
import 'package:BBQOUTLETS/AppPages/LoginScreen/LoginScreen.dart';
import 'package:BBQOUTLETS/AppPages/MyAddresses/MyAddresses.dart';
import 'package:BBQOUTLETS/AppPages/MyOrders/MyOrders.dart';
import 'package:BBQOUTLETS/AppPages/Registration/RegistrationPage.dart';
import 'package:BBQOUTLETS/Constants/ConstantVariables.dart';
import 'package:BBQOUTLETS/utils/HeartIcon.dart';
import 'package:BBQOUTLETS/utils/utils/build_config.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  bool _willPop = true;

  @override
  Widget build(BuildContext context) {
    Future<bool> _willgoBack() async {
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (context) => MyHomePage(
              pageIndex: 4,
            ),
          ),
          (route) => false);
      setState(() {
        _willPop = true;
      });
      return _willPop;
    }

    return WillPopScope(
      onWillPop: _willPop ? _willgoBack : () async => false,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
              leading: Platform.isAndroid
                  ? InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => MyHomePage(
                                pageIndex: 4,
                              ),
                            ),
                            (route) => false);
                      },
                      child: const Icon(Icons.arrow_back))
                  : InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => MyHomePage(
                                pageIndex: 4,
                              ),
                            ),
                            (route) => false);
                      },
                      child: const Icon(Icons.arrow_back_ios)),
              backgroundColor: ConstantsVar.appColor,
              centerTitle: true,
              toolbarHeight: 18.w,
              title: InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(
                    builder: (context) {
                      return const MyApp();
                    },
                  ), (route) => false);
                },
                child: Image.asset(
                  logoImage,
                  width: 15.w,
                  height: 15.w,
                ),
              )),
          body: SizedBox(
              width: 100.w,
              height: 100.h,
              child: Column(
                children: [
                  SizedBox(
                    width: 100.w,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: AutoSizeText(
                          'my account'.toUpperCase(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 8.5.w,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              )),
        ),
      ),
    );
  }
}
