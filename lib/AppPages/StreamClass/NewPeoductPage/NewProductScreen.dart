// ignore_for_file: prefer_typing_uninitialized_variables, must_call_super, file_names

import 'dart:convert';
import 'dart:developer';

import 'package:BBQOUTLETS/AppPages/CartxxScreen/CartScreen2.dart';
// import 'package:BBQOUTLETS/AppPages/HomeScreen/HomeScreen.dart';
import 'package:BBQOUTLETS/AppPages/MagentoAdminApis/AdminApis.dart';
import 'package:BBQOUTLETS/AppPages/StreamClass/Model/ProductModel.dart';
import 'package:BBQOUTLETS/Constants/ConstantVariables.dart';
import 'package:BBQOUTLETS/Widgets/CustomButton.dart';
import 'package:BBQOUTLETS/utils/ApiCalls/ApiCalls.dart';
import 'package:BBQOUTLETS/utils/CartBadgeCounter/CartBadgetLogic.dart';
import 'package:BBQOUTLETS/utils/utils/build_config.dart';
import 'package:BBQOUTLETS/utils/utils/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
// import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:progress_loading_button/progress_loading_button.dart';
import 'package:provider/provider.dart';

import '../../../Slider.dart';
import '../../LoginScreen/LoginScreen.dart';
import '../../MagentoAdminApis/CustomerApis.dart';

class NewProductDetails extends StatefulWidget {
  const NewProductDetails(
      {Key? key, required this.productId, required this.screenName})
      : super(key: key);
  final String productId;

  final String screenName;

  @override
  _NewProductDetailsState createState() => _NewProductDetailsState();
}

class _NewProductDetailsState extends State<NewProductDetails> {
  var visible;
  var indVisibility;
  var snapshot;
  var productID;
  var name;
  var description;
  var price;

  // var logger = Logger();
  // double? priceValue;
  var discountedPrice;
  var isDiscountAvail;
  var sku;
  var stockAvailabilty;
  var image1;
  var image2;
  var image3;
  var id;
  String discountPercentage = '';
  List<String> imageList = [];
  List<String> largeImage = [];
  List<Item>? inititemvalue;

  var connectionStatus;
  bool isScroll = true;
  var assemblyCharges;
  FocusNode yourfoucs = FocusNode();
  ProductMagentoResponse? initialData;

  var _isVisibility;

  final String _quantity = '';

  String _token = '';

  String? cartId;

  var qty = 1;

  // var customerGuid;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    getInstance().then((value) =>
        AdminApis.showProductDetails(productId: productID, adminToken: _token)
            .then((value) {
          initialData = ProductMagentoResponse.fromJson(jsonDecode(value));


          inititemvalue = initialData!.items;
          setState(() {
            inititemvalue = initialData!.items;

            //  debugPrint("NewProductData:-"+initialData.toString());
            //  logger.d("Logger is working!");
            // List<Value> value=[] ;
            /* for (int i = 0; i <= initialData!..length - 1; i++) {
          image1 = initialData!.extensionAttributes.productImages;
          image2 = initialData!.extensionAttributes.productImages;
          imageList.add(image1);
          largeImage.add(image2);
          // setState((){value.addAll(initialData!.productAttributes[i].values);});
        }*/

            // image2 = initialData['PictureModels'][0]['FullSizeImageUrl'];

            id = inititemvalue![0].id;
            name = inititemvalue![0].name;
            price = inititemvalue![0].price;
            sku = inititemvalue![0].sku;
            // _quantity = inititemvalue![0].extensionAttributes.quantity == 0
            //     ? 'Out of stock'
            //     : 'In stock';
            //   stockAvailabilty = initialData!.extensionAttributes.quantity.toString();
            // discountPercentage = initialData!.discountPercentage;

            setState(() {
              _isVisibility = true;
              assemblyCharges = '';
            });
          });
        }));
    setState(() {
      productID = widget.productId;

      // guestCustomerID = ConstantsVar.prefs.getString('guestCustomerID');
      // customerGuid = ConstantsVar.prefs.getString('guestGUID');
    });

    ApiCalls.readCounter(context: context).then((value) => setState(() {
          context.read<cartCounter>().changeCounter(value);
        }));
  }

  @override
  Widget build(BuildContext context) {
    if (initialData == null) {
      return const SafeArea(
        child: Scaffold(
          body: Center(
            child: SpinKitPouringHourGlass(
              color: Colors.orange,
              size: 40,
            ),
          ),
        ),
      );
    } else {
      return SafeArea(
        top: _isVisibility,
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: customList(
              context: context,
              name: name,
              price: price.toString(),
              descritption: description,

              //  priceValue: "price",
              sku: sku,

              stockAvaialbility: stockAvailabilty,
            )),
      );
    }
  }

  ListView customList({
    required BuildContext context,
    required String name,
    required String descritption,
    required String sku,
    required String stockAvaialbility,
    required String price,
  }) {
    double _width = MediaQuery.of(context).size.width;
    List<String> _listImages = List.generate(initialData!.items[0].mediaGalleryEntries.length, (index) => "https://magento-561260-2500518.cloudwaysapps.com/pub/media/catalog/product/${initialData!.items[0].mediaGalleryEntries[index].file}");
    Orientation orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.landscape
      ? ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SizedBox(
            // width: 100.w,
            height: 14.h,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      size: 9.w,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    logoImage,
                    width: _width * .28,
                    height: _width * .21,
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () async {
                      var _login =
                          await ConstantsVar.storage.read(key: 'customerId') ??
                              false;
                      _login == false
                          ? await Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) =>
                          const LoginScreen(screenKey: 'Home Screen'),
                        ),
                      )
                          : await Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const CartScreen2(
                            isOtherScren: true,
                            otherScreenName: 'Home Screen',
                          ),
                        ),
                      ).whenComplete(() async =>
                      await ApiCalls.readCounter(context: context)
                          .then((value) => setState(() {
                        context
                            .read<cartCounter>()
                            .changeCounter(value);
                      })));
                    },
                    child: Consumer<cartCounter>(
                      builder: (context, value, child) => Badge(
                        badgeContent: Text(
                          value.badgeNumber.toString(),
                          style: GoogleFonts.poppins(
                            fontSize: _width * 0.028,
                          ),
                        ),
                        position: BadgePosition.topEnd(),
                        child: Image.asset(
                          'BBQ_Images/shopping_cart.png',
                          width: _width * .055,
                          height: _width * .055,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Container(
              child: sliderImages(
                  initialData!.items[0].mediaGalleryEntries[0].file == ""
                      ? [noImageUrl]
                      : _listImages,
                  [noImageUrl],
                  context,
                  discountPercentage)),
        ),
        Card(
          child: SizedBox(
            height: 50.h,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 3,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeText(
                    name,
                    style: TextStyle(
                      wordSpacing: .2,
                      letterSpacing: .5,
                      fontSize: 5.2.w,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  AutoSizeText(
                    'SKU: $sku',
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 5.w,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 0.30,
                        wordSpacing: .2),
                    textAlign: TextAlign.start,
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Availability: ',
                      style: TextStyle(
                          fontSize: 5.5.w,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: .30,
                          wordSpacing: .2),
                      children: <TextSpan>[
                        TextSpan(
                          text: _quantity,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 7.h,
                    width: 100.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoSizeText(
                          discountedPrice =
                          'Price: \$$price' /*? price : discountedPrice*/,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 5.5.w,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            letterSpacing: .3,
                            wordSpacing: .2,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          width: 38.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    InkWell(
                                      radius: 36,
                                      onTap: () async {
                                        log('SomeOne Tap on Me');

                                        setState(() {
                                          if (qty <= 1) {
                                            MotionToast.error(
                                                height: 40,
                                                animationType:
                                                ANIMATION.fromRight,
                                                position:
                                                MOTION_TOAST_POSITION
                                                    .bottom,
                                                description: const Text(
                                                    'Quantity cannot be 0'))
                                                .show(context);
                                          } else {
                                            setState(() {
                                              qty = qty - 1;

                                              log('$qty');
                                            });
                                          }
                                        });
                                      },
                                      child: Container(
                                        width: 10.w,
                                        height: 10.w,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                            BorderRadius.circular(6.0)),
                                        child: const Icon(
                                          Icons.remove,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Container(
                                      width: 10.w,
                                      height: 10.w,
                                      color: Colors.grey.shade200,
                                      padding: const EdgeInsets.only(
                                          bottom: 2, right: 2, left: 2),
                                      child: Center(
                                        child: AutoSizeText(
                                          "$qty",
                                          style: CustomTextStyle
                                              .textFormFieldSemiBold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    InkWell(
                                      radius: 36,
                                      onTap: () async {
                                        log('SomeOne Tap on Me');
                                        // if (qty <
                                        //     inititemvalue![0]
                                        //         .extensionAttributes
                                        //         .quantity) {
                                        //   setState(() {
                                        //     qty = qty + 1;
                                        //   });
                                        //
                                        //   log('$qty');
                                        // } else {
                                        //   MotionToast.error(
                                        //           animationType:
                                        //               ANIMATION.fromRight,
                                        //           position:
                                        //               MOTION_TOAST_POSITION
                                        //                   .bottom,
                                        //           description: Text(
                                        //               'Quantity cannot be exceeds ${inititemvalue![0].extensionAttributes.quantity}'))
                                        //       .show(context);
                                        // }
                                      },
                                      child: Container(
                                        width: 10.w,
                                        height: 10.w,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                          BorderRadius.circular(6.0),
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        LoadingButton(
                          type: LoadingButtonType.Raised,
                          loadingWidget: const SpinKitPianoWave(
                            color: Colors.white,
                            size: 14,
                          ),
                          color: const Color.fromARGB(
                            255,
                            102,
                            102,
                            102,
                          ),
                          width: 35.w,
                          height: 30,
                          onPressed: () async {
                            var _login = await ConstantsVar.storage
                                .read(key: 'customerId') ??
                                false;
                            // print(_login);
                            if (_login == false) {
                              await Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => const LoginScreen(
                                    screenKey: 'Home Screen',
                                  ),
                                ),
                              );
                            } else {
                              await CustomerApis.addToCart(
                                  cartId: await ConstantsVar.storage
                                      .read(key: 'cartID') ??
                                      '',
                                  sku: sku,
                                  context: context,
                                  customerToken: await ConstantsVar.storage
                                      .read(key: 'customerToken') ??
                                      '',
                                  quantity: qty.toString());
                            }
                          },
                          defaultWidget:  Center(
                            child: AutoSizeText(
                              'Add to cart',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: _width * .025
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    )
      : ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SizedBox(
            // width: 100.w,
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
                    width: _width * .40,
                    height: _width * .34,
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () async {
                      var _login =
                          await ConstantsVar.storage.read(key: 'customerId') ??
                              false;
                      _login == false
                          ? await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    const LoginScreen(screenKey: 'Home Screen'),
                              ),
                            )
                          : await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const CartScreen2(
                                  isOtherScren: true,
                                  otherScreenName: 'Home Screen',
                                ),
                              ),
                            ).whenComplete(() async =>
                              await ApiCalls.readCounter(context: context)
                                  .then((value) => setState(() {
                                        context
                                            .read<cartCounter>()
                                            .changeCounter(value);
                                      })));
                    },
                    child: Consumer<cartCounter>(
                      builder: (context, value, child) => Badge(
                        badgeContent: Text(
                          value.badgeNumber.toString(),
                          style: GoogleFonts.poppins(
                            fontSize: _width * 0.03,
                          ),
                        ),
                        position: BadgePosition.topEnd(),
                        child: Image.asset(
                          'BBQ_Images/shopping_cart.png',
                          width: _width * .068,
                          height: _width * .068,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Container(
              child: sliderImages(
                  initialData!.items[0].mediaGalleryEntries[0].file == ""
                      ? [noImageUrl]
                      : _listImages,
                  [noImageUrl],
                  context,
                  discountPercentage)),
        ),
        Card(
          child: SizedBox(
            height: 50.h,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 3,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeText(
                    name,
                    // maxLines: 2,
                    style: TextStyle(
                      wordSpacing: .2,
                      letterSpacing: .5,
                      fontSize: 6.w,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  AutoSizeText(
                    'SKU: $sku',
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 4.5.w,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 0.30,
                        wordSpacing: .2),
                    textAlign: TextAlign.start,
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Availability: ',
                      style: TextStyle(
                          fontSize: 4.5.w,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: .30,
                          wordSpacing: .2),
                      children: <TextSpan>[
                        TextSpan(
                          text: _quantity,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                    width: 100.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoSizeText(
                          discountedPrice =
                              'Price: \$$price' /*? price : discountedPrice*/,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 4.5.w,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            letterSpacing: .3,
                            wordSpacing: .2,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          width: 25.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    InkWell(
                                      radius: 36,
                                      onTap: () async {
                                        log('SomeOne Tap on Me');

                                        setState(() {
                                          if (qty <= 1) {
                                            MotionToast.error(
                                                    height: 40,
                                                    animationType:
                                                        ANIMATION.fromRight,
                                                    position:
                                                        MOTION_TOAST_POSITION
                                                            .bottom,
                                                    description: const Text(
                                                        'Quantity cannot be 0'))
                                                .show(context);
                                          } else {
                                            setState(() {
                                              qty = qty - 1;

                                              log('$qty');
                                            });
                                          }
                                        });
                                      },
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(6.0)),
                                        child: const Icon(
                                          Icons.remove,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Container(
                                      color: Colors.grey.shade200,
                                      padding: const EdgeInsets.only(
                                          bottom: 2, right: 2, left: 2),
                                      child: AutoSizeText(
                                        "$qty",
                                        style: CustomTextStyle
                                            .textFormFieldSemiBold,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    InkWell(
                                      radius: 36,
                                      onTap: () async {
                                        log('SomeOne Tap on Me');
                                        // if (qty <
                                        //     inititemvalue![0]
                                        //         .extensionAttributes
                                        //         .quantity) {
                                        //   setState(() {
                                        //     qty = qty + 1;
                                        //   });
                                        //
                                        //   log('$qty');
                                        // } else {
                                        //   MotionToast.error(
                                        //           animationType:
                                        //               ANIMATION.fromRight,
                                        //           position:
                                        //               MOTION_TOAST_POSITION
                                        //                   .bottom,
                                        //           description: Text(
                                        //               'Quantity cannot be exceeds ${inititemvalue![0].extensionAttributes.quantity}'))
                                        //       .show(context);
                                        // }
                                      },
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        LoadingButton(
                          type: LoadingButtonType.Raised,
                          loadingWidget: const SpinKitPianoWave(
                            color: Colors.white,
                            size: 14,
                          ),
                          color: const Color.fromARGB(
                            255,
                            102,
                            102,
                            102,
                          ),
                          width: 28.w,
                          height: 45,
                          onPressed: () async {
                            var _login = await ConstantsVar.storage
                                    .read(key: 'customerId') ??
                                false;
                            // print(_login);
                            if (_login == false) {
                              await Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => const LoginScreen(
                                    screenKey: 'Home Screen',
                                  ),
                                ),
                              );
                            } else {
                              await CustomerApis.addToCart(
                                  cartId: await ConstantsVar.storage
                                          .read(key: 'cartID') ??
                                      '',
                                  sku: sku,
                                  context: context,
                                  customerToken: await ConstantsVar.storage
                                          .read(key: 'customerToken') ??
                                      '',
                                  quantity: qty.toString());
                            }
                          },
                          defaultWidget: const Center(
                            child: AutoSizeText(
                              'Add to cart',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future getInstance() async {
    ConstantsVar.storage = const FlutterSecureStorage();
    _token = await ConstantsVar.storage.read(
          key: 'adminToken',
        ) ??
        '';
  }
}

void showDialog1(BuildContext context) {
  showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 400),
    context: context,
    pageBuilder: (_, __, ___) {
      return Card(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColor.PrimaryAccentColor,
                Colors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          height: 5.8.h,
          child: CupertinoScrollbar(
            child: ListView(children: [
              ListTile(
                title: TextFormField(),
              ),
              ListTile(
                title: TextFormField(),
              ),
            ]),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: const Offset(0, .7)).animate(anim),
        child: child,
      );
    },
  );
}
