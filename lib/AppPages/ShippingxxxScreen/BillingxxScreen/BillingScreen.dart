import 'dart:convert';

import 'package:BBQOUTLETS/AppPages/CustomLoader/CustomLoader.dart';
import 'package:BBQOUTLETS/AppPages/HomeScreen/HomeScreen.dart';
import 'package:BBQOUTLETS/AppPages/models/AddressResponse.dart';
import 'package:BBQOUTLETS/Constants/ConstantVariables.dart';
import 'package:BBQOUTLETS/PojoClass/NetworkModelClass/CartModelClass/CartModelMagento.dart';
import 'package:BBQOUTLETS/Widgets/CustomButton.dart';
import 'package:BBQOUTLETS/utils/ApiCalls/ApiCalls.dart';
import 'package:BBQOUTLETS/utils/CartBadgeCounter/CartBadgetLogic.dart';
import 'package:BBQOUTLETS/utils/utils/general_functions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AddressForm.dart';

class BillingDetails extends StatefulWidget {
  BillingDetails({Key? key}) : super(key: key);
  @override
  _BillingDetailsState createState() => _BillingDetailsState();
}

class _BillingDetailsState extends State<BillingDetails>
    with WidgetsBindingObserver {
  var gUId;
  bool isCartAvail = true;
  var customerId;
  var guestCustomerID;
  var customercartquantity;
  var eController = TextEditingController();
  bool showLoading = false;
  bool showAddresses = false;
  late AddressResponse addressResponse;
  late List<ExistingAddresses> existingAddress = [];
  List<ItemCart> cartItems = [ ];
//  OrderSummaryResponse? orderSummaryResponse;
  CartModelMagentoApi? orderSummaryResponse;

  bool showCartSummary = false;
  var guestCustomerId;
  var apiToken;

  @override
  void initState() {
    getCustomerId().then((value) => setState(() => customerId = value));
    ApiCalls.readCounter( context: context).then((value) => context.read<cartCounter>().changeCounter(value));
    showAndUpdateUi();

    /*context.loaderOverlay.show(
        widget: SpinKitRipple(
      color: Colors.red,
      size: 90,
    ));*/

    super.initState();
    WidgetsBinding.instance.addObserver(this);
     getCustomerId().then((value) =>
        ApiCalls.getBillingAddress(ConstantsVar.apiTokken.toString(), value, context)
            .then((value) {
          print(value);

          setState(() {

            addressResponse = AddressResponse.fromJson(value);
            existingAddress = addressResponse.billingaddresses.existingAddresses;
            print('address>>> $addressResponse');
            showAddresses = true;

         /*    ************************Get all order summary******************** */

            ApiCalls.showOrderSummary(ConstantsVar.apiTokken.toString(), guestCustomerId).then((value) {
              print('ordersummary>>> $value');
              orderSummaryResponse = CartModelMagentoApi.fromJson(value);
              print('odrerv $orderSummaryResponse');
              setState(() {
                ConstantsVar.orderSummaryResponse = jsonEncode(orderSummaryResponse);
                String orderSummary = ConstantsVar.orderSummaryResponse;
                ConstantsVar.orderSummaryResponse = orderSummary;
                print('abc $orderSummary');
              });
            });
            /* ********************** End of order summary ***************** */
          });
        }));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:

        break;

      case AppLifecycleState.paused:
        break;

      case AppLifecycleState.inactive:
        break;

      case AppLifecycleState.detached:
        break;
    }
  }

  bool isLoading = false;



  @override
  Widget build(BuildContext context) {

    /*if (orderSummaryResponse == null) {
      return Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
      );
    } else {*/

    return SafeArea(
      top: true,
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 18.w,
            backgroundColor: ConstantsVar.appColor,
            title: InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => MyHomePage(
                        pageIndex: 0,
                      ),
                    ),
                    (route) => false);
              },
              child: Image.asset(
                'MyAssets/logo.png',
                width: 15.w,
                height: 15.w,
              ),
            ),
            centerTitle: true,
          ),
          body: Stack(children: [
           Container (
             height: 100.h,

              child: ListView(
                children: <Widget>[
                  Expanded(
                      child: Card(
                    elevation: 3,
                    child: Container(
                      width: 100.w,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: AutoSizeText(
                            'Billing Details'.toUpperCase(),
                            style: TextStyle(
                                fontSize: 6.w, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  )),
                  Visibility(
                      visible: existingAddress.isEmpty ? true : true,
                      child: addVerticalSpace(12.0)),
                  Visibility(
                    visible: existingAddress.isEmpty ? true : true,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                          margin: EdgeInsets.only(left: 10.0),
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: AutoSizeText(
                              'Select a Billing Address',
                              style: TextStyle(
                                  fontSize: 6.4.w, fontWeight: FontWeight.bold),
                            ),
                          )),
                    ),
                  ),

                  /************** Show Address List ******************/
                  Visibility(
                      visible: existingAddress.isEmpty ? true : true,
                      child: Expanded(
                        child: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          /*children: List.generate(
                            existingAddress.length,
                            (index) => AddressItem(
                                  buttonName: "Bill To This Address",
                                  firstName: existingAddress[index].firstName,
                                  lastName: existingAddress[index].lastName,
                                  email: existingAddress[index].email,
                                  companyEnabled:
                                      existingAddress[index].companyEnabled,
                                  companyRequired:
                                      existingAddress[index].companyRequired,
                                  countryEnabled:
                                      existingAddress[index].countryEnabled,
                                  countryId: existingAddress[index].countryId,
                                  countryName:
                                      existingAddress[index].countryName,
                                  stateProvinceEnabled: existingAddress[index]
                                      .stateProvinceEnabled,
                                  cityEnabled:
                                      existingAddress[index].cityEnabled,
                                  cityRequired:
                                      existingAddress[index].cityRequired,
                                  city: existingAddress[index].city,
                                  streetAddressEnabled: existingAddress[index]
                                      .streetAddressEnabled,
                                  streetAddressRequired: existingAddress[index]
                                      .streetAddressRequired,
                                  address1: existingAddress[index].address1,
                                  streetAddress2Enabled: existingAddress[index]
                                      .streetAddress2Enabled,
                                  streetAddress2Required: existingAddress[index]
                                      .streetAddress2Required,
                                  zipPostalCodeEnabled: existingAddress[index]
                                      .zipPostalCodeEnabled,
                                  zipPostalCodeRequired: existingAddress[index]
                                      .zipPostalCodeRequired,
                                  zipPostalCode:
                                      existingAddress[index].zipPostalCode,
                                  phoneEnabled:
                                      existingAddress[index].phoneEnabled,
                                  phoneRequired:
                                      existingAddress[index].phoneRequired,
                                  phoneNumber:
                                      existingAddress[index].phoneNumber,
                                  faxEnabled: existingAddress[index].faxEnabled,
                                  faxRequired:
                                      existingAddress[index].faxRequired,
                                  faxNumber: existingAddress[index].faxNumber,
                                  id: existingAddress[index].id,
                                  callback: (String value) {},
                                  guestId: guestCustomerId,
                                  // isLoading: isLoading,
                                )),*/
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 40.0,
                      bottom: 10,
                    ),
                    child: Container(
                        // margin: EdgeInsets.only(left: 10.0),
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: AutoSizeText(
                            'Or Add a New Billing Address',
                            style: TextStyle(
                                fontSize: 6.4.w, fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          textStyle: TextStyle(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        onPressed: () async {
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) {
                            return AddressScreen(
                              uri: 'AddSelectNewBillingAddress',
                              isShippingAddress: false,
                              isEditAddress: false,
                              firstName: '',
                              lastName: '',
                              email: '',
                              address1: '',
                              countryName: '',
                              city: '',
                              phoneNumber: '',
                              id: 0,
                              faxNumber: '',
                              company: '',
                              title: 'billing address',
                              btnTitle: 'Continue',
                            );
                          }));
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50.0),
                          child: Container(
                            height: 6.h,
                            decoration: BoxDecoration(
                                color: ConstantsVar.appColor,
                                borderRadius: BorderRadius.circular(6.0)),
                            child: Center(
                              child: AutoSizeText(
                                'Add New Address',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 4.w),
                              ),
                            ),
                          ),
                        ),
                      )),

                  /**************** Show order summary here ****************/
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Card(
                        color: Colors.white60,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Center(
                              child: AutoSizeText(
                                'Order Summary',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 6.4.w),
                              ),
                            ),
                          ),
                        )),
                  ),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(4.0),
                        itemCount: cartItems != null
                            ? cartItems.length
                            : 0,
                      //  itemCount:cartItems.length,
                        itemBuilder: (context, index) {
                          return cartItemView(
                              //  orderSummaryResponse!.ordersummary.items[index]);
                             // orderSummaryResponse!.items[index]
                              cartItems[index]

                          );
                        }),
                  ),
                  Flexible(
                    child: Card(
                      elevation: 10,
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xFFEEEEEE),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AutoSizeText(
                                    'Sub-Total:',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 15,
                                    ),
                                  ),
                                  AutoSizeText(
                                    "subTotal"
                                        .toString(),
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AutoSizeText(
                                    'Shipping:',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 15,
                                    ),
                                  ),
                                  /* AutoSizeText(
                                    orderSummaryResponse!
                                        .ordertotals.shipping
                                         == null
                                        ? 'During Checkout '
                                        : orderSummaryResponse!
                                            .ordertotals.shipping
                                            .toString(),
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  )*/
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Visibility(
                                visible: true,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    /* Visibility(
                                      visible: orderSummaryResponse!.ordertotals
                                                  .orderTotalDiscount ==
                                              null
                                          ? false
                                          : true,
                                      child: AutoSizeText(
                                        'Discount:',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: orderSummaryResponse!.ordertotals
                                                  .orderTotalDiscount ==
                                              null
                                          ? false
                                          : true,
                                      child: AutoSizeText(
                                        orderSummaryResponse!
                                            .ordertotals.orderTotalDiscount
                                            .toString(),
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )*/
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 4.0, right: 4.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AutoSizeText(
                                    'Tax 5%:',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                    ),
                                  ),
                                  AutoSizeText(
                                    "tax",
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Visibility(
                                visible: true,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AutoSizeText(
                                      'Total:',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                      ),
                                    ),
                                    AutoSizeText(
                                      orderSummaryResponse!.grandTotal == null ?'During Checkout': orderSummaryResponse!.grandTotal.toString(),
                                    //  "helllll",
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  /******************* Show cart summary ********************/
                ],
              ),
            ),
            Container(child: isLoading ? Loader() : Container()),
            Visibility(
              visible: showLoading,
              child: Positioned(
                child: Align(alignment: Alignment.center, child: showloader()),
              ),
            ),
          ])),
    );
  }

  void showAndUpdateUi() async {

    gUId = ConstantsVar.prefs.getString('guestGUID');
    guestCustomerID = ConstantsVar.prefs.getString('guestCustomerID');
    getCustomerId();
    // ApiCalls.readCounter().then((value) => context.read<cartCounter>().changeCounter(value));
    setState(() {
      isCartAvail = true;
    });
    print('Checkig gID in Cart Screen');

    // MagentoApis.showMagentoCart().then((value) {
    //   setState(() {
    //
    //     cartItems = value;
    //
    //   });
    // });

  }

  Future getCustomerId() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    //  customerId = ConstantsVar.prefs.getString('userId');
    customerId = ConstantsVar.prefs.getString('admin_login_response_data');
    return customerId;
  }

}

/* Future getCustomerId() async {
    guestCustomerId = ConstantsVar.prefs.getString('guestCustomerID');
    return guestCustomerId;
  }*/

Card cartItemView(ItemCart item) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Row(
        children: <Widget>[

          /* Container(
              margin: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
              width: 80,
              height: 80,
              child: CachedNetworkImage(
                imageUrl: item.picture.imageUrl,
                fit: BoxFit.cover,
              )
          ),*/

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 8, top: 4),
                    child: AutoSizeText(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: CustomTextStyle.textFormFieldSemiBold
                          .copyWith(fontSize: 16),
                    ),
                  ),
                  Utils.getSizedBox(null, 6),
                  AutoSizeText(
                    "SKU : ${item.name}",
                    style: CustomTextStyle.textFormFieldRegular
                        .copyWith(color: Colors.grey, fontSize: 15),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: AutoSizeText(
                            item.price,
                            overflow: TextOverflow.ellipsis,
                            style: CustomTextStyle.textFormFieldBlack
                                .copyWith(color: Colors.green),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                color: Colors.grey.shade200,
                                padding: const EdgeInsets.only(
                                    bottom: 2, right: 12, left: 12),
                                child: AutoSizeText(
                                  "${item.qty}",
                                  style: CustomTextStyle.textFormFieldSemiBold,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}
