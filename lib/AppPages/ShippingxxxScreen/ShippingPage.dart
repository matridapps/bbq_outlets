import 'dart:convert';
// import 'package:BBQOUTLETS/AppPages/ShippingxxxScreen/CountryResponseModel.dart';

import 'package:BBQOUTLETS/AppPages/HomeScreen/HomeScreen.dart';
import 'package:BBQOUTLETS/AppPages/MagentoAdminApis/CustomerApis.dart';
import 'package:BBQOUTLETS/AppPages/MagentoAdminApis/StateModel.dart';
import 'package:BBQOUTLETS/AppPages/Registration/RegistrationPage.dart';
import 'package:BBQOUTLETS/AppPages/ShippingxxMethodxx/ShippingxxMethodxx.dart';

// import 'package:BBQOUTLETS/AppPages/ShippingxxxScreen/CountryResponseModel.dart';
import 'package:BBQOUTLETS/Constants/ConstantVariables.dart';
import 'package:BBQOUTLETS/utils/utils/build_config.dart';
import 'package:BBQOUTLETS/utils/utils/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
// import 'package:loader_overlay/loader_overlay.dart';
import 'package:menu_button/menu_button.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:progress_loading_button/progress_loading_button.dart';
// import 'StateModel.dart';

import 'BillingxxScreen/ShippingAddress.dart';

// import '../ShippingxxMethodxx/CountryResponseModel.dart';
class AddBillingDetails extends StatefulWidget {
  AddBillingDetails({Key? key, required this.customerId, required this.tokken})
      : super(key: key);
  String customerId;
  final tokken;

  @override
  _AddBillingDetailsState createState() => _AddBillingDetailsState();
}

class _AddBillingDetailsState extends State<AddBillingDetails>
    with InputValidationMixin {
  late TextEditingController _firstNameController1;
  late TextEditingController _phoneController;
  late TextEditingController textController3;
  late TextEditingController textController4;
  late TextEditingController textController5;
  late TextEditingController _cityController;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode myFocusNode = new FocusNode();

  var countryController = TextEditingController();

  var _lastNameController = TextEditingController();

  var _streetController = TextEditingController();

  var eController = TextEditingController();
  late CountryResponseModel model;
  List<CountryResponseModel> _mList = [];
  List<AvailableRegion> _mStateList = [];
  bool isVisible = true;
  String _name = 'Select your country', _stateName = 'Select your state';

  var _companytextController = TextEditingController();

  var _postalCodeController = TextEditingController();

  var _stateController = TextEditingController();

  int isBillingSelected = 1;

  var _regionName = '';

  var _regionId = '';

  var _regionCode = '';

  var _countryId = '';



  var customerID = '';

  var customerToken;

  @override
  void initState() {
    super.initState();
    _firstNameController1 = TextEditingController();
    _phoneController = TextEditingController();
    textController3 = TextEditingController();
    textController4 = TextEditingController();
    textController5 = TextEditingController();
    _cityController = TextEditingController();
    initSharedPrefs();
    CustomerApis.getCountryCode(ctx: context).then((value) {
      _mList = value;
      // _mList.sort();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Scaffold(
        appBar: new AppBar(
            backgroundColor: ConstantsVar.appColor,
            toolbarHeight: 14.w,
            centerTitle: true,
            title: GestureDetector(
              onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(builder: (context) => MyApp()),
                  (route) => false),
              child: Image.asset(
                logoImage,
                width: 13.w,
                height: 13.w,
              ),
            )),
        resizeToAvoidBottomInset: true,
        key: scaffoldKey,
        body: WillPopScope(
          onWillPop: _willGoBack,
          child: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Color(0xFFEEEEEE),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color(0xFFEEEEEE),
                    ),
                    child: Align(
                      alignment: Alignment(0.05, 0),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: AutoSizeText(
                          'Shipping ADDRESS'.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 6.5.w,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      scrollDirection: Axis.vertical,
                      children: [
                        Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              onChanged: (_) => setState(() {}),
                              controller: _firstNameController1,
                              obscureText: false,
                              decoration: editBoxDecoration(
                                'FIRST NAME'.toUpperCase(),
                                Icon(
                                  Icons.person_outline,
                                  color: ConstantsVar.appColor,
                                ),
                                '',
                                '*',
                              ),
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 4.w,
                              ),
                              maxLines: 1,
                              validator: (val) {
                                if (isFirstName(val!))
                                  return null;
                                else
                                  return 'Please Enter Your First Name';
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              onChanged: (_) => setState(() {}),
                              controller: _lastNameController,
                              obscureText: false,
                              decoration: editBoxDecoration(
                                'last Name'.toUpperCase(),
                                Icon(
                                  Icons.person_outline,
                                  color: Colors.orangeAccent,
                                ),
                                '',
                                '*',
                              ),
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 4.w,
                              ),
                              maxLines: 1,
                              validator: (val) {
                                if (isLastName(val!))
                                  return null;
                                else
                                  return 'Please Enter Your Last Name';
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              onChanged: (_) => setState(() {}),
                              controller: _companytextController,
                              obscureText: false,
                              decoration: editBoxDecoration(
                                'Company'.toUpperCase(),
                                Icon(
                                  Icons.person_outline,
                                  color: Colors.orangeAccent,
                                ),
                                '',
                                '',
                              ),
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 4.w,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 4.0,
                          child: Container(
                            padding: EdgeInsets.only(right: 12.0),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                controller: _streetController,
                                validator: (val) {
                                  if (isAddress(val!))
                                    return null;
                                  else
                                    return 'Enter your Street Address';
                                },
                                cursorColor: Colors.black,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 4.w,
                                ),
                                maxLines: 3,
                                decoration: editBoxDecoration(
                                  'Street Address'.toUpperCase(),
                                  Icon(
                                    Icons.home_outlined,
                                    color: ConstantsVar.appColor,
                                  ),
                                  '',
                                  '*',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 100.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 100.w,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Country',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 4.w,
                                          ),
                                        ),
                                        Text(
                                          '*',
                                          style: TextStyle(
                                            color: Colors.orangeAccent,
                                            fontSize: 4.w,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  MenuButton(
                                      crossTheEdge: true,
                                      onItemSelected:
                                          (CountryResponseModel value) {
                                        if (mounted) _mStateList.clear();
                                        _regionName = '';
                                        _regionId = '';
                                        _regionCode = '';
                                        _countryId = '';
                                        _countryId = value.id;
                                        _name = value.fullNameEnglish;
                                        _mStateList = value.availableRegions;
                                        value.availableRegions.length == 0
                                            ? setState(() => isVisible = false)
                                            : setState(() => isVisible = true);
                                        setState(() {});
                                      },
                                      scrollPhysics:
                                          AlwaysScrollableScrollPhysics(),
                                      child: _normalWidget(_name),
                                      items: List.generate(_mList.length,
                                          (index) => _mList[index]),
                                      itemBuilder:
                                          (CountryResponseModel value) {
                                        return Container(
                                            width: 100.w,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child:
                                                    Text(value.fullNameEnglish),
                                              ),
                                            ));
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: isVisible,
                          child: SizedBox(
                            height: 10,
                          ),
                        ),
                        Visibility(
                          visible: isVisible,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 100.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 100.w,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'State',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 4.w,
                                            ),
                                          ),
                                          Text(
                                            '*',
                                            style: TextStyle(
                                              color: Colors.orangeAccent,
                                              fontSize: 4.w,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    MenuButton<AvailableRegion>(
                                        onItemSelected:
                                            (AvailableRegion value) {
                                          if (mounted) _regionName = '';
                                          _regionId = '';
                                          _regionCode = '';
                                          _regionName = value.name;
                                          _regionId = value.id;
                                          _regionCode = value.code;
                                          _stateName = value.name;
                                        },
                                        crossTheEdge: true,
                                        scrollPhysics:
                                            AlwaysScrollableScrollPhysics(),
                                        child: _normalWidget(_regionName),
                                        items: List.generate(_mStateList.length,
                                            (index) => _mStateList[index]),
                                        itemBuilder: (AvailableRegion value) {
                                          return _normalWidget(value.name);
                                        }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: !isVisible,
                          child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                onChanged: (_) => setState(() {}),
                                controller: _stateController,
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: 'Please Enter Your State Name',
                                  prefixIcon: Icon(
                                    Icons.location_city_outlined,
                                    color: ConstantsVar.appColor,
                                  ),
                                  labelText: 'state'.toUpperCase(),
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  suffixText: '*',
                                ),
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 4.w,
                                ),
                                maxLines: 1,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please Provide Your State';
                                  }

                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              onChanged: (_) => setState(() {}),
                              controller: _cityController,
                              obscureText: false,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.location_city_outlined,
                                  color: ConstantsVar.appColor,
                                ),
                                labelText: 'CITY'.toUpperCase(),
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                suffixText: '*',
                              ),
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 4.w,
                              ),
                              maxLines: 1,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please Provide Your City';
                                }

                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  onChanged: (_) => setState(() {}),
                                  controller: _postalCodeController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.location_city_outlined,
                                      color: ConstantsVar.appColor,
                                    ),
                                    labelText: 'Postal code'.toUpperCase(),
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    suffixText: '*',
                                  ),
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 4.w,
                                  ),
                                  maxLines: 1,
                                  validator: (val) {
                                    if (val!.isEmpty &&
                                        isVisible == false &&
                                        val.length == 6) {
                                      return 'Please Provide Your Postal Code';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                    'Note:Please enter your postal code carefully.'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                maxLength: 9,
                                onChanged: (_) => setState(() {}),
                                controller: _phoneController,
                                obscureText: false,
                                decoration: editBoxDecoration(
                                    'phone number'.toUpperCase(),
                                    Icon(
                                      Icons.phone,
                                      color: ConstantsVar.appColor,
                                    ),
                                    '',
                                    '*'),
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 4.w,
                                ),
                                keyboardType: TextInputType.number,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please Enter Your Phone Number';
                                  }
                                  if (val.length < 9) {
                                    return 'Please Enter Your Number Correctly';
                                  }
                                  if (val.length > 9) {
                                    return 'Please Enter Your Number Correctly';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 10),
                            child: AutoSizeText(
                                'For Now Shipping Address is also selected as billing address'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingButton(
                        color: ConstantsVar.appColor,
                        width: 50.w,
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => ShippingAddress(),
                          ),
                        ),
                        defaultWidget: AutoSizeText(
                          'CANCEL',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Work Sans',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      LoadingButton(
                        loadingWidget: SpinKitPouringHourGlass(
                          color: Colors.white,
                          size: 40,
                        ),
                        color: ConstantsVar.appColor,
                        width: 50.w,
                        onPressed: () async {
                          if (formKey.currentState!.validate() &&
                              _countryId.length != 0) {
                            formKey.currentState!.save();
                            var shippingAddress = {
                              "address": {
                                "region": "$_regionName",
                                "region_id": _regionId == null?52:_regionId,
                                "region_code": "${_regionCode == ''||_regionCode == null?'NY':_regionCode}",
                                "country_id": "$_countryId",
                                "street": ["${_streetController.text}"],
                                "postcode": "${_postalCodeController.text}",
                                "city": "${_cityController.text}",
                                "firstname": "${_firstNameController1.text}",
                                "lastname": "${_lastNameController.text}",
                                "customer_id": customerID,
                                "same_as_billing": isBillingSelected,
                              }
                            };
                            ConstantsVar.prefs.setString(
                                'shippingAddress', jsonEncode(shippingAddress));
                            print(jsonEncode(shippingAddress));
                            await CustomerApis.getShippingMethod(
                                    customerToken: customerToken,
                                    body: shippingAddress)
                                .then(
                              (value) => pushNewScreen(
                                context,
                                withNavBar: false,
                                screen: ShippingMethod(methodList: value),
                              ),
                            );
                            Fluttertoast.showToast(
                                msg: jsonEncode(shippingAddress));
                          } else {
                            Fluttertoast.showToast(
                                msg: 'Please provide correct details');
                          }
                        },
                        defaultWidget: Center(
                          child: AutoSizeText(
                            'CONTINUE',
                            style: TextStyle(
                              fontFamily: 'Work Sans',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
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
      String name, Icon icon, String prefixText, String suffixText) {
    return new InputDecoration(
      counterText: '',
      prefixText: prefixText,
      prefixIcon: icon,
      suffixText: suffixText,
      suffixStyle: TextStyle(
        color: Colors.orangeAccent,
        fontFamily: 'Poppins',
        fontSize: 4.w,
      ),
      // alignLabelWithHint: true,
      labelStyle: TextStyle(
          fontSize: myFocusNode.hasFocus ? 20 : 16.0,
          //I believe the size difference here is 6.0 to account padding
          color:
              myFocusNode.hasFocus ? AppColor.PrimaryAccentColor : Colors.grey),
      labelText: name,

      border: InputBorder.none,
    );
  }

  Future<void> initSharedPrefs() async {
    if (mounted) ConstantsVar.prefs = await SharedPreferences.getInstance();
    customerID = ConstantsVar.prefs.getString('customerId')!;
    customerToken = ConstantsVar.prefs.getString('customerToken')!;
    setState(() {});
  }

  Future addShippingAddress(String encodedResponse) async {
    final uri = Uri.parse(BuildConfig.base_url +
        'apis/AddSelectNewShippingAddress?apiToken=${widget.tokken}&customerid=${widget.customerId}&ShippingAddressModel=$encodedResponse');
    try {
      var response = await http.post(uri);
      print('Response>>>>>>>' + response.body);
      return json.decode(response.body);
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  Future<bool> _willGoBack() async {
    Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: (context) => ShippingAddress()));
    return true;
  }

  Widget _normalWidget(String _name) => SizedBox(
        width: 100.w,
        height: 60,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 11),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                  child: Text(_name == null ? '' : _name,
                      overflow: TextOverflow.ellipsis)),
              const SizedBox(
                width: 12,
                height: 17,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
