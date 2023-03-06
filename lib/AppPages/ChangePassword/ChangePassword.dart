// ignore_for_file: prefer_typing_uninitialized_variables, file_names

import 'package:BBQOUTLETS/AppPages/Registration/RegistrationPage.dart';
import 'package:BBQOUTLETS/Constants/ConstantVariables.dart';
import 'package:BBQOUTLETS/utils/CartBadgeCounter/CartBadgetLogic.dart';
import 'package:BBQOUTLETS/utils/utils/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

// import 'package:untitled2/AppPages/CartxxScreen/ConstantVariables.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword>
    with InputValidationMixin {
  FocusNode myFocusNode = FocusNode();

  GlobalKey<FormState> myGlobalKey = GlobalKey<FormState>();

  TextEditingController pController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();

  bool passError = true;

  bool cpError = true;

  bool oldpassError = true;

  var _adminToken;

  var _customerId;

  void initSharedPrefs() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();

    setState(() {
      _customerId = ConstantsVar.prefs.getString('customerId');
      _adminToken = ConstantsVar.prefs.getString('adminToken');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    initSharedPrefs();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        // backgroundColor: Page.background,
        appBar: AppBar(
          backgroundColor: ConstantsVar.appColor,
        ),

        body: GestureDetector(
          // close keyboard on outside input tap
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },

          child: Builder(
            builder: (context) => Form(
              key: myGlobalKey,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(10),
                      children: <Widget>[
                        // header text
                        Center(
                          child: AutoSizeText(
                            'Reset Password'.toUpperCase(),
                            style: TextStyle(
                              fontSize: 6.5.w,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        //Old password input
                        Padding(
                          padding: const EdgeInsets.only(top: 48.0),
                          child: Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextFormField(
                                enableInteractiveSelection: false,
                                validator: (password) {
                                  if (oldPassword(password!)) {
                                    return null;
                                  } else {
                                    return 'Please enter your password';
                                  }
                                },
                                textInputAction: TextInputAction.next,
                                obscureText: oldpassError,
                                controller: oldPasswordController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                cursorColor: Colors.black,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14),
                                decoration: InputDecoration(
                                    suffix: ClipOval(
                                      child: RoundCheckBox(
                                        uncheckedColor: Colors.white,
                                        checkedColor: Colors.white,
                                        size: 20,
                                        onTap: (selected) {
                                          setState(() {
                                            oldpassError
                                                ? oldpassError = selected!
                                                : oldpassError = selected!;
                                          });
                                        },
                                        isChecked: oldpassError,
                                        checkedWidget: const Center(
                                          child: Icon(
                                            Icons.remove_red_eye_outlined,
                                            size: 16,
                                          ),
                                        ),
                                        uncheckedWidget: Center(
                                          child: Icon(
                                            Icons.remove_red_eye,
                                            color: ConstantsVar.appColor,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.password_rounded,
                                      color: ConstantsVar.appColor,
                                    ),
                                    labelStyle: TextStyle(
                                        fontSize: 5.w, color: Colors.grey),
                                    labelText: 'Old Password',
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                        ),

                        //New password input
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextFormField(
                                enableInteractiveSelection: false,
                                validator: (password) {
                                  if (!isPasswordValid(password!)) {
                                    return 'Atleast 1 uppercase letter.\nAtleast 1 lowercase letter.\nAtleast 1 special letter.\nAtleast 1 numeric letter.';
                                  } else {
                                    return null;
                                  }
                                },
                                textInputAction: TextInputAction.next,
                                obscureText: passError,
                                controller: pController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                cursorColor: Colors.black,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14),
                                decoration: InputDecoration(
                                    suffix: ClipOval(
                                      child: RoundCheckBox(
                                        uncheckedColor: Colors.white,
                                        checkedColor: Colors.white,
                                        size: 20,
                                        onTap: (selected) {
                                          setState(() {
                                            passError
                                                ? passError = selected!
                                                : passError = selected!;
                                          });
                                        },
                                        isChecked: passError,
                                        checkedWidget: const Center(
                                          child: Icon(
                                            Icons.remove_red_eye_outlined,
                                            size: 16,
                                          ),
                                        ),
                                        uncheckedWidget: Center(
                                          child: Icon(
                                            Icons.remove_red_eye,
                                            color: ConstantsVar.appColor,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.password_rounded,
                                      color: ConstantsVar.appColor,
                                    ),
                                    labelStyle: TextStyle(
                                        fontSize: 5.w, color: Colors.grey),
                                    labelText: 'New Password',
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                        ),
                        //Confirm password input

                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextFormField(
                                  enableInteractiveSelection: false,
                                  validator: (password) {
                                    if (isPasswordMatch(
                                      pController.text.toString(),
                                      confirmPasswordController.text.toString(),
                                    )) {
                                      return null;
                                    } else {
                                      return 'Password Mismatch!';
                                    }
                                  },
                                  textInputAction: TextInputAction.done,
                                  obscureText: cpError,
                                  controller: confirmPasswordController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  cursorColor: Colors.black,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14),
                                  decoration: InputDecoration(
                                      suffix: ClipOval(
                                        child: RoundCheckBox(
                                          checkedColor: Colors.white,
                                          uncheckedColor: Colors.white,
                                          size: 20,
                                          onTap: (selected) {
                                            setState(() {
                                              cpError
                                                  ? cpError = selected!
                                                  : cpError = selected!;
                                            });
                                          },
                                          isChecked: cpError,
                                          checkedWidget: const Center(
                                            child: Icon(
                                              Icons.remove_red_eye_outlined,
                                              size: 16,
                                            ),
                                          ),
                                          uncheckedWidget: Center(
                                            child: Icon(
                                              Icons.remove_red_eye,
                                              color: ConstantsVar.appColor,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.password_rounded,
                                        color: ConstantsVar.appColor,
                                      ),
                                      labelStyle: TextStyle(
                                          fontSize: 5.w, color: Colors.grey),
                                      labelText: 'Confirm Password',
                                      border: InputBorder.none)),
                            ),
                          ),
                        ),

                        // submit button

                        // sign up button
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AppButton(
                      color: ConstantsVar.appColor,
                      child: SizedBox(
                        width: 100.w,
                        child: Center(
                          child: AutoSizeText(
                            'Reset Password'.toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 5.4.w,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      text: '',

                      // add your on tap handler here
                      onTap: () async {
                        if (myGlobalKey.currentState!.validate()) {
                          myGlobalKey.currentState!.save();
                          final resetPassword =
                              Provider.of<cartCounter>(context, listen: false);
                          resetPassword.resetPassword(
                              customerId: _customerId,
                              adminToken: _adminToken,
                              ctx: context,
                              oldPassword: oldPasswordController.text,
                              newPassword: confirmPasswordController.text);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Please enter correct password.')));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration editBoxDecoration(
      {required String name, required Icon icon, required String prefixText}) {
    return InputDecoration(
      prefixText: prefixText,
      prefixIcon: icon,
      labelStyle: TextStyle(
          fontSize: 5.w,
          color:
              myFocusNode.hasFocus ? AppColor.PrimaryAccentColor : Colors.grey),
      labelText: name,
      border: InputBorder.none,
      counterText: '',
    );
  }
}
