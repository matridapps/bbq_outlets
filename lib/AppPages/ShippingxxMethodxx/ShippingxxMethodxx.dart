import 'dart:convert';
import 'package:BBQOUTLETS/AppPages/HomeScreen/HomeScreen.dart';
import 'package:BBQOUTLETS/AppPages/MagentoAdminApis/CustomerApis.dart';
import 'package:BBQOUTLETS/AppPages/MagentoAdminApis/ShippingMethod.dart';
import 'package:BBQOUTLETS/AppPages/ShippingInform/ShippingInform.dart';
import 'package:BBQOUTLETS/Constants/ConstantVariables.dart';
import 'package:BBQOUTLETS/utils/utils/build_config.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_loading_button/progress_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Responsexx/ShippingxxMethodxxResponse.dart';

class ShippingMethod extends StatefulWidget {
  ShippingMethod({
    Key? key,
    required this.methodList,
  }) : super(key: key);
 final List<ShippingMethodResponsez> methodList;

  @override
  _ShippingMethodState createState() => _ShippingMethodState();
}

class _ShippingMethodState extends State<ShippingMethod> {
  var warning;
  List<MethodList> shippingMethods = [];
  bool isSelected = false;
  var selectedMethodCode = '';
  var selectedCarCode = '';

  Map<String, dynamic> address = {};
  Map<String, dynamic> _shippingaddress = {};

  var customerToken;

  @override
  void initState() {
    super.initState();
    getInitSharedPrefs().then((value) {
      address.remove('same_as_billing');
      address.remove('customer_id');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
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
        body: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        color: Colors.white60,
                        child: Center(
                          child: AutoSizeText(
                            'Select Shipping Method'.toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: Adaptive.w(5)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListView.builder(
                    padding: EdgeInsets.all(10),
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.methodList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Container(
                          child: CheckboxListTile(
                            value: isSelected,
                            onChanged: (bool? value) {
                              setState(() {
                                isSelected = value!;
                                if (isSelected) {
                                  selectedMethodCode =
                                      widget.methodList[index].methodCode;
                                  selectedCarCode =
                                      widget.methodList[index].carrierCode;
                                  print('Seleted Clicks>>>' +
                                      selectedMethodCode +
                                      selectedCarCode);
                                  setState(() {});
                                  print("$isSelected");
                                } else {
                                  print('$isSelected');
                                  selectedMethodCode = '';
                                  selectedCarCode = '';
                                  setState(() {});
                                  print(selectedMethodCode + selectedCarCode);
                                }
                              });
                            },
                            tileColor: Colors.white24,
                            controlAffinity: ListTileControlAffinity.leading,
                            title: AutoSizeText(
                              widget.methodList[index].carrierTitle +
                                  ' (${widget.methodList[index].carrierCode})',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 5.w),
                            ),
                            subtitle: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: AutoSizeText(
                                removeAllHtmlTags(
                                  'Shipping: ' +
                                      widget.methodList[index].methodTitle +
                                      ',\nShipping cost: \$' +
                                      widget.methodList[index].amount
                                          .toString() +
                                      ',\nAvailability: ' +
                                      widget.methodList[index].available
                                          .toString(),
                                ),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 3.w,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: LoadingButton(
                  onPressed: () async {
                    if (isSelected == false) {
                      Fluttertoast.showToast(
                          msg: 'Please select a Shipping Method first');
                    } else {
                      if (mounted)
                        _shippingaddress = {
                          'addressInformation': {
                            'shipping_address': address['address'],
                            'billing_address': address['address'],
                            "shipping_carrier_code": selectedCarCode,
                            "shipping_method_code": selectedMethodCode,
                          }
                        };
                      setState(() {});
                      print(jsonEncode(_shippingaddress));
                      await CustomerApis.shippingInformation(
                        customerToken: customerToken,
                        body: _shippingaddress,
                      ).then(
                        (value) => Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (contex) => ShippingInform(
                              shippingInformation: value,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  defaultWidget: Container(
                    width: double.infinity,
                    height: 50,
                    color: ConstantsVar.appColor,
                    child: Center(
                      child: AutoSizeText(
                        'Confirm'.toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Future<void> getShippingMethods(String customerId) async {
  //   context.loaderOverlay.show(
  //     widget: Center(
  //       child: SpinKitRipple(
  //         color: Colors.red,
  //         size: 90,
  //       ),
  //     ),
  //   );
  //   final uri = Uri.parse(BuildConfig.base_url +
  //       'apis/GetShippingMethod?apiToken=${ConstantsVar.apiTokken}&customerid=$customerId');
  //   try {
  //     print('Shipping method Apis >>>>>> $uri');
  //     var response = await http.get(uri);
  //     print(jsonDecode(response.body));
  //     ShippingMethodResponse methodResponse =
  //         ShippingMethodResponse.fromJson(jsonDecode(response.body));
  //     setState(() {
  //       shippingMethods.addAll(methodResponse.shippingmethods.shippingMethods);
  //     });
  //     context.loaderOverlay.hide();
  //   } on Exception catch (e) {
  //     context.loaderOverlay.hide();
  //
  //     ConstantsVar.excecptionMessage(e);
  //   }
  // }

  Future getInitSharedPrefs() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    address = jsonDecode(ConstantsVar.prefs.getString('shippingAddress')!);
    customerToken = ConstantsVar.prefs.getString('customerToken');
    setState(() {});
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }

// Future<bool> _willGoBack() async {
//   Navigator.pushReplacement(
//     context,
//     CupertinoPageRoute(
//       builder: (context) => ShippingAddress(),
//     ),
//   );
//   return true;
// }
}
