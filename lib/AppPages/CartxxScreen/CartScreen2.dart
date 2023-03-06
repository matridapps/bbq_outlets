// ignore_for_file: unrelated_type_equality_checks, must_call_super, prefer_typing_uninitialized_variables, prefer_final_fields

import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Platform;
import 'dart:async';
import 'package:BBQOUTLETS/AppPages/HomeScreen/HomeScreen.dart';
import 'package:BBQOUTLETS/AppPages/MagentoAdminApis/CustomerApis.dart';
import 'package:BBQOUTLETS/AppPages/Registration/RegistrationPage.dart';
import 'package:BBQOUTLETS/AppPages/ShippingxxxScreen/ShippingPage.dart';
import 'package:BBQOUTLETS/Constants/ConstantVariables.dart';
import 'package:BBQOUTLETS/PojoClass/NetworkModelClass/CartModelClass/CartModelMagento.dart';
import 'package:BBQOUTLETS/new_screen/new_home_screen/new_home_screen.dart';
import 'package:BBQOUTLETS/utils/ApiCalls/ApiCalls.dart';
import 'package:BBQOUTLETS/utils/HeartIcon.dart';
import 'package:BBQOUTLETS/utils/utils/build_config.dart';
import 'package:BBQOUTLETS/utils/utils/colors.dart';
import 'package:BBQOUTLETS/utils/utils/general_functions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CartItems.dart';

class CartScreen2 extends StatefulWidget {
  final bool isOtherScren;
  final String otherScreenName;

  @override
  _CartScreen2State createState() => _CartScreen2State();

  const CartScreen2({Key? key, required this.isOtherScren, required this.otherScreenName}) : super(key: key);
}

class _CartScreen2State extends State<CartScreen2>
    with AutomaticKeepAliveClientMixin, InputValidationMixin {
  Color _color = const Color.fromRGBO(251, 151, 67, 1);
  bool isCartAvail = true;
  var gUId;
  var customerId;
  var guestCustomerID;
  var adminToken;
  var customercartquantity;
  var quantity;
  bool visibility = false;
  bool indVisibility = true;
  var subTotal;
  String cartId = '';
  var shipping = '';
  var taxPrice = '';
  var totalAmount = '';
  var discountPrice = '';
  String discountCoupon = '';
  String giftCoupon = '';
  bool showDiscount = false;
  bool showLoading = false, applyCouponCode = true, removeCouponCode = false;
  bool applyGiftCard = true, removeGiftCard = false;

  bool connectionStatus = true;
  List<ItemCart> cartItems = [];
  CartModelMagentoApi? model;

//  List<CartModelMagentoApi> img= [ ] ;
  bool loadCartFirst = true;
  TextEditingController discountController = TextEditingController();
  TextEditingController giftCardController = TextEditingController();

  final doubleRegex = RegExp(r'^\[A-Z+\0-9+\a-z+\A-Z]$', multiLine: true);
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final GlobalKey<FormState> discountKey = GlobalKey<FormState>();
  final GlobalKey<FormState> giftCouponKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (mounted) {
      getCustomerIdxx().then((value) {
        showAndUpdateUi();
        setState(() {});
      });
    }

    setState(() {
      //  guestCustomerID = ConstantsVar.prefs.getString('guestCustomerID');

      log('$guestCustomerID');

      if (loadCartFirst == false) {
        setState(() {
          loadCartFirst = true;
        });
      } else {
        setState(() => loadCartFirst = false);
      }
    });

    log('customerid>>>>> $customerId');
    visibility = false;
    indVisibility = true;
    if (discountController.text.toString() == '' ||
        discountController.text.toString == '') {
      setState(() {
        removeCouponCode = false;
      });
    } else {
      setState(() => removeCouponCode = true);
    }

    ConstantsVar.subscription = ConstantsVar.connectivity.onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          connectionStatus = true;
        });
      } else {
        ConstantsVar.showSnackbar(context,
            'No Internet connection found. Please check your connection', 5);
        setState(() {
          connectionStatus = false;
        });
      }
    });
    super.initState();
  }

  Future showAndUpdateUi() async {
    if (mounted) {
      setState(() {
        isCartAvail = true;
      });
    }
    log('Checkig gID in Cart Screen');

    CustomerApis.showMagentoCart(token: guestCustomerID).then((value) {
      model = value;
      log('Cart Model' + jsonEncode(model));
      cartItems = model!.items;
      isCartAvail = false;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        body: SizedBox(
          height: 100.h,
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                width: 100.w,
                height: 10.h,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back,
                          size: 8.w,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        logoImage,
                        width: 30.w,
                        height: 10.h,
                        // fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: isCartAvail == true
                    ? const Center(
                        child: Center(
                          child: SpinKitPouringHourGlass(
                            color: Colors.orange,
                            size: 40,
                          ),
                        ))
                    : model!.items.isEmpty
                        ? SizedBox(
                            width: 100.w,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AutoSizeText(
                                  'You  have no items in your shopping cart.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      letterSpacing: 1,
                                      height: 2,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 4.w),
                                ),
                                Center(
                                  child: RichText(
                                    text: TextSpan(
                                      text: "Click",
                                      style: GoogleFonts.poppins(
                                          letterSpacing: 1,
                                          height: 2,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 4.w),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: ' here ',
                                            style: GoogleFonts.poppins(
                                                letterSpacing: 1,
                                                height: 2,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.orange,
                                                fontSize: 4.w),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                // navigate to desired screen
                                                await Navigator
                                                    .pushAndRemoveUntil(
                                                  context,
                                                  CupertinoPageRoute(
                                                    builder: (context) =>
                                                        const NewHomeScreen(),
                                                  ),
                                                  (route) => false,
                                                );
                                              }),
                                        TextSpan(
                                          text: 'to continue shopping. ',
                                          style: GoogleFonts.poppins(
                                              letterSpacing: 1,
                                              height: 2,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 4.w),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 5),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'BBQ_Images/check.png',
                                      width: 8.w,
                                      height: 8.w,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    AutoSizeText(
                                      'Order Summary',
                                      style: GoogleFonts.poppins(
                                          fontSize: 6.w,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              ExpansionTile(
                                tilePadding:
                                    const EdgeInsets.fromLTRB(8.0, 10, 8, 5),
                                backgroundColor:
                                    const Color.fromARGB(255, 196, 196, 196)
                                        .withOpacity(.25),
                                collapsedBackgroundColor:
                                    const Color.fromARGB(255, 196, 196, 196)
                                        .withOpacity(.25),
                                initiallyExpanded: true,
                                title: Text(
                                  '${model!.itemsQty} Items in Cart ',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(),
                                ),
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: 100.w,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: const [
                                              Text('Product Name'),
                                              Text('QTY'),
                                              Text('SubTotal'),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: List.generate(
                                            cartItems.length, (index) {
                                          return CartItem(
                                            itemCart: cartItems[index],
                                            cartId: cartId,
                                            adminToken: adminToken,
                                            controller: _refreshController,
                                            refreshCallback: () {
                                              showAndUpdateUi();
                                              setState(() {});
                                            },
                                          );
                                        }),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Container(
                                color: const Color.fromARGB(255, 196, 196, 196)
                                    .withOpacity(.25),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8.0, 10, 8, 5),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AutoSizeText(
                                            'Subtotal:',
                                            style: GoogleFonts.poppins(
                                                // fontFamily: 'Poppins',
                                                fontSize: 3.5.w,
                                                wordSpacing: 2),
                                          ),
                                          AutoSizeText(
                                            '\$' + model!.subtotal,
                                            style: GoogleFonts.poppins(
                                                fontSize: 3.5.w,
                                                wordSpacing: 2),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8.0, 5, 8, 10),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AutoSizeText(
                                            'Shipping ( Free Shipping - Free )',
                                            style: GoogleFonts.poppins(
                                                // fontFamily: 'Poppins',
                                                fontSize: 3.5.w,
                                                wordSpacing: 2),
                                          ),
                                          AutoSizeText(
                                            '\$' + model!.shippingAmount,
                                            style: GoogleFonts.poppins(
                                                fontSize: 3.5.w,
                                                wordSpacing: 2),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: const Divider(
                                        thickness: 2,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8.0, 15, 8, 15),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AutoSizeText(
                                            'Order Total',
                                            style: GoogleFonts.poppins(
                                              fontSize: 4.w,
                                              wordSpacing: 2,
                                              fontWeight: FontWeight.bold,
                                              // wordSpacing: 2
                                            ),
                                          ),
                                          AutoSizeText(
                                            '\$' + model!.grandTotal,
                                            style: GoogleFonts.poppins(
                                                fontSize: 4.w,
                                                wordSpacing: 2,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: const Divider(
                                        thickness: 2,
                                      ),
                                    ),
                                    ExpansionTile(
                                      onExpansionChanged: (val) {},
                                      title: Text(
                                        'Estimate Shipping and Tax',
                                        // textAlign: TextAlign.end,
                                        style: GoogleFonts.poppins(
                                            fontSize: 3.5.w,
                                            fontWeight: FontWeight.w700,
                                            color: _color),
                                      ),
                                      children: const [],
                                    ),
                                    ExpansionTile(
                                      onExpansionChanged: (val) {},
                                      title: Text(
                                        'Apply Discount Code',
                                        // textAlign: TextAlign.end,
                                        style: GoogleFonts.poppins(
                                            fontSize: 3.5.w,
                                            fontWeight: FontWeight.w700,
                                            color: _color),
                                      ),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Enter discount code',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 3.5.w,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                color: Colors.white,
                                                child: TextFormField(
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 3.6.w,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  decoration: InputDecoration(
                                                    focusColor: Colors.white,
                                                    hintText:
                                                        'Enter discount code',
                                                    hintStyle:
                                                        GoogleFonts.poppins(
                                                      fontSize: 3.6.w,
                                                    ),
                                                    focusedBorder:
                                                        const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.grey,
                                                          width: 2.1),
                                                    ),
                                                    enabledBorder:
                                                        const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.grey,
                                                          width: 2.1),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                width: 40.w,
                                                height: 12.w,
                                                color: _color,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Center(
                                                      child: Text(
                                                    'Apply Discount',
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontSize: 3.w,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: bottomButtons(context),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomButtons(BuildContext context) {
    return IgnorePointer(
      // ignoring: true,
      child: InkWell(
        onTap: () async {
          log(customerId);

          // Navigator.push(context, CupertinoPageRoute(builder: (context) {
          //   return AddBillingDetails(
          //     customerId: customerId,
          //     tokken: adminToken,
          //   );
          // }));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 11.w,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.0), color: _color),
            child: const Center(
              child: AutoSizeText(
                'Proceed to Checkout',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future getCustomerIdxx() async {
    //  customerId = ConstantsVar.customerID;

    gUId = ConstantsVar.prefs.getString('guestGUID');
    guestCustomerID = await ConstantsVar.storage.read(key: 'customerToken');
    adminToken = await ConstantsVar.storage.read(key: 'adminToken');
    cartId = await ConstantsVar.storage.read(key: 'cartID') ?? '';
    log(guestCustomerID);
    setState(() {});
  }

  Future refresh() async {
    _refreshController.refreshCompleted();
  }

  Widget setBackIcon() {
    if (Platform.isAndroid) {
      return InkWell(
          onTap: () {
            if (widget.otherScreenName.contains('Cart Screen2')) {
              Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => MyHomePage(pageIndex: 4),
                  ),
                  (route) => false);
            } else {
              Navigator.pop(context, true);
            }
          },
          child: const Icon(Icons.arrow_back));
      // Android-specific code
    } else {
      return InkWell(
        onTap: () {
          if (widget.otherScreenName.contains('Cart Screen2')) {
            Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(
                  builder: (context) => MyHomePage(pageIndex: 4),
                ),
                (route) => false);
          } else {
            Navigator.pop(context, true);
          }
        },
        child: const Icon(Icons.arrow_back),
      ); // iOS-specific code
    }
  }

  static Future getProductImages({required String sku}) async {
    final url = Uri.parse(
        'https://magento-561260-1838674.cloudwaysapps.com/rest/V1/products/$sku/media');

    try {
      var response = await get(url);
      log(response.body);
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }
}
