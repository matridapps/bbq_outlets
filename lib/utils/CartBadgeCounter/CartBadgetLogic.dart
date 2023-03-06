// ignore_for_file: prefer_typing_uninitialized_variables, camel_case_types

import 'dart:async';
import 'dart:convert';

import 'package:BBQOUTLETS/AppPages/CartxxScreen/CartScreen2.dart';
import 'package:BBQOUTLETS/AppPages/ChangePassword/ChangePassword.dart';
import 'package:BBQOUTLETS/AppPages/MagentoAdminApis/CustomerApis.dart';
import 'package:BBQOUTLETS/AppPages/MagentoAdminApis/MyOrderRespose.dart';
import 'package:BBQOUTLETS/AppPages/MyOrders/MyOrders.dart';
import 'package:BBQOUTLETS/Constants/ConstantVariables.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../new_screen/search_model/search_model.dart';
import '../utils/build_config.dart';

class cartCounter extends ChangeNotifier with DiagnosticableTreeMixin {
  int _bagdgeNumber = 0;
  String _productID = '';
  String _categoryId = '';
  String _title = '';
  MyOrdersResponse? _response;
  bool _isLoading = false;
  var _passwordChange;
  var _forgotPassword;
  IconData _icon = Icons.circle_outlined;
  BBQSearchResponse? _resultResponse;

  IconData get icon => _icon;

  BBQSearchResponse? get resultResponse => _resultResponse;

  get passwordChange => _passwordChange;

  int get badgeNumber => _bagdgeNumber;

  String get productID => _productID;

  String get categoryID => _categoryId;

  String get title => _title;

  MyOrdersResponse get response => _response!;

  bool get isLoading => _isLoading;

  void changeCounter(int cartCounter) {
    _bagdgeNumber = 0;
    _bagdgeNumber = _bagdgeNumber + cartCounter;
    notifyListeners();
  }

  void getProductID(String productID) {
    _productID = productID;
    notifyListeners();
  }

  void getCategoryID(String categoryID) {
    _categoryId = categoryID;
    notifyListeners();
  }

  void getTitle(String title) {
    _title = title;
    notifyListeners();
  }

  void getOrders(
      {required String adminToken, required String customerEmail}) async {
    _isLoading = true;
    _response = await CustomerApis.getMyOrder(
        emailId: customerEmail, adminToken: adminToken);
    _isLoading = false;
    notifyListeners();
  }

  void resetPassword(
      {required String customerId,
      required String adminToken,
      required BuildContext ctx,
      required String oldPassword,
      required String newPassword}) async {
    _isLoading = true;
    _passwordChange = await CustomerApis.resetPassword(
      customerId: customerId,
      adminToken: adminToken,
      ctx: ctx,
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
    if (_passwordChange.runtimeType != bool) {
      MotionToast.error(description: Text(_passwordChange.toString()))
          .show(ctx);
    } else {
      _passwordChange == false
          ? showModalBottomSheet<void>(
              context: ctx,
              builder: (BuildContext context) {
                return SizedBox(
                  width: 100.w,
                  height: 18.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        'Changing password failed.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 4.w,
                            color: Colors.white),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AppButton(
                            color: Colors.black,
                            child: SizedBox(
                              width: 30.w,
                              child: const Center(
                                child: Text(
                                  'Okay',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () => Navigator.pop(
                              context,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            )
          : showModalBottomSheet<void>(
              context: ctx,
              builder: (BuildContext context) {
                return SizedBox(
                  width: 100.w,
                  height: 18.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        'Password has been changed',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 4.w,
                            color: Colors.white),
                      ),
                      AppButton(
                        color: Colors.black,
                        child: SizedBox(
                          width: 30.w,
                          child: const Center(
                            child: Text(
                              'Okay',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        onTap: () => CustomerApis.clearUserDetails()
                            .whenComplete(() => Phoenix.rebirth(context)),
                      ),
                    ],
                  ),
                );
              },
            );
    }

    _isLoading = false;
    notifyListeners();
  }

  void forgotPassword({
    required String emailId,
    required String adminToken,
    required BuildContext ctx,
  }) async {
    _isLoading = true;
    _forgotPassword = await CustomerApis.forgotPassword(
      emailId: emailId,
      adminToken: adminToken,
      ctx: ctx,
    );
    if (_forgotPassword.runtimeType != bool) {
      MotionToast.error(description: Text(_forgotPassword.toString()))
          .show(ctx);
    } else {
      _forgotPassword == false
          ? showDialog(
              context: ctx,
              builder: (ctx) => customDialog(
                  description: 'Something went wrong!.', context: ctx))
          : showDialog(
              context: ctx,
              builder: (ctx) => customDialog(
                  description:
                      'A mail has been sent to your Email with instructions to reset your password.',
                  context: ctx));
    }

    _isLoading = false;
    notifyListeners();
  }

  void showModelSheet({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String emailId,
  }) {
    showModalBottomSheet<void>(
      elevation: 10,
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: false,
      builder: (_context) {
        return ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 1,
                horizontal: 3.w,
              ),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Information',
                        style: GoogleFonts.montserrat(
                          fontSize: 5.w,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 40.w,
                        child: const Divider(thickness: 2, color: Colors.orange),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'First Name: ',
                          style: GoogleFonts.montserrat(
                            fontSize: 3.8.w,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: firstName,
                              style: GoogleFonts.montserrat(
                                fontSize: 3.4.w,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 40.w,
                        child: const Divider(thickness: 2, color: Colors.orange),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Last Name: ',
                          style: GoogleFonts.montserrat(
                            fontSize: 3.8.w,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: lastName,
                              style: GoogleFonts.montserrat(
                                fontSize: 3.4.w,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 40.w,
                        child: const Divider(thickness: 2, color: Colors.orange),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Email Id: ',
                          style: GoogleFonts.montserrat(
                            fontSize: 3.8.w,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: emailId,
                              style: GoogleFonts.montserrat(
                                fontSize: 3.4.w,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 63.w,
                        child: const Divider(thickness: 2, color: Colors.orange),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 1,
                horizontal: 3.w,
              ),
              child: Card(
                child: ExpansionTile(
                  children: [
                    ListView(
                      shrinkWrap: true,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        DelayedDisplay(
                          delay: const Duration(
                            milliseconds: 70,
                          ),
                          child: InkWell(
                            onTap: () async {
                              ConstantsVar.prefs =
                                  await SharedPreferences.getInstance();

                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => const MyOrders(
                                      isFromWeb: false,
                                    ),
                                  ));
                            },
                            child: Card(
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 3,
                                  horizontal: 3.w,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.shopping_bag,
                                      color: ConstantsVar.appColor,
                                      size: 34,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    AutoSizeText(
                                      'my orders'.toUpperCase(),
                                      style: GoogleFonts.montserrat(
                                        fontSize: 4.5.w,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DelayedDisplay(
                          delay: const Duration(
                            milliseconds: 70,
                          ),
                          child: InkWell(
                            // Fluttertoast.showToast(msg:'In Progress'),

                            onTap: () async {
                              pushNewScreen(
                                context,
                                screen: ChangePassword(),
                                withNavBar: false,
                                // OPTIONAL VALUE. True by default.
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino,
                              );
                            },
                            child: Card(
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 3,
                                  horizontal: 3.w,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.password,
                                      color: ConstantsVar.appColor,
                                      size: 34,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    AutoSizeText(
                                      'change password'.toUpperCase(),
                                      style: GoogleFonts.montserrat(
                                        fontSize: 4.5.w,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                  ],
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_circle_sharp,
                        color: ConstantsVar.appColor,
                        size: 30,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      AutoSizeText(
                        'My Account'.toUpperCase(),
                        style: GoogleFonts.montserrat(
                          fontSize: 4.5.w,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 1,
                horizontal: 3.w,
              ),
              child: Card(
                child: ListTile(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => CartScreen2(
                        isOtherScren: false,
                        otherScreenName: '',
                      ),
                    ),
                  ),
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        color: ConstantsVar.appColor,
                        size: 30,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      AutoSizeText(
                        'My Cart'.toUpperCase(),
                        style: GoogleFonts.montserrat(
                          fontSize: 4.5.w,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 1,
                horizontal: 3.w,
              ),
              child: Card(
                child: ListTile(
                  onTap: () {
                    CustomerApis.clearUserDetails()
                        .whenComplete(() => Phoenix.rebirth(context));
                  },
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_circle_sharp,
                        color: ConstantsVar.appColor,
                        size: 28,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      AutoSizeText(
                        'logout'.toUpperCase(),
                        style: GoogleFonts.montserrat(
                          fontSize: 4.5.w,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        );
      },
    );
    notifyListeners();
  }

  Widget customDialog({
    required BuildContext context,
    required String description,
  }) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SizedBox(
        width: 100.w,
        height: 35.h,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                top: 25,
                right: 10,
              ),
              child: Container(
                margin: const EdgeInsets.only(top: 35),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, 10),
                        blurRadius: 10),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                        description,
                        style: GoogleFonts.montserrat(
                          fontSize: 3.5.w,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: FlatButton(
                          color: Colors.black,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            color: Colors.black,
                            child: const AutoSizeText(
                              'OKAY',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                child: Image.asset("BBQ_Images/bbqologomaster.png"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void changeIcon({required bool val}) {
    val == false ? _icon = Icons.circle_outlined : _icon = Icons.circle;
    notifyListeners();
  }

  Future searchProduct({required String query}) async {
    // = '';
    ConstantsVar.storage = const FlutterSecureStorage();
    String _token = await ConstantsVar.storage.read(
          key: 'adminToken',
        ) ??
        '';

    final _header = {'Authorization': 'Bearer $_token'};

    final uri = Uri.parse(magentoBaseUrl +
        'products?' +
        'searchCriteria[filter_groups][0][filters][0][field]=name&searchCriteria[filter_groups][0][filters][0][condition_type]=like&searchCriteria[pageSize]=50&searchCriteria[filter_groups][0][filters][0][value]=%25$query%25');
    try {
      var response = await get(uri, headers: _header);
      log(response.body);
      if (jsonDecode(response.body)['message'] == null) {
        _resultResponse = BBQSearchResponse.fromJson(jsonDecode(response.body));
        // _isLoading = false;
      } else {
        Fluttertoast.showToast(msg: jsonDecode(response.body)['message']);
        _resultResponse = BBQSearchResponse(items: [], totalCount: 0);
        // _isLoading = false;
        // notifyListeners();
      }
    } on Exception catch (e) {
      // _isLoading = false;
      ConstantsVar.excecptionMessage(e);
      _resultResponse = BBQSearchResponse(items: [], totalCount: 0);
      // notifyListeners();
    }
    // return _resultResponse;

    // notifyListeners();
  }

  String _query = '';

  String get query => _query;

  void onQueryChanged(
    String query,
  ) async {
    if (query == _query) return;

    _query = query;
    _isLoading = true;
    notifyListeners();

    if (query.isEmpty) {
      _suggestions = history;
    } else if (query.length >= 3) {
      _suggestions = history;
    }

    _isLoading = false;
    notifyListeners();
  }

  List<String> _suggestions = history;

  List<String> get suggestions => _suggestions;

  void searchMyProduct({required String keyword}) async {
    _isLoading = true;
    await searchProduct(query: keyword);
    _isLoading = false;
    notifyListeners();
  }

// Stream<BBQSearchResponse> get _stream => _streamController.stream;
}

const List<String> history = ['Burner', 'Grills', 'Ovens', 'Firepits'];
