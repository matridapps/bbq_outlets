// import 'package:connectivity/connectivity.dart';
// ignore_for_file: prefer_final_fields, prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:BBQOUTLETS/AppPages/ForgotPass/ForgotPassword.dart';
import 'package:BBQOUTLETS/AppPages/MagentoAdminApis/CustomerApis.dart';
import 'package:BBQOUTLETS/AppPages/NewxxLogin/NewSignUp.dart';
import 'package:BBQOUTLETS/AppPages/Registration/RegistrationPage.dart';
import 'package:BBQOUTLETS/Constants/ConstantVariables.dart';
import 'package:BBQOUTLETS/utils/utils/general_functions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final String screenKey;

  @override
  _LoginScreenState createState() => _LoginScreenState();

  const LoginScreen({Key? key, required this.screenKey}) : super(key: key);
}

class _LoginScreenState extends State<LoginScreen> with InputValidationMixin {
  var passController, emailController;

  // var otpController = TextEditingController();
  bool emailError = false;
  bool passError = true;
  String _userEmail = '';
  String _userPassword = '';
  bool connectionStatus = true;
  var btnColor;
  var apiTokken;
  DateTime currentBackPressTime = DateTime.now();

  // var _userCreds;
  var isSuffix = true;

  GlobalKey<FormState> _loginKey = GlobalKey<FormState>();

  bool _willGo = true;

  // final _controller = SiriWaveController();

  void initilaize() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initilaize();

    setState(() {});
    passController = TextEditingController(text: _userPassword);
    emailController = TextEditingController(text: _userEmail);

    ConstantsVar.subscription = ConstantsVar.connectivity.onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          connectionStatus = true;
          btnColor = Colors.black;
        });
      } else {
        ConstantsVar.showSnackbar(context,
            'No Internet connection found. Please check your connection', 5);
        setState(() {
          connectionStatus = false;
          btnColor = Colors.grey;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    ConstantsVar.subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Color _color = const Color.fromRGBO(251, 151, 67, 1);
    return WillPopScope(
      onWillPop: _willGoBack,
      child: SafeArea(
        top: true,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          extendBodyBehindAppBar: true,
          body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: FlutterSizer(
              builder: (context, ori, screenType) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white10,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () async => Navigator.pop(context),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Icon(
                              Icons.arrow_back,
                              size: MediaQuery.of(context).size.width * .08,
                            ),
                          ),
                        ),
                      ),
                      Form(
                        key: _loginKey,
                        child: ListView(
                          children: <Widget>[
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Image.asset(
                                "BBQ_Images/bbqologomaster.png",
                                width: 25.h,
                                height: 25.h,
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Center(
                              child: AutoSizeText(
                                "CUSTOMER LOGIN",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 26.dp,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2),
                              ),
                            ),
                            addVerticalSpace(6.h),
                            Padding(
                              padding: EdgeInsets.only(left: 8.w, right: 8.w),
                              child: SizedBox(
                                height: 55.h,
                                child: ListView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0)),
                                      elevation: 8.0,
                                      child: Container(
                                        padding:
                                            const EdgeInsets.symmetric(horizontal: 4),
                                        width: 90.w,
                                        child: TextFormField(
                                          //  autofocus: true,
                                          autocorrect: false,
                                          textInputAction: TextInputAction.next,
                                          // keyboardType: TextInputType.emailAddress,
                                          /*validator: (val) {
                                              if (val==null) {
                                                return null;
                                              }
                                              return 'Please enter a valid email address!.';
                                            },*/
                                          controller: emailController,
                                          style: const TextStyle(color: Colors.black),
                                          decoration: editBoxDecoration(
                                              'E-mail Address',
                                              Icon(
                                                Icons.email,
                                                color: ConstantsVar.appColor,
                                              ),
                                              false),
                                        ),
                                      ),
                                    ),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0)),
                                      elevation: 8.0,
                                      child: Container(
                                        width: 90.w,
                                        padding:
                                            const EdgeInsets.symmetric(horizontal: 4),
                                        child: TextFormField(
                                          autocorrect: false,
                                          enableInteractiveSelection: false,
                                          textInputAction: TextInputAction.done,
                                          obscureText: passError,
                                          // validator: (inputz) =>
                                          //     input!.isValidPass() ? null : "Check your Password",
                                          controller: passController,

                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          cursorColor: Colors.black,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                          decoration: InputDecoration(
                                              suffix: ClipOval(
                                                child: RoundCheckBox(
                                                  borderColor: Colors.white,
                                                  uncheckedColor: Colors.white,
                                                  checkedColor: Colors.white,
                                                  size: 20,
                                                  onTap: (selected) {
                                                    setState(() {
                                                      log('Tera karma  bngya');
                                                      passError
                                                          ? passError =
                                                              selected!
                                                          : passError =
                                                              selected!;
                                                    });
                                                  },
                                                  isChecked: passError,
                                                  checkedWidget: const Center(
                                                    child: Icon(
                                                      Icons.visibility,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  uncheckedWidget: Center(
                                                    child: Icon(
                                                      Icons.visibility_off,
                                                      color:
                                                          ConstantsVar.appColor,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              prefixIcon: Icon(
                                                Icons.password_rounded,
                                                color: ConstantsVar.appColor,
                                              ),
                                              labelStyle: TextStyle(
                                                  fontSize: 5.w,
                                                  color: Colors.grey),
                                              labelText: 'Password',
                                              border: InputBorder.none),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.symmetric(
                                        vertical: 3.h,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: IgnorePointer(
                                              ignoring: connectionStatus == true
                                                  ? false
                                                  : true,
                                              child: SizedBox(
                                                height: 12.w,
                                                child: TextButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(ConstantsVar
                                                                  .appColor),
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0),
                                                              side: BorderSide(
                                                                  color: ConstantsVar
                                                                      .appColor))),
                                                      overlayColor:
                                                          MaterialStateProperty
                                                              .all(Colors.red),
                                                    ),
                                                    onPressed: () async {
                                                      if (_loginKey
                                                          .currentState!
                                                          .validate()) {
                                                        _loginKey.currentState!
                                                            .save();
                                                        setState(() =>
                                                            _willGo = false);
                                                        CustomerApis.login(
                                                          context: context,
                                                          email: emailController
                                                              .text
                                                              .toString()
                                                              .trim(),
                                                          password:
                                                              passController
                                                                  .text,
                                                          screenName:
                                                              'Login Screen',
                                                        ).then((val) {
                                                          setState(() =>
                                                              _willGo = false);
                                                          //   val == true ? getCartBagdge(0).then((value) => context.read<cartCounter>().changeCounter(value)) : null;
                                                        });
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'Please Enter Correct Details');
                                                      }
                                                    },
                                                    child: const AutoSizeText(
                                                      "LOGIN",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    )),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 12.w,
                                              margin: const EdgeInsets.only(left: 16.0),
                                              child: IgnorePointer(
                                                ignoring:
                                                    connectionStatus == true
                                                        ? false
                                                        : true,
                                                child: TextButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(ConstantsVar
                                                                  .appColor),
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0),
                                                              side: BorderSide(
                                                                  color: ConstantsVar
                                                                      .appColor))),
                                                      overlayColor:
                                                          MaterialStateProperty
                                                              .all(Colors.red),
                                                    ),
                                                    onPressed: () async {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              SignUpPage(),
                                                        ),
                                                      );

                                                      setState(() {});
                                                    },
                                                    child: const AutoSizeText(
                                                      "REGISTER",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Center(
                                        child: FlatButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ForgotPassScreen()));
                                            },
                                            child: const AutoSizeText(
                                              'Forgot Password?',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ))),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration editBoxDecoration(String name, Icon icon, bool isSuffix) {
    return InputDecoration(
        suffix: isSuffix == false
            ? null
            : ClipOval(
                child: RoundCheckBox(
                  border: Border.all(width: 0),
                  size: 24,
                  onTap: (selected) {},
                  checkedWidget: const Icon(Icons.mood, color: Colors.white),
                  uncheckedWidget: const Icon(Icons.mood_bad),
                  animationDuration: const Duration(
                    seconds: 1,
                  ),
                ),
              ),
        prefixIcon: icon,
        labelStyle: TextStyle(fontSize: 5.w, color: Colors.grey),
        labelText: name,
        border: InputBorder.none);
  }

  // Future getCartBagdge(int val) async {
  //   ApiCalls.readCounter().then((value) {
  //     if (mounted)
  //       setState(() {
  //         val = int.parse(value);
  //         context.read<cartCounter>().changeCounter(val);
  //       });
  //   });
  // }

  Future<bool> _willGoBack() async {
    if (widget.screenKey.contains('Home Scree')) {
      Navigator.pop(context);
    } else {}
    return _willGo;
  }
}
