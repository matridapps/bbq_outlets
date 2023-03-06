// ignore_for_file: prefer_typing_uninitialized_variables, file_names, must_be_immutable, avoid_returning_null_for_void

import 'package:BBQOUTLETS/AppPages/HomeCategory/HomeCategory.dart';
import 'package:BBQOUTLETS/AppPages/MagentoAdminApis/AdminApis.dart';
import 'package:BBQOUTLETS/AppPages/MagentoAdminApis/CustomerApis.dart';
import 'package:BBQOUTLETS/AppPages/StreamClass/NewPeoductPage/NewProductScreen.dart';
import 'package:BBQOUTLETS/Constants/ConstantVariables.dart';
import 'package:BBQOUTLETS/utils/ApiCalls/ApiCalls.dart';
import 'package:BBQOUTLETS/utils/ApiCalls/MagentoProduct_api.dart';
import 'package:BBQOUTLETS/utils/utils/build_config.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:progress_loading_button/progress_loading_button.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../utils/CartBadgeCounter/CartBadgetLogic.dart';
import '../../../CartxxScreen/CartScreen2.dart';
import '../../../LoginScreen/LoginScreen.dart';

class ProdListWidget extends StatefulWidget {
  ProdListWidget({
    Key? key,
    required this.products,
    required this.title,
    required this.productCount,
    required this.catId,
    required this.categoryList,
    required this.token,
    required this.cartId,
    required this.customerToken,
  }) : super(key: key);

  List<MagentoBBQProduct> products;
  final title;
  int productCount;
  var catId;
  List<FurtherCategory> categoryList;
  final token;
  final cartId;
  final customerToken;

  RefreshController myController = RefreshController();

  @override
  State<ProdListWidget> createState() {
    return _ProdListWidgetState();
  }
}

class _ProdListWidgetState extends State<ProdListWidget> {
  var pageIndex1 = 1;
  bool isLoading = true;

  final ScrollController _scrollController = ScrollController();

  void _onLoading() async {
    log('object');
    if (widget.products.length == widget.productCount) {
      widget.myController.loadComplete();
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = true;
        pageIndex1 = pageIndex1 + 1;
        log('$pageIndex1');
        AdminApis.getMegentoProductsbyCatId(
                catValue: widget.catId.toString(),
                pageIndex: pageIndex1.toString(),
                adminToken: widget.token,
                pageSize: 10)
            .then((value) {
          if (value.contains('Something went wrong')) {
            Fluttertoast.showToast(
                msg: 'Something went wrong', toastLength: Toast.LENGTH_LONG);
          } else {
            setState(() {});
          }
        });
      });
      if (mounted) setState(() {});
      widget.myController.loadComplete();
    }
  }

  @override
  void initState() {
    super.initState();
    log(widget.productCount);
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.landscape
        ? _landscapeOrientationBuilder()
        : _portraitOrientationBuilder();
  }

  Widget _landscapeOrientationBuilder() {
    double _width = MediaQuery.of(context).size.width;
    Color _color = const Color.fromRGBO(251, 151, 67, 1);
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SizedBox(
            height: 10.5.h,
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
                    width: _width * .25,
                    height: _width * .19,
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
                            ).whenComplete(() =>
                              ApiCalls.readCounter(context: context)
                                  .then((value) {
                                final _counter = Provider.of<cartCounter>(
                                    context,
                                    listen: false);
                                _counter.changeCounter(value);
                              }));
                    },
                    child: Consumer<cartCounter>(
                      builder: (context, value, child) => Badge(
                        badgeContent: Text(
                          value.badgeNumber.toString(),
                          style: GoogleFonts.poppins(
                            fontSize: _width * 0.024,
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
        ListTile(
          title: Center(
            child: AutoSizeText(
              widget.title.toUpperCase(),
              maxLines: 1,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 5.5.w,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 100.w,
          height: 85.h,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: CupertinoScrollbar(
              thickness: 6.0,
              thicknessWhileDragging: 10.0,
              radius: const Radius.circular(34.0),
              radiusWhileDragging: Radius.zero,
              controller: _scrollController,
              thumbVisibility: true,
              child: SmartRefresher(
                onLoading: _onLoading,
                controller: widget.myController,
                footer: CustomFooter(
                  builder: (context, mode) {
                    Widget body;
                    if (mode == LoadStatus.idle) {
                      body = const Center(
                        child: SpinKitPouringHourGlass(
                          color: Colors.orange,
                          size: 40,
                        ),
                      );
                    } else if (mode == LoadStatus.loading) {
                      body = const CupertinoActivityIndicator();
                    } else if (mode == LoadStatus.failed) {
                      body = const AutoSizeText("Load Failed!Click retry!");
                    } else if (mode == LoadStatus.canLoading) {
                      body = const AutoSizeText("release to load more");
                    } else {
                      body = const AutoSizeText("No more Data");
                    }
                    return SizedBox(
                      height: 55.0,
                      child: Center(child: body),
                    );
                  },
                ),
                enablePullDown: false,
                enablePullUp: isLoading,
                enableTwoLevel: false,
                physics: const ClampingScrollPhysics(),
                child: GridView.count(
                  controller: _scrollController,
                  shrinkWrap: true,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  crossAxisCount: 3,
                  childAspectRatio: 3.2 / 6,
                  children: List.generate(
                    widget.products.length,
                    (index) {
                      ConstantsVar.prefs
                          .setString("SKU_Item", widget.products[index].sku);
                      return GestureDetector(
                        onTap: () async => await Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => NewProductDetails(
                              productId: widget.products[index].id,
                              screenName: 'Home Screen',
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Center(
                                  child: FadeImageEffect(
                                    imageList: [
                                      "https://magento-561260-2500518.cloudwaysapps.com/pub/media/catalog/product/${widget.products[index].image}"
                                    ],
                                    width: _width * .24,
                                    height: _width * .24,
                                    type: 'network',
                                  ),
                                ),
                                RatingBarWidget(
                                  rating: 5,
                                  disable: true,
                                  onRatingChanged: (val) => null,
                                  activeColor: _color,
                                  size: _width * .035,
                                ),
                                SizedBox(
                                  width: _width * .35,
                                  child: AutoSizeText(
                                    widget.products[index].name,
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: _width * 0.037,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: _width * .02,
                                ),
                                Visibility(
                                  visible: _isSpecialPrice(index),
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Regular Price',
                                      style: TextStyle(
                                        wordSpacing: 2,
                                        color: Colors.black,
                                        fontSize: _width * 0.017,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text:
                                          '  \$${widget.products[index].price.toString()}',
                                          style: TextStyle(
                                            wordSpacing: 2,
                                            fontSize: _width * 0.021,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                            TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text:
                                        '\$${widget.products[index].specialPrice.toString()}',
                                    style: TextStyle(
                                      wordSpacing: 4,
                                      color: Colors.black,
                                      fontSize: _width * 0.024,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: ' + FREE Shipping',
                                        style: TextStyle(
                                          wordSpacing: 2,
                                          color: const Color.fromRGBO(
                                              228, 122, 39, 1),
                                          fontSize: _width * 0.02,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: _isSpecialPrice(index),
                                  child: AutoSizeText(
                                    'Save \$${widget.products[index].price - widget.products[index].specialPrice}!',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: _width * 0.015,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: _width * .04,
                                  child: AutoSizeText(
                                    'Starting at \$${widget.products[index].finalSpecialPrice}/mo with easy financing',
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: _width * 0.02,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                  width: _width * .25,
                                  height: 35,
                                  onPressed: () async {
                                    var _login = await ConstantsVar.storage
                                            .read(key: 'customerId') ??
                                        false;
                                    // print(_login);
                                    if (_login == false) {
                                      await Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              const LoginScreen(
                                            screenKey: 'Home Screen',
                                          ),
                                        ),
                                      );
                                    } else {
                                      await CustomerApis.addToCart(
                                          cartId: await ConstantsVar.storage
                                                  .read(key: 'cartID') ??
                                              '',
                                          sku: widget.products[index].sku,
                                          context: context,
                                          customerToken: await ConstantsVar
                                                  .storage
                                                  .read(key: 'customerToken') ??
                                              '',
                                          quantity: '1');
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _portraitOrientationBuilder() {
    double _width = MediaQuery.of(context).size.width;
    Color _color = const Color.fromRGBO(251, 151, 67, 1);
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SizedBox(
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
                            ).whenComplete(() =>
                              ApiCalls.readCounter(context: context)
                                  .then((value) {
                                final _counter = Provider.of<cartCounter>(
                                    context,
                                    listen: false);
                                _counter.changeCounter(value);
                              }));
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
        ListTile(
          title: Center(
            child: AutoSizeText(
              widget.title.toUpperCase(),
              maxLines: 1,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 6.w,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 100.w,
          height: 85.h,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: CupertinoScrollbar(
              thickness: 6.0,
              thicknessWhileDragging: 10.0,
              radius: const Radius.circular(34.0),
              radiusWhileDragging: Radius.zero,
              controller: _scrollController,
              thumbVisibility: true,
              child: SmartRefresher(
                onLoading: _onLoading,
                controller: widget.myController,
                footer: CustomFooter(
                  builder: (context, mode) {
                    Widget body;
                    if (mode == LoadStatus.idle) {
                      body = const Center(
                          child: SpinKitPouringHourGlass(
                        color: Colors.orange,
                        size: 40,
                      ));
                    } else if (mode == LoadStatus.loading) {
                      body = const CupertinoActivityIndicator();
                    } else if (mode == LoadStatus.failed) {
                      body = const AutoSizeText("Load Failed!Click retry!");
                    } else if (mode == LoadStatus.canLoading) {
                      body = const AutoSizeText("release to load more");
                    } else {
                      body = const AutoSizeText("No more Data");
                    }
                    return SizedBox(
                      height: 55.0,
                      child: Center(child: body),
                    );
                  },
                ),
                enablePullDown: false,
                enablePullUp: isLoading,
                enableTwoLevel: false,
                physics: const ClampingScrollPhysics(),
                child: GridView.count(
                  controller: _scrollController,
                  shrinkWrap: true,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  crossAxisCount: 2,
                  childAspectRatio: 2.8 / 6,
                  children: List.generate(
                    widget.products.length,
                    (index) {
                      ConstantsVar.prefs
                          .setString("SKU_Item", widget.products[index].sku);
                      return GestureDetector(
                        onTap: () async => await Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => NewProductDetails(
                              productId: widget.products[index].id,
                              screenName: 'Home Screen',
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                FadeImageEffect(
                                  imageList: [
                                    "https://magento-561260-2500518.cloudwaysapps.com/pub/media/catalog/product/${widget.products[index].image}"
                                  ],
                                  width: _width * .44,
                                  height: _width * .44,
                                  type: 'network',
                                ),
                                RatingBarWidget(
                                  rating: 5,
                                  disable: true,
                                  onRatingChanged: (val) => null,
                                  activeColor: _color,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: _width * .46,
                                  child: AutoSizeText(
                                    widget.products[index].name,
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: _width * 0.037,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: _width * .06,
                                ),
                                Visibility(
                                  visible: _isSpecialPrice(index),
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Regular Price  ',
                                      style: TextStyle(
                                        wordSpacing: 1,
                                        color: Colors.black,
                                        fontSize: _width * 0.03,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text:
                                              '\$${widget.products[index].price.toString()}',
                                          style: TextStyle(
                                            wordSpacing: 2,
                                            fontSize: _width * 0.04,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text:
                                        '\$${widget.products[index].specialPrice}',
                                    style: TextStyle(
                                      wordSpacing: 2,
                                      color: Colors.black,
                                      fontSize: _width * 0.044,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '  + FREE SHIPPING',
                                        style: TextStyle(
                                          wordSpacing: 1,
                                          color: const Color.fromRGBO(
                                              228, 122, 39, 1),
                                          fontSize: _width * 0.032,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: _isSpecialPrice(index),
                                  child: AutoSizeText(
                                    'Save \$${widget.products[index].price - widget.products[index].specialPrice}!',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: _width * 0.022,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                AutoSizeText(
                                  'Starting at \$${widget.products[index].finalSpecialPrice}/mo with easy financing',
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: _width * 0.022,
                                    fontWeight: FontWeight.bold,
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
                                  width: _width * .25,
                                  height: 35,
                                  onPressed: () async {
                                    var _login = await ConstantsVar.storage
                                            .read(key: 'customerId') ??
                                        false;
                                    if (_login == false) {
                                      await Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              const LoginScreen(
                                            screenKey: 'Home Screen',
                                          ),
                                        ),
                                      );
                                    } else {
                                      await CustomerApis.addToCart(
                                          cartId: await ConstantsVar.storage
                                                  .read(key: 'cartID') ??
                                              '',
                                          sku: widget.products[index].sku,
                                          context: context,
                                          customerToken: await ConstantsVar
                                                  .storage
                                                  .read(key: 'customerToken') ??
                                              '',
                                          quantity: '1');
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool _isSpecialPrice(int i) {
    return widget.products[i].specialPrice == widget.products[i].price
        ? false
        : true;
  }
}
