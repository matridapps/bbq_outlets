import 'dart:convert';

import 'package:BBQOUTLETS/AppPages/LoginScreen/LoginScreen.dart';
import 'package:BBQOUTLETS/AppPages/MagentoAdminApis/CustomerApis.dart';
import 'package:BBQOUTLETS/AppPages/Registration/RegistrationPage.dart';
import 'package:BBQOUTLETS/Constants/ConstantVariables.dart';
import 'package:BBQOUTLETS/utils/ApiCalls/ApiCalls.dart';
import 'package:BBQOUTLETS/utils/utils/build_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:ndialog/ndialog.dart';
import 'package:progress_loading_button/progress_loading_button.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with InputValidationMixin {
  late TextEditingController _firstNameController,
      _lastNameController,
      _emailController,
      _passwordController;
  GlobalKey<FormState> formGlobalKey = GlobalKey<FormState>();
  Color _color = Color.fromRGBO(251, 151, 67, 1);

  @override
  void initState() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
    bool isIconAvailable, {
    bool isPassword = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              controller: controller,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onFieldSubmitted: (val) async {
                if (title.contains('Email id') && isEmailValid(val)) {}
              },
              textInputAction: TextInputAction.next,
              validator: (val) {
                if (title.contains('First Name')) {
                  if (isFirstName(val!)) {
                    return null;
                  } else {
                    return 'Please Enter first name';
                  }
                }
                if (title.contains('Last Name')) {
                  if (isLastName(val!)) {
                    return null;
                  } else {
                    return 'Please Enter last name';
                  }
                }
                if (title.contains('Email id')) {
                  if (isEmailValid(val!)) {
                    return null;
                  } else {
                    return 'Please Enter correct email';
                  }
                }

                if (title.contains('Password')) {
                  if (isPasswordValid(val!)) {
                    return null;
                  } else {
                    return 'Atleast 1 uppercase letter.\nAtleast 1 lowercase letter.\nAtleast 1 special letter.\nAtleast 1 numeric letter.';
                  }
                }
              },
              obscureText: isPassword,
              decoration: InputDecoration(
                  // suffixIcon: InkWell(child: Icon(),),
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      width: 100.w,
      child: LoadingButton(
        height: 50,
        color: Colors.orangeAccent.shade100,
        onPressed: () async {
          if (formGlobalKey.currentState!.validate()) {
            // use the information provided
            formGlobalKey.currentState!.save();
            String email = _emailController.text;
            setState(() {});
            print(email);
            await emailCheck(email).then((value) {
              if (value == true) {
                registerCustomer();
              } else {
                Fluttertoast.showToast(msg: 'This email already exists');
              }
            });
          }
        },
        loadingWidget: SpinKitHourGlass(
          color: Colors.white,
          size: 26,
        ),
        defaultWidget: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xfffbb448), Color(0xfff7892b)])),
          child: Text(
            'Register Now',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }

  bool isEmailAvail = true;

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.pop(
          context,
        );
      },
      child: Container(
        // padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () async => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back,
                size: MediaQuery.of(context).size.width * .08,
              ),
            ),
          ),
          Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
            logoImage,
            height: MediaQuery.of(context).size.width * 0.35,
            width: MediaQuery.of(context).size.width * 0.35,
          )),
        ],
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField(
          "First Name",
          _firstNameController,
          false,
        ),
        _entryField(
          "Last Name",
          _lastNameController,
          false,
        ),
        _entryField(
          "Email id",
          _emailController,
          false,
        ),
        _entryField(
          "Password",
          _passwordController,
          true,
          isPassword: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Form(
      key: formGlobalKey,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          body: Container(
            height: height,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: height * .01),
                        _title(),
                        SizedBox(
                          height: 5,
                        ),
                        _emailPasswordWidget(),
                        SizedBox(
                          height: 15,
                        ),
                        _submitButton(),
                        SizedBox(height: height * .02),
                        _loginAccountLabel(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> emailCheck(String email) async {
    final url = Uri.parse(magentoBaseUrl + 'customers/isEmailAvailable?');
    try {
      var response = await post(
        url,
        body: jsonEncode({
          'customerEmail': email,
        }),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );
      print(jsonDecode(response.body));
      isEmailAvail = jsonDecode(response.body);
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      isEmailAvail = false;
      setState(() {});
    }
    return isEmailAvail;
  }

  registerCustomer() async {
    CustomProgressDialog progressDialog = CustomProgressDialog(
      context,
      loadingWidget: const SpinKitPouringHourGlass(color: Colors.orangeAccent),
    );

    final body = {
      'customer': {
        "email": _emailController.text,
        "firstname": _firstNameController.text,
        "lastname": _lastNameController.text,
      },
      'password': _passwordController.text,
    };
    final url = Uri.parse(magentoBaseUrl + 'customers?');
    try {
      progressDialog.show();
      var response = await post(
        url,
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode(body),
      );
      if (jsonDecode(response.body)['website_id'] == 1) {
        progressDialog.dismiss();
        Fluttertoast.showToast(msg: 'Registration Complete.');
        Navigator.pop(context);
      } else {
        progressDialog.dismiss();
        Fluttertoast.showToast(msg: 'Registration Failed!');
      }
      print(response.body);
      progressDialog.dismiss();
    } on Exception catch (e) {
      progressDialog.dismiss();
      ConstantsVar.excecptionMessage(e);
    }
  }
}
