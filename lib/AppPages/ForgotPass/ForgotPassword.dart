import 'package:BBQOUTLETS/AppPages/Registration/RegistrationPage.dart';
import 'package:BBQOUTLETS/Constants/ConstantVariables.dart';
import 'package:BBQOUTLETS/Widgets/widgets/AppBar.dart';
import 'package:BBQOUTLETS/utils/ApiCalls/ApiCalls.dart';
import 'package:BBQOUTLETS/utils/CartBadgeCounter/CartBadgetLogic.dart';
import 'package:BBQOUTLETS/utils/CustomDialog/CustomxxLoginxxCheck.dart';
import 'package:BBQOUTLETS/utils/utils/build_config.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:loader_overlay/loader_overlay.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ForgotPassScreenState createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen>
    with InputValidationMixin {
  TextEditingController emailController = TextEditingController();

  // TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> _forgotState = GlobalKey<FormState>();
  String _adminToken = '';

  @override
  void initState() {
    // TODO: implement initState
    initSharedPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ConstantsVar.appColor,
          centerTitle: true,
          toolbarHeight: 14.w,
          title: Image.asset(
            logoImage,
            width: 13.w,
            height: 13.w,
          ),
        ),
        extendBodyBehindAppBar: false,
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
          onTap: () {
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Form(
            key: _forgotState,
            child: SizedBox(
              width: ConstantsVar.width,
              height: ConstantsVar.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: AppBarLogo('RECOVER PASSWORD', context),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AutoSizeText(
                            'ENTER YOUR EMAIL',
                            textAlign: TextAlign.center,
                            style:  GoogleFonts.montserrat(
                              fontSize: 5.5.w,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),

                            softWrap: false,
                            // maxLines: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20.0,
                            left: 10,
                            right: 10,
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            elevation: 8.0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              child: TextFormField(
                                validator: (email) {
                                  if (isEmailValid(email!)) {
                                    return null;
                                  } else {
                                    return 'Enter a valid email address';
                                  }
                                },
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                controller: emailController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                cursorColor: Colors.black,
                                style: GoogleFonts.montserrat(
                                  fontSize: 3.5.w,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                decoration: editBoxDecoration(
                                    'Email Address',
                                    Icon(
                                      Icons.email_outlined,
                                      color: ConstantsVar.appColor,
                                    ),
                                    '',
                                    currentFocus),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: ConstantsVar.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: RaisedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                color: ConstantsVar.appColor,
                                shape: const RoundedRectangleBorder(),
                                child: SizedBox(
                                  height: 50,
                                  width: ConstantsVar.width / 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                      child: AutoSizeText(
                                        "CANCEL",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 3.5.w,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                          Expanded(
                            child: RaisedButton(
                              onPressed: () {
                                if (_forgotState.currentState!.validate()) {
                                  _forgotState.currentState!.save();
                                  Provider.of<cartCounter>(context,
                                          listen: false)
                                      .forgotPassword(
                                          emailId: emailController.text,
                                          adminToken: _adminToken,
                                          ctx: context);
                                } else {}
                              },
                              color: ConstantsVar.appColor,
                              shape: const RoundedRectangleBorder(),
                              child: SizedBox(
                                height: 50,
                                width: MediaQuery.of(context).size.width / 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: AutoSizeText(
                                      'CONFIRM',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 3.5.w,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration editBoxDecoration(
      String name, Icon icon, String prefixText, FocusScopeNode myFocusNode) {
    return InputDecoration(
      prefixText: prefixText,
      prefixIcon: icon,
      labelStyle: TextStyle(
          fontSize: 5.w,
          color: myFocusNode.hasFocus ? ConstantsVar.appColor : Colors.grey),
      labelText: name,
      border: InputBorder.none,
      counterText: '',
    );
  }

  void initSharedPreferences() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    _adminToken = ConstantsVar.prefs.getString('adminToken')!;
    setState(() {});
  }
}
