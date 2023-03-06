// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'dart:convert';
import 'package:BBQOUTLETS/AppPages/Categories/ProductList/SubCatProducts.dart';
import 'package:BBQOUTLETS/AppPages/MagentoAdminApis/CustomerApis.dart';
import 'package:BBQOUTLETS/utils/utils/build_config.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:progress_loading_button/progress_loading_button.dart';
import 'package:provider/provider.dart';
import 'package:spring/spring.dart';

import '../../AppPages/HomeCategory/HomeCategory.dart';
import '../../AppPages/LoginScreen/LoginScreen.dart';
import '../../AppPages/MagentoAdminApis/AdminApis.dart';
import '../../AppPages/MagentoAdminApis/category_model.dart';
import '../../AppPages/StreamClass/NewPeoductPage/NewProductScreen.dart';
import '../../BBQStaticModelClass/toBrands.dart';
import '../../Constants/ConstantVariables.dart';
import '../../Features/Animations/CustomLoader/custom_loader.dart';
import '../../sample_product_screen.dart';
import '../../utils/ApiCalls/ApiCalls.dart';
import '../../utils/ApiCalls/home_screen_response.dart';
import '../../utils/ApiCalls/popular_grills_response.dart';
import '../../utils/CartBadgeCounter/CartBadgetLogic.dart';
import '../../utils/Route_Package/route_class.dart';
import '../SearchDelegate/search_delegate.dart';

const ContainerTransitionType transitionType =
    ContainerTransitionType.fadeThrough;
const ContainerTransitionType transitionType2 = ContainerTransitionType.fade;
const SharedAxisTransitionType transitionSharedAxisType =
    SharedAxisTransitionType.horizontal;
const SharedAxisTransitionType transitionSharedAxisType2 =
    SharedAxisTransitionType.vertical;

class NewHomeScreen extends StatefulWidget {
  const NewHomeScreen({Key? key}) : super(key: key);

  @override
  State<NewHomeScreen> createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> {
  Color _color = const Color.fromRGBO(251, 151, 67, 1);
  final SpringController springController =
      SpringController(initialAnim: Motion.pause);
  late ScrollController _scrollController;
  List<SubCategoryModel> _listPopularDepartment = [];
  List<TopBrands> banners = [];
  List<ServiceClass> _serviceList = [];
  List<ExtraInfo> _extraInfo = [];
  String _adminToken = '';
  List<PopularGrillsResponse> products = [];
  HomeScreenResponse? homeScreenResponse;
  List<String> departNames = [];
  List<String> departImages = [];
  List<String> brandImages = [];
  List<String> brandUrls = [];
  List<String> brandIds = [];
  List<String> brandNames = [];
  Map<String, String> brandMap = {};

  List<String> offerNames = [];
  List<String> offerImages = [];
  bool _isVisible = false;
  List<CategoryResposne> categoryList = [];
  bool isLoading = false;
  bool checkOffset = false;
  var _isCatLoading = true;
  bool _productError = false;

  Future<void> getAllCategory() async {
    await AdminApis.getCategory().then((value) => categoryList = value);
    setState(() {});
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset >=
              (MediaQuery.of(context).size.width * .1)) {
            checkOffset = true;
          } else {
            checkOffset = false;
          }
        });
      });

    _getAdminToken().then((value) async => Future.wait([
          ApiCalls.getPopularGrills()
              .then(
                (value) => setState(
                  () {
                    log(value);
                    if (value.contains('Something went wrong')) {
                      _productError = true;
                    } else {
                      try {
                        List<dynamic> _response = jsonDecode(value);

                        /***** for Shop Popular Grills *****/

                        products = List<PopularGrillsResponse>.from(_response
                                .map((e) => PopularGrillsResponse.fromJson(e)))
                            .toList();
                        products.removeWhere((e) => e.id == "1994");

                        setState(() {});
                      } on Exception catch (e) {
                        log(e);
                      }
                    }
                  },
                ),
              )
              .whenComplete(() => setState(() => _isVisible = true))
              .whenComplete(() async {
            getAllCategory()
                .whenComplete(() => setState(() => _isCatLoading = false));
            await ApiCalls.readCounter(context: context).then((_value) {
              final _counter = Provider.of<cartCounter>(context, listen: false);
              _counter.changeCounter(_value);
            });
          }).whenComplete(() => ApiCalls.getHomeResponse().then(
                    (value) => setState(
                      () {
                        log(value);
                        if (value.contains('Something went wrong')) {
                          _productError = true;
                        } else {
                          try {
                            Map<String, dynamic> _response = jsonDecode(value);

                            homeScreenResponse =
                                HomeScreenResponse.fromJson(_response);

                            /***** for Shop by Department *****/
                            departNames = homeScreenResponse!
                                .shopPopularDepartment.textName;
                            departNames.removeAt(0);
                            departImages =
                                homeScreenResponse!.shopPopularDepartment.image;
                            log("Check Popular Department :- ${departNames.length == departImages.length}");

                            /***** for Shop by Brand *****/
                            brandImages =
                                homeScreenResponse!.brandSection.image;
                            brandIds = homeScreenResponse!.brandSection.id;
                            brandNames = homeScreenResponse!.brandSection.name;

                            /***** for Special Offers *****/
                            offerNames =
                                homeScreenResponse!.saleOffers.textName;
                            offerNames.removeWhere((e) => e.isEmpty);
                            offerNames.removeAt(0);
                            offerNames.removeLast();
                            log("offerNames :- $offerNames");
                            offerImages = homeScreenResponse!.saleOffers.image;
                            offerImages.insert(3, offerImages[2]);

                            setState(() {});
                          } on Exception catch (e) {
                            log(e);
                          }
                        }
                      },
                    ),
                  ))
        ]).whenComplete(() {}));

    _getPopularDepartment();
    _getTopBrands();
    _getServiceItems();
    _getExtraInfo();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final _scaffoldKey = LabeledGlobalKey<ScaffoldState>('Home Screen');
  final _scafoldKey = LabeledGlobalKey<ScaffoldState>('Home Screen Landscape');

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.landscape
        ? _landscapeOrientationBuilder()
        : _portraitOrientationBuilder();
  }

  Widget _landscapeOrientationBuilder() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return SafeArea(
      bottom: true,
      maintainBottomViewPadding: true,
      child: Scaffold(
        key: _scafoldKey,
        drawer: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: Drawer(
            child: ListView(
              // physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              children: [
                Hero(
                  tag: logoTag,
                  child: SizedBox(
                    height: _height * .25,
                    child: Image.asset(logoImage),
                  ),
                ),
                SizedBox(
                  height: _height * .05,
                ),
                Pages(
                  title: 'title',
                  list: categoryList,
                  isCatLoading: _isCatLoading,
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  children: [
                    SizedBox(
                      width: _width,
                      height: _height * .3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: _height * .03,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: GestureDetector(
                                    onTap: () =>
                                        _scafoldKey.currentState?.openDrawer(),
                                    child: Image.asset(
                                      'BBQ_Images/menu.png',
                                      width: _width * .04,
                                      height: _width * .04,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Hero(
                              tag: logoTag,
                              transitionOnUserGestures: true,
                              child: Image.asset(
                                logoImage,
                                width: _width * .27,
                                height: _width * .22,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: _height * .03,
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    onTap: () async {
                                      var _login = await ConstantsVar.storage
                                              .read(key: 'customerId') ??
                                          false;
                                      _login == false
                                          ? await Navigator.pushNamed(
                                              context,
                                              kLoginScreen,
                                            )
                                          : await Navigator.pushNamed(
                                              context,
                                              kCartScreen,
                                            ).whenComplete(
                                              () async =>
                                                  await ApiCalls.readCounter(
                                                          context: context)
                                                      .then(
                                                (_value) {
                                                  final _counter =
                                                      Provider.of<cartCounter>(
                                                          context,
                                                          listen: false);
                                                  _counter
                                                      .changeCounter(_value);
                                                },
                                              ),
                                            );
                                    },
                                    child: SizedBox(
                                      width: _width * .05,
                                      height: _width * .05,
                                      child: FittedBox(
                                        child: Consumer<cartCounter>(
                                          builder: (context, value, child) =>
                                              Badge(
                                            badgeContent: Text(
                                                value.badgeNumber.toString(),
                                                style: GoogleFonts.poppins(
                                                  fontSize: _width * 0.03,
                                                )),
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
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: CarouselSlider(
                        options: CarouselOptions(
                            disableCenter: true,
                            pageSnapping: true,
                            viewportFraction: 1,
                            aspectRatio: 4.5 / 1.9,
                            autoPlay: true,
                            enlargeCenterPage: false),
                        items: [
                          'BBQ_Images/BannerData/1.png',
                          'BBQ_Images/BannerData/3.png'
                        ].map((banner) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Image.asset(
                                  banner,
                                  fit: BoxFit.fill,
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),

                    /***** Shop Popular Grills (Landscape) here *****/
                    SizedBox(
                      width: _width,
                      height: _height * 1.2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: _width,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AutoSizeText(
                                    'Shop Our Most Popular Grills',
                                    maxLines: 1,
                                    style: GoogleFonts.poppins(
                                      fontSize: _width * 0.035,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  OpenContainer(
                                    closedElevation: 0,
                                    transitionType: transitionType,
                                    tappable: true,
                                    transitionDuration:
                                        const Duration(seconds: 1),
                                    openBuilder: (BuildContext context,
                                        void Function({Object? returnValue})
                                            action) {
                                      return const ProductList(
                                        categories: [],
                                        title: 'Shop Our Most Popular Grills',
                                        categoryValue: '3',
                                      );
                                    },
                                    closedBuilder: (BuildContext context,
                                            void Function() action) =>
                                        Image.asset(
                                      'BBQ_Images/right_arrow.png',
                                      height: _width * .08,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _isVisible == false
                                ? _productError == true
                                    ? const Center(
                                        child: Text('Something went wrong.'),
                                      )
                                    : CustomLoader(
                                        imagePath:
                                            'BBQ_Images/Fav_Icon_BBQ_Outlets.png',
                                        color: ConstantsVar.appColor,
                                      )
                                : SizedBox(
                                    height: _height,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(
                                        products.isEmpty ? 0 : products.length,
                                        (productIndex) {
                                          return OpenContainer(
                                            closedElevation: 0,
                                            transitionType: transitionType2,
                                            tappable: true,
                                            transitionDuration:
                                                const Duration(seconds: 1),
                                            openBuilder: (BuildContext context,
                                                void Function(
                                                        {Object? returnValue})
                                                    action) {
                                              return NewProductDetails(
                                                productId:
                                                    products[productIndex].id,
                                                screenName: 'Home Screen',
                                              );
                                            },
                                            closedBuilder: (BuildContext
                                                        context,
                                                    void Function() action) =>
                                                Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Container(
                                                width: _width * .33,
                                                color: Colors.white,
                                                child: Stack(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Center(
                                                          child: Card(
                                                            child:
                                                                FadeImageEffect(
                                                              imageList: [
                                                                products[
                                                                        productIndex]
                                                                    .image
                                                              ].isEmpty
                                                                  ? [
                                                                      'https://us.123rf.com/450wm/urfandadashov/urfandadashov1806/urfandadashov180601827/150417827-photo-not-available-vector-icon-isolated-on-transparent-background-photo-not-available-logo-concept.jpg?ver=6',
                                                                    ]
                                                                  : [
                                                                      "https://magento-561260-2500518.cloudwaysapps.com/pub/media/catalog/product/${products[productIndex].image}"
                                                                    ],
                                                              width:
                                                                  _width * .25,
                                                              height:
                                                                  _width * .25,
                                                              type: 'network',
                                                            ),
                                                          ),
                                                        ),
                                                        RatingBarWidget(
                                                          rating: 5,
                                                          disable: true,
                                                          onRatingChanged:
                                                              (val) => '',
                                                          activeColor: _color,
                                                          size: 20,
                                                        ),
                                                        SizedBox(
                                                          width: _width * .46,
                                                          child: AutoSizeText(
                                                            products[
                                                                    productIndex]
                                                                .name,
                                                            textAlign:
                                                                TextAlign.start,
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: _width *
                                                                  0.043,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Visibility(
                                                          visible:
                                                              _isSpecialPrice(
                                                                  productIndex),
                                                          child: RichText(
                                                            text: TextSpan(
                                                              text:
                                                                  'Regular Price',
                                                              style: TextStyle(
                                                                wordSpacing: 2,
                                                                color: Colors
                                                                    .black,
                                                                fontSize:
                                                                    _width *
                                                                        0.022,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                  text:
                                                                      ' \$${double.parse((products[productIndex].price.toDouble()).toStringAsFixed(2))}',
                                                                  style:
                                                                      TextStyle(
                                                                    wordSpacing:
                                                                        2,
                                                                    fontSize:
                                                                        _width *
                                                                            0.022,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        RichText(
                                                          text: TextSpan(
                                                            text:
                                                                '\$${checkPrice(productIndex)} ',
                                                            style: TextStyle(
                                                              wordSpacing: 2,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: _width *
                                                                  0.024,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                text:
                                                                    '+ FREE Shipping',
                                                                style:
                                                                    TextStyle(
                                                                  wordSpacing:
                                                                      2,
                                                                  color: const Color
                                                                          .fromRGBO(
                                                                      228,
                                                                      122,
                                                                      39,
                                                                      1),
                                                                  fontSize:
                                                                      _width *
                                                                          0.02,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // AutoSizeText(
                                                        //   'Starting Price at \$122/mo with easy financing',
                                                        //   textAlign:
                                                        //       TextAlign.start,
                                                        //   maxLines: 2,
                                                        //   style: TextStyle(
                                                        //     color: Colors.grey,
                                                        //     fontSize:
                                                        //         _width * 0.028,
                                                        //     fontWeight:
                                                        //         FontWeight.bold,
                                                        //   ),
                                                        // ),
                                                        LoadingButton(
                                                          // key: _loadingKey,
                                                          type:
                                                              LoadingButtonType
                                                                  .Raised,
                                                          loadingWidget:
                                                              const SpinKitPianoWave(
                                                            color: Colors.white,
                                                            size: 14,
                                                          ),
                                                          color: const Color
                                                              .fromARGB(
                                                            255,
                                                            102,
                                                            102,
                                                            102,
                                                          ),
                                                          width: _width * .2,
                                                          height: 35,
                                                          onPressed: () async {
                                                            var _login =
                                                                await ConstantsVar
                                                                        .storage
                                                                        .read(
                                                                            key:
                                                                                'customerId') ??
                                                                    false;
                                                            // print(_login);
                                                            if (_login ==
                                                                false) {
                                                              await Navigator
                                                                  .push(
                                                                context,
                                                                CupertinoPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const LoginScreen(
                                                                    screenKey:
                                                                        'Home Screen',
                                                                  ),
                                                                ),
                                                              );
                                                            } else {
                                                              await CustomerApis.addToCart(
                                                                      cartId:
                                                                          await ConstantsVar.storage.read(key: 'cartID') ??
                                                                              '',
                                                                      sku: products[
                                                                              productIndex]
                                                                          .sku,
                                                                      context:
                                                                          context,
                                                                      customerToken:
                                                                          await ConstantsVar.storage.read(key: 'customerToken') ??
                                                                              '',
                                                                      quantity:
                                                                          '1')
                                                                  .whenComplete(
                                                                      () async {
                                                                await ApiCalls.readCounter(
                                                                        context:
                                                                            context)
                                                                    .then(
                                                                        (_value) {
                                                                  final _counter = Provider.of<
                                                                          cartCounter>(
                                                                      context,
                                                                      listen:
                                                                          false);
                                                                  _counter
                                                                      .changeCounter(
                                                                          _value);
                                                                });
                                                              });
                                                            }
                                                          },
                                                          defaultWidget:
                                                              const Center(
                                                            child: AutoSizeText(
                                                              'Add to cart',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
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
                          ],
                        ),
                      ),
                    ),
                    /***** End of Shop Popular Grills (Landscape) *****/

                    /***** Shop by Department (Landscape) here *****/
                    ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      children: [
                        AutoSizeText(
                          'Shop By Department',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: _width * .038,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 3,
                            childAspectRatio: 3.5 / 4,
                            crossAxisSpacing: 10,
                            physics: const NeverScrollableScrollPhysics(),
                            children: List.generate(
                              departNames.length,
                              (index) {
                                return OpenContainer(
                                  closedElevation: 0,
                                  transitionType: transitionType,
                                  tappable: true,
                                  transitionDuration:
                                      const Duration(seconds: 1),
                                  openBuilder: (BuildContext context,
                                      void Function({Object? returnValue})
                                          action) {
                                    return SpinKitPouringHourGlass(
                                      color: ConstantsVar.appColor,
                                      size: _height * .1,
                                    );
                                    /*ProductList(
                                        title:
                                            _listPopularDepartment[index].title,
                                        categoryValue:
                                            _listPopularDepartment[index].subId,
                                        categories:
                                            _listPopularDepartment[index]
                                                .subCategoryies);*/
                                  },
                                  closedBuilder: (BuildContext context,
                                          void Function() action) =>
                                      SizedBox(
                                    height: _height * 0.44,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: FadeImageEffect(
                                            imageList: [
                                              "https://magento-561260-2500518.cloudwaysapps.com/pub/media/${departImages[index].trim()}"
                                            ],
                                            width: _width * .25,
                                            height: _width * .25,
                                            type: 'network',
                                          ),
                                        ),
                                        Center(
                                          child: AutoSizeText(
                                            departNames[index]
                                                .replaceAll("&amp;", "&"),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w800,
                                                fontSize: _width * .012),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    /***** End of Shop by Department (Landscape) *****/

                    /***** Shop by Brand (Landscape) here *****/
                    ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      children: [
                        AutoSizeText(
                          'Shop By Brands',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: _width * .038,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: CarouselSlider(
                            options: CarouselOptions(
                              height: _height * .5,
                              autoPlay: true,
                              viewportFraction: 0.35,
                              disableCenter: true,
                            ),
                            items: brandImages.map((e) {
                              return OpenContainer(
                                closedElevation: 0,
                                transitionType: transitionType2,
                                tappable: true,
                                transitionDuration: const Duration(seconds: 1),
                                openBuilder: (BuildContext context,
                                    void Function({Object? returnValue})
                                        action) {
                                  return ProductList(
                                    title: brandNames[brandImages.indexOf(e)],
                                    categoryValue:
                                        brandIds[brandImages.indexOf(e)],
                                    categories: const [],
                                  );
                                },
                                closedBuilder: (BuildContext context,
                                        void Function() action) =>
                                    SizedBox(
                                  height: _height * .35,
                                  child: Container(
                                    width: _width * .43,
                                    height: _width * .29,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          "https://magento-561260-2500518.cloudwaysapps.com/pub/media/${brandImages[brandImages.indexOf(e)].trim()}",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: _width * .1),
                          child: LoadingButton(
                              height: _height * .16,
                              width: _width * .5,
                              color: Colors.black,
                              defaultWidget: Text(
                                'Shop All Brands',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: _width * .028,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () => null),
                        )
                      ],
                    ),
                    /***** End of Shop by Brand (Landscape) *****/

                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: _width * .10,
                      ),
                      child: Image.asset('BBQ_Images/banner2_footer.jpeg'),
                    ),

                    /***** Special Offers (Landscape) here *****/
                    ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      children: [
                        AutoSizeText(
                          "Special Offers",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: _width * .038,
                          ),
                        ),
                        CarouselSlider(
                          options: CarouselOptions(
                            height: _height * .9,
                            autoPlay: true,
                            viewportFraction: 0.6,
                            disableCenter: true,
                          ),
                          items: offerNames.map(
                            (e) {
                              return OpenContainer(
                                closedElevation: 0,
                                transitionType: transitionType2,
                                tappable: true,
                                transitionDuration: const Duration(seconds: 1),
                                openBuilder: (BuildContext context,
                                    void Function({Object? returnValue})
                                        action) {
                                  return SpinKitPouringHourGlass(
                                    color: ConstantsVar.appColor,
                                    size: _width * .05,
                                  );
                                },
                                closedBuilder: (BuildContext context,
                                        void Function() action) =>
                                    Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: _width * .95,
                                      height: _width * .35,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.rectangle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              "https://magento-561260-2500518.cloudwaysapps.com/pub/media/${offerImages.isEmpty ? "" : offerImages[offerNames.indexOf(e)].trim()}"),
                                        ),
                                      ),
                                    ),
                                    AutoSizeText(
                                      offerNames[offerNames.indexOf(e)].trim(),
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: _width * .022,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ],
                    ),
                    /***** End of Special Offers (Landscape) *****/

                    ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      children: [
                        AutoSizeText(
                          'BBQ Outlets Guarantee',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: _width * .038,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 4,
                            childAspectRatio: 2.5 / 4,
                            crossAxisSpacing: 10,
                            physics: const NeverScrollableScrollPhysics(),
                            children: List.generate(
                              _serviceList.length,
                              (index) => Column(
                                children: [
                                  SizedBox(
                                    width: _width * .2,
                                    height: _width * .2,
                                    child: Image.asset(
                                      _serviceList[index].image,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  AutoSizeText(
                                    _serviceList[index].name,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: _width * .03,
                                      wordSpacing: .0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      color: Colors.black,
                      child: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(
                          _extraInfo.length + 1,
                          (index) {
                            if (index == _extraInfo.length) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: _width * .5,
                                          height: _width * .08,
                                          color: Colors.white,
                                          child: Center(
                                            child: TextFormField(
                                              decoration: const InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.all(20.0),
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                hintText:
                                                    'Enter your email address',
                                                hintStyle: TextStyle(
                                                    color: Colors.black,
                                                    textBaseline: TextBaseline
                                                        .ideographic),
                                                prefixIcon: Icon(
                                                  Icons.email,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: _width * .2,
                                          height: _width * .08,
                                          color: _color,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                                child: Text(
                                              'Subscribe',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Container(
                                      color: Colors.black,
                                      width: _width,
                                      child: Row(
                                        children: [
                                          'BBQ_Images/facebook.png',
                                          'BBQ_Images/yelp.png',
                                          'BBQ_Images/instagram.png',
                                          'BBQ_Images/twitter.png',
                                          'BBQ_Images/youtube.png',
                                        ]
                                            .map(
                                              (e) => Image.asset(
                                                e,
                                                width: _width * 0.1,
                                                height: _width * 0.08,
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      _extraInfo[index].title,
                                      style: GoogleFonts.poppins(
                                        color: _color,
                                        fontWeight: FontWeight.bold,
                                        fontSize: _width * .03,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: List.generate(
                                        _extraInfo[index].extraTitles.length,
                                        (_index) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 6.0,
                                          ),
                                          child: AutoSizeText(
                                            _extraInfo[index]
                                                .extraTitles[_index],
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: _width * .02,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const SampleProductPage(),
                        ),
                      ),
                      child: Container(
                        height: _height * .15,
                        color: Colors.grey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Center(
                            child: AutoSizeText(
                              'Copyright 1996-2021 BBQ Outlets Inc. All Rights Reserved.',
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: _width * .02,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        floatingActionButton: Visibility(
          visible: checkOffset == true ? true : false,
          child: Container(
            width: _width,
            height: _height * .14,
            color: Colors.white,
            child: SizedBox(
              width: _width * .6,
              child: FittedBox(
                child: GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const NewSearchPage())),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: _width * .06, vertical: 5),
                    child: Container(
                      width: _width * .6,
                      height: _height * .1,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2.0,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: AutoSizeText(
                            'Search',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: _width * .046,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      ),
    );
  }

  Widget _portraitOrientationBuilder() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return SafeArea(
      bottom: true,
      maintainBottomViewPadding: true,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: Drawer(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              children: [
                Hero(
                  tag: logoTag,
                  child: SizedBox(
                    height: _height * .08,
                    child: Image.asset(logoImage),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Pages(
                  title: 'title',
                  list: categoryList,
                  isCatLoading: _isCatLoading,
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Column(
            children: [
              SizedBox(
                width: _width,
                height: _height * .1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => _scaffoldKey.currentState!.openDrawer(),
                        child: Image.asset(
                          'BBQ_Images/menu.png',
                          width: _width * .068,
                          height: _width * .068,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Hero(
                        tag: logoTag1,
                        transitionOnUserGestures: true,
                        child: Image.asset(
                          logoImage,
                          width: _width * .40,
                          height: _width * .34,
                          fit: BoxFit.cover,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          var _login = await ConstantsVar.storage
                                  .read(key: 'customerId') ??
                              false;
                          _login == false
                              ? await Navigator.pushNamed(
                                  context,
                                  kLoginScreen,
                                )
                              : await Navigator.pushNamed(
                                  context,
                                  kCartScreen,
                                ).whenComplete(
                                  () async => await ApiCalls.readCounter(
                                          context: context)
                                      .then(
                                    (_value) {
                                      final _counter = Provider.of<cartCounter>(
                                          context,
                                          listen: false);
                                      _counter.changeCounter(_value);
                                    },
                                  ),
                                );
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
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => const NewSearchPage())),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: _width * .06, vertical: 5),
                  child: Container(
                    width: _width,
                    height: _height * .05,
                    decoration: BoxDecoration(
                      border: Border.all(
                        // color: Colors.red,
                        //                   <--- border color
                        width: 2.0,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: AutoSizeText(
                          'Search',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: _width * .046,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(
                      height: _height * .22,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: CarouselSlider(
                          options: CarouselOptions(
                              disableCenter: true,
                              pageSnapping: true,
                              viewportFraction: 1,
                              aspectRatio: 4.5 / 1.9,
                              autoPlay: true,
                              enlargeCenterPage: false),
                          items: [
                            'BBQ_Images/BannerData/1.png',
                            'BBQ_Images/BannerData/3.png'
                          ].map((banner) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 2.0),
                                  child: Image.asset(
                                    banner,
                                    fit: BoxFit.fill,
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    /***** Shop Popular Grills (Portrait) here *****/
                    SizedBox(
                      width: _width,
                      height: _height * .62,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: _width * 2,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AutoSizeText(
                                    'Shop Our Most Popular Grills',
                                    maxLines: 1,
                                    style: GoogleFonts.poppins(
                                      fontSize: _width * 0.051,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  OpenContainer(
                                    closedElevation: 0,
                                    transitionType: transitionType,
                                    tappable: true,
                                    transitionDuration:
                                        const Duration(seconds: 1),
                                    openBuilder: (BuildContext context,
                                        void Function({Object? returnValue})
                                            action) {
                                      return const ProductList(
                                        categories: [],
                                        title: 'Shop Our Most Popular Grills',
                                        categoryValue: '3',
                                      );
                                    },
                                    closedBuilder: (BuildContext context,
                                            void Function() action) =>
                                        Image.asset(
                                      'BBQ_Images/right_arrow.png',
                                      height: _width * .06,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _isVisible == false
                                ? _productError == true
                                    ? const Center(
                                        child: Text('Something went wrong.'),
                                      )
                                    : CustomLoader(
                                        imagePath:
                                            'BBQ_Images/Fav_Icon_BBQ_Outlets.png',
                                        color: ConstantsVar.appColor,
                                      )
                                : SizedBox(
                                    height: _height * .46,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(
                                        products.isEmpty ? 0 : products.length,
                                        (productIndex) {
                                          return OpenContainer(
                                            closedElevation: 0,
                                            transitionType: transitionType2,
                                            tappable: true,
                                            transitionDuration:
                                                const Duration(seconds: 1),
                                            openBuilder: (BuildContext context,
                                                void Function(
                                                        {Object? returnValue})
                                                    action) {
                                              return NewProductDetails(
                                                productId:
                                                    products[productIndex].id,
                                                screenName: 'Home Screen',
                                              );
                                            },
                                            closedBuilder: (BuildContext
                                                        context,
                                                    void Function() action) =>
                                                Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Container(
                                                width: _width * .46,
                                                color: Colors.white,
                                                child: Stack(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Card(
                                                          child:
                                                              FadeImageEffect(
                                                            imageList: [
                                                              products[
                                                                      productIndex]
                                                                  .image
                                                            ].isEmpty
                                                                ? [
                                                                    'https://us.123rf.com/450wm/urfandadashov/urfandadashov1806/urfandadashov180601827/150417827-photo-not-available-vector-icon-isolated-on-transparent-background-photo-not-available-logo-concept.jpg?ver=6',
                                                                  ]
                                                                : [
                                                                    "https://magento-561260-2500518.cloudwaysapps.com/pub/media/catalog/product/${products[productIndex].image}"
                                                                  ],
                                                            width: _width * .44,
                                                            height:
                                                                _width * .44,
                                                            type: 'network',
                                                          ),
                                                        ),
                                                        RatingBarWidget(
                                                          rating: 5,
                                                          disable: true,
                                                          onRatingChanged:
                                                              (val) => '',
                                                          activeColor: _color,
                                                          size: 25,
                                                        ),
                                                        SizedBox(
                                                          width: _width * .46,
                                                          child: AutoSizeText(
                                                            products[
                                                                    productIndex]
                                                                .name,
                                                            textAlign:
                                                                TextAlign.start,
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: _width *
                                                                  0.043,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Visibility(
                                                          visible:
                                                              _isSpecialPrice(
                                                                  productIndex),
                                                          child: RichText(
                                                            text: TextSpan(
                                                              text:
                                                                  'Regular Price',
                                                              style: TextStyle(
                                                                wordSpacing: 2,
                                                                color: Colors
                                                                    .black,
                                                                fontSize:
                                                                    _width *
                                                                        0.034,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                  text:
                                                                      ' \$${double.parse((products[productIndex].price.toDouble()).toStringAsFixed(2))}',
                                                                  style:
                                                                      TextStyle(
                                                                    wordSpacing:
                                                                        2,
                                                                    fontSize:
                                                                        _width *
                                                                            0.042,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        RichText(
                                                          text: TextSpan(
                                                            text:
                                                                '\$${checkPrice(productIndex)} ',
                                                            style: TextStyle(
                                                              wordSpacing: 2,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: _width *
                                                                  0.042,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                text:
                                                                    '+ FREE Shipping',
                                                                style:
                                                                    TextStyle(
                                                                  wordSpacing:
                                                                      2,
                                                                  color: const Color
                                                                          .fromRGBO(
                                                                      228,
                                                                      122,
                                                                      39,
                                                                      1),
                                                                  fontSize:
                                                                      _width *
                                                                          0.034,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        /*AutoSizeText(
                                                          'Starting Price at \$122/mo with easy financing',
                                                          textAlign:
                                                              TextAlign.start,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize:
                                                                _width * 0.028,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),*/
                                                        LoadingButton(
                                                          // key: _loadingKey,
                                                          type:
                                                              LoadingButtonType
                                                                  .Raised,
                                                          loadingWidget:
                                                              const SpinKitPianoWave(
                                                            color: Colors.white,
                                                            size: 14,
                                                          ),
                                                          color: const Color
                                                              .fromARGB(
                                                            255,
                                                            102,
                                                            102,
                                                            102,
                                                          ),
                                                          width: _width * .25,
                                                          height: 35,
                                                          onPressed: () async {
                                                            var _login =
                                                                await ConstantsVar
                                                                        .storage
                                                                        .read(
                                                                            key:
                                                                                'customerId') ??
                                                                    false;
                                                            if (_login ==
                                                                false) {
                                                              await Navigator
                                                                  .push(
                                                                context,
                                                                CupertinoPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const LoginScreen(
                                                                    screenKey:
                                                                        'Home Screen',
                                                                  ),
                                                                ),
                                                              );
                                                            } else {
                                                              await CustomerApis.addToCart(
                                                                      cartId:
                                                                          await ConstantsVar.storage.read(key: 'cartID') ??
                                                                              '',
                                                                      sku: products[
                                                                              productIndex]
                                                                          .sku,
                                                                      context:
                                                                          context,
                                                                      customerToken:
                                                                          await ConstantsVar.storage.read(key: 'customerToken') ??
                                                                              '',
                                                                      quantity:
                                                                          '1')
                                                                  .whenComplete(
                                                                      () async {
                                                                await ApiCalls.readCounter(
                                                                        context:
                                                                            context)
                                                                    .then(
                                                                        (_value) {
                                                                  final _counter = Provider.of<
                                                                          cartCounter>(
                                                                      context,
                                                                      listen:
                                                                          false);
                                                                  _counter
                                                                      .changeCounter(
                                                                          _value);
                                                                });
                                                              });
                                                            }
                                                          },
                                                          defaultWidget:
                                                              const Center(
                                                            child: AutoSizeText(
                                                              'Add to cart',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
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
                          ],
                        ),
                      ),
                    ),
                    /***** End of Shop Popular Grills (Portrait) *****/

                    /***** Shop by Department (Portrait) here *****/
                    ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      children: [
                        AutoSizeText(
                          'Shop By Department',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: _width * .06,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            childAspectRatio: 2.89 / 4,
                            crossAxisSpacing: 10,
                            physics: const NeverScrollableScrollPhysics(),
                            children: List.generate(
                              departNames.length,
                              (index) {
                                return OpenContainer(
                                  closedElevation: 0,
                                  transitionType: transitionType,
                                  tappable: true,
                                  transitionDuration:
                                      const Duration(seconds: 1),
                                  openBuilder: (BuildContext context,
                                      void Function({Object? returnValue})
                                          action) {
                                    return SpinKitPouringHourGlass(
                                      color: ConstantsVar.appColor,
                                      size: _width * .1,
                                    );
                                    /*ProductList(
                                        title:
                                            _listPopularDepartment[index].title,
                                        categoryValue:
                                            _listPopularDepartment[index].subId,
                                        categories:
                                            _listPopularDepartment[index]
                                                .subCategoryies);*/
                                  },
                                  closedBuilder: (BuildContext context,
                                          void Function() action) =>
                                      SizedBox(
                                    height: _height * 0.45,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: FadeImageEffect(
                                            imageList: [
                                              "https://magento-561260-2500518.cloudwaysapps.com/pub/media/${departImages[index].trim()}"
                                            ],
                                            width: _width * .44,
                                            height: _width * .44,
                                            type: 'network',
                                          ),
                                        ),
                                        Center(
                                          child: AutoSizeText(
                                            departNames[index]
                                                .replaceAll("&amp;", "&"),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w800,
                                                fontSize: _width * .040),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    /***** End of Shop by Department (Portrait) *****/

                    /***** Shop by Brand (Portrait) here *****/
                    ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      children: [
                        AutoSizeText(
                          'Shop By Brands',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: _width * .06,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 10,
                            physics: const NeverScrollableScrollPhysics(),
                            children: List.generate(
                              brandImages.length,
                              (index) => OpenContainer(
                                closedElevation: 0,
                                transitionType: transitionType2,
                                tappable: true,
                                transitionDuration: const Duration(seconds: 1),
                                openBuilder: (BuildContext context,
                                    void Function({Object? returnValue})
                                        action) {
                                  return ProductList(
                                    title: brandNames[index],
                                    categoryValue: brandIds[index],
                                    categories: const [],
                                  );
                                },
                                closedBuilder: (BuildContext context,
                                        void Function() action) =>
                                    SizedBox(
                                  height: _height * .35,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: _width * .43,
                                        height: _width * .30,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.rectangle,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                              "https://magento-561260-2500518.cloudwaysapps.com/pub/media/${brandImages[index].trim()}",
                                            ))),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: _width * .05),
                          child: LoadingButton(
                              height: 55,
                              width: _width,
                              color: Colors.black,
                              defaultWidget: Text(
                                'Shop All Brands',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: _width * .06,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () => null),
                        )
                      ],
                    ),
                    /***** End of Shop by Brand (Portrait) *****/

                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: _width * .10,
                      ),
                      child: Image.asset('BBQ_Images/banner2_footer.jpeg'),
                    ),

                    /***** Special Offers (Portrait) here *****/
                    ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      children: [
                        AutoSizeText(
                          "Special Offers",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: _width * .065,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: CarouselSlider(
                            options: CarouselOptions(
                              height: _height * .5,
                              autoPlay: true,
                              viewportFraction: 1,
                              disableCenter: true,
                            ),
                            items: offerNames.map(
                              (e) {
                                return OpenContainer(
                                  closedElevation: 0,
                                  transitionType: transitionType2,
                                  tappable: true,
                                  transitionDuration:
                                      const Duration(seconds: 1),
                                  openBuilder: (BuildContext context,
                                      void Function({Object? returnValue})
                                          action) {
                                    return SpinKitPouringHourGlass(
                                      color: ConstantsVar.appColor,
                                      size: _width * .1,
                                    );
                                  },
                                  closedBuilder: (BuildContext context,
                                          void Function() action) =>
                                      Column(
                                    children: [
                                      SizedBox(
                                        height: _height * .4,
                                        child: Container(
                                          width: _width * .95,
                                          height: _width,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.rectangle,
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  "https://magento-561260-2500518.cloudwaysapps.com/pub/media/${offerImages.isEmpty ? "" : offerImages[offerNames.indexOf(e)].trim()}"),
                                            ),
                                          ),
                                        ),
                                      ),
                                      AutoSizeText(
                                        offerNames[offerNames.indexOf(e)]
                                            .trim(),
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: _width * .044,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ],
                    ),
                    /***** End of Special Offers (Portrait) *****/

                    ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      children: [
                        AutoSizeText(
                          'BBQ Outlets Guarantee',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: _width * .06,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            childAspectRatio: 3 / 4,
                            crossAxisSpacing: 10,
                            physics: const NeverScrollableScrollPhysics(),
                            children: List.generate(
                              _serviceList.length,
                              (index) => Column(
                                children: [
                                  SizedBox(
                                    width: _width * .41,
                                    height: _width * .41,
                                    child: Image.asset(
                                      _serviceList[index].image,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  AutoSizeText(
                                    _serviceList[index].name,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: _width * .05,
                                      wordSpacing: .0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      color: Colors.black,
                      child: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(
                          _extraInfo.length + 1,
                          (index) {
                            if (index == _extraInfo.length) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: _width * .65,
                                          height: _width * .15,
                                          color: Colors.white,
                                          child: Center(
                                            child: TextFormField(
                                              decoration: const InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.all(20.0),
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                hintText:
                                                    'Enter your email address',
                                                hintStyle: TextStyle(
                                                    color: Colors.black,
                                                    textBaseline: TextBaseline
                                                        .ideographic),
                                                prefixIcon: Icon(
                                                  Icons.email,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: _width * .3,
                                          height: _width * .15,
                                          color: _color,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Text(
                                                'Subscribe',
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Container(
                                      color: Colors.black,
                                      width: _width,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          'BBQ_Images/facebook.png',
                                          'BBQ_Images/yelp.png',
                                          'BBQ_Images/instagram.png',
                                          'BBQ_Images/twitter.png',
                                          'BBQ_Images/youtube.png',
                                        ]
                                            .map(
                                              (e) => Image.asset(
                                                e,
                                                width: _width * 0.12,
                                                height: _width * 0.1,
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      _extraInfo[index].title,
                                      style: GoogleFonts.poppins(
                                        color: _color,
                                        fontWeight: FontWeight.bold,
                                        fontSize: _width * .06,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: List.generate(
                                        _extraInfo[index].extraTitles.length,
                                        (_index) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 6.0,
                                          ),
                                          child: AutoSizeText(
                                            _extraInfo[index]
                                                .extraTitles[_index],
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: _width * .04,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const SampleProductPage(),
                        ),
                      ),
                      child: Container(
                        color: Colors.grey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(
                            child: AutoSizeText(
                              'Copyright 1996-2021 BBQ Outlets Inc. All Rights Reserved.',
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: _width * .03,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
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

  bool _isSpecialPrice(int i) {
    return double.parse(
                (products[i].specialprice.toDouble()).toStringAsFixed(2)) >=
            double.parse((products[i].price.toDouble()).toStringAsFixed(2))
        ? false
        : true;
  }

  double checkPrice(int i) {
    return _isSpecialPrice(i)
        ? double.parse((products[i].specialprice.toDouble()).toStringAsFixed(2))
        : double.parse((products[i].price.toDouble()).toStringAsFixed(2));
  }

  void getBrandUrls(int i, List<String> urls) {
    urls[i].trim();
    urls[i].substring(7, (brandUrls.length) - 2);
  }

  void _getPopularDepartment() {
    _listPopularDepartment.add(
      SubCategoryModel(
        image: [
          'https://magento-561260-2500812.cloudwaysapps.com/pub/media/BBQ/homepage-images/img1.jpg',
        ],
        title: 'Outdoor Kitchens',
        subCategoryies: [],
        subId: '35',
      ),
    );
    _listPopularDepartment.add(SubCategoryModel(
        image: [
          'https://magento-561260-2500812.cloudwaysapps.com/pub/media/BBQ/homepage-images/Built-In.png'
        ],
        title: 'Built-In Gas Grills',
        subCategoryies: [],
        subId: '4'));
    _listPopularDepartment.add(
      SubCategoryModel(
          image: [
            'https://magento-561260-2500812.cloudwaysapps.com/pub/media/BBQ/homepage-images/Freestanding.png'
          ],
          title: 'Freestanding Grills',
          subCategoryies: [],
          subId: '58'),
    );

    _listPopularDepartment.add(
      SubCategoryModel(
          image: [
            'https://magento-561260-2500812.cloudwaysapps.com/pub/media/BBQ/homepage-images/Pellet.png'
          ],
          title: 'Pellet Grills & Smokers',
          subCategoryies: [],
          subId: '82'),
    );

    _listPopularDepartment.add(
      SubCategoryModel(
          image: [
            'https://magento-561260-2500812.cloudwaysapps.com/pub/media/BBQ/homepage-images/Kamado.png'
          ],
          title: 'Kamado Grills',
          subCategoryies: [],
          subId: '83'),
    );
    _listPopularDepartment.add(
      SubCategoryModel(
          image: [
            'https://magento-561260-2500812.cloudwaysapps.com/pub/media/BBQ/homepage-images/FirePits.png',
          ],
          title: 'Fire Pits & Tables',
          subCategoryies: [],
          subId: '132'),
    );
    _listPopularDepartment.add(
      SubCategoryModel(
          image: [
            'https://magento-561260-2500812.cloudwaysapps.com/pub/media/BBQ/homepage-images/Pizza.png'
          ],
          title: 'Pizza Ovens',
          subCategoryies: [],
          subId: '85'),
    );
    _listPopularDepartment.add(
      SubCategoryModel(
          image: [
            'https://magento-561260-2500812.cloudwaysapps.com/pub/media/BBQ/homepage-images/Portable.png'
          ],
          title: 'Portable Grills',
          subCategoryies: [],
          subId: '190'),
    );
    _listPopularDepartment.add(
      SubCategoryModel(
          image: [
            'https://magento-561260-2500812.cloudwaysapps.com/pub/media/BBQ/homepage-images/Refrigerators.png'
          ],
          title: 'Refrigerators',
          subCategoryies: [],
          subId: '133'),
    );

    _listPopularDepartment.add(
      SubCategoryModel(
        image: [
          'https://magento-561260-2500812.cloudwaysapps.com/pub/media/BBQ/homepage-images/Patio.png'
        ],
        title: 'Patio Furniture',
        subCategoryies: [],
        subId: '112',
      ),
    );

    setState(() {});
  }

  void _getTopBrands() {
    banners.add(
      TopBrands(
          imageName:
              'https://www.bbqoutlets.com/pub/media/catalog/category/alfresco.png',
          id: '62',
          title: 'Alfresco',
          categoriesvalueId:
              ConstantsVar.prefs.getInt("subcategories").toString()),
    );
    banners.add(
      TopBrands(
          imageName:
              'https://www.bbqoutlets.com/pub/media/catalog/category/blaze.jpg',
          id: '7',
          title: 'Blaze',
          categoriesvalueId:
              ConstantsVar.prefs.getInt("subcategories").toString()),
    );
    banners.add(
      TopBrands(
          imageName:
              'https://www.bbqoutlets.com/pub/media/catalog/category/coyoto.png',
          id: '78',
          title: 'Coyote',
          categoriesvalueId:
              ConstantsVar.prefs.getInt("subcategories").toString()),
    );
    banners.add(
      TopBrands(
          imageName:
              'https://www.bbqoutlets.com/pub/media/catalog/category/delta-heat.png',
          id: '39',
          title: 'Delta Heat',
          categoriesvalueId:
              ConstantsVar.prefs.getInt("subcategories").toString()),
    );

    setState(() {});
  }

  void _getServiceItems() {
    _serviceList.add(ServiceClass(
      image: 'BBQ_Images/service_images/ask.jpg',
      name: 'Ask an \nExpert',
    ));
    _serviceList.add(ServiceClass(
      image: 'BBQ_Images/service_images/freedesign.jpg',
      name: 'Free Design Services',
    ));
    _serviceList.add(ServiceClass(
      image: 'BBQ_Images/service_images/fin.jpg',
      name: '0%\n Financing',
    ));
    _serviceList.add(ServiceClass(
      image: 'BBQ_Images/service_images/exp.jpg',
      name: 'Expert\n Reviews',
    ));
    _serviceList.add(ServiceClass(
      image: 'BBQ_Images/service_images/shipping.jpg',
      name: 'Free\n Shipping',
    ));
    _serviceList.add(ServiceClass(
      image: 'BBQ_Images/service_images/price.jpg',
      name: 'Price Match Guarantee',
    ));
    setState(() {});
  }

  void _getExtraInfo() {
    _extraInfo.add(ExtraInfo(
      title: 'Customer Support',
      extraTitles: [
        'COVID-19 Updates',
        'Policies',
        'Order Status',
        'Shipping & Delivery',
        'FAQs',
        'Returns',
        'Commitment to Environment',
      ],
    ));
    _extraInfo.add(ExtraInfo(
      title: 'About Us',
      extraTitles: [
        'Price Matching Guarantee',
        'Customer Testimonials',
        'Become a Vendor',
        'Why Shop BBQ Outlets',
        'Join Our Team',
        'Our History',
        'About us',
        'Meet Our Team',
        'Grill Buying Guides',
      ],
    ));
    _extraInfo.add(
      ExtraInfo(
        title: 'My Account',
        extraTitles: [
          'Sign In',
          'View Cart',
          'My Wishlist',
          'Sitemap',
          'Contact Us',
        ],
      ),
    );
    _extraInfo.add(
      ExtraInfo(
        title: 'Free Design Services',
        extraTitles: [],
      ),
    );
    _extraInfo.add(
      ExtraInfo(
        title: 'Special Finance Offer',
        extraTitles: [],
      ),
    );
    _extraInfo.add(
      ExtraInfo(
        title: 'About',
        extraTitles: [
          'Founded in 2005, BBQ Outlets operates 2 showrooms in Southern California (more on the way!) as well as an unmatched e-commerce site.'
        ],
      ),
    );
    _extraInfo.add(
      ExtraInfo(
        title: 'Talk to us now:',
        extraTitles: [
          '(714)276-8289',
          '7 Days a Week, 10 a.m. to 6 p.m. PDT',
          'contact@bbqoutlets.com ',
        ],
      ),
    );
    _extraInfo.add(
      ExtraInfo(
        title: 'Sign Up For Our Newsletter:',
        extraTitles: [
          'Stay up-to-date with our promotions, sales, special offers and other discount information.',
        ],
      ),
    );
    setState(() {});
  }

  bool? isLogin;

  Future _getAdminToken() async {
    ConstantsVar.storage = const FlutterSecureStorage();
    _adminToken = await ConstantsVar.storage.read(key: 'adminToken') ?? '';

    log('_adminToken' + _adminToken);
    setState(() {});
  }
}

class ServiceClass {
  String image;
  String name;

  ServiceClass({required this.image, required this.name});
}

class ExtraInfo {
  String title;
  List<String> extraTitles;

  ExtraInfo({
    required this.title,
    required this.extraTitles,
  });
}

class Pages extends StatefulWidget {
  const Pages({
    Key? key,
    required this.title,
    required this.list,
    required this.isCatLoading,
  }) : super(key: key);
  final String title;
  final List<CategoryResposne> list;
  final bool isCatLoading;

  @override
  State<Pages> createState() {
    return _PagesState();
  }
}

class _PagesState extends State<Pages> {
  @override
  void initState() {
    super.initState();
    _getLogin();
  }

  var _login = false;

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.landscape
        ? _pagesLandscape()
        : _pagesPortrait();
  }

  Widget _pagesLandscape() {
    Color _color = const Color.fromRGBO(251, 151, 67, 1);
    double _width = MediaQuery.of(context).size.width;
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(
        widget.list.length + 1,
        (index) {
          if (widget.isCatLoading == true) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    FadeAnimatedText('Please wait.',
                        textStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: _width * 0.03)),
                    FadeAnimatedText('Please wait..',
                        textStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: _width * 0.04)),
                    FadeAnimatedText('Please wait...',
                        textStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: _width * 0.05)),
                    FadeAnimatedText('Please wait....',
                        textStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: _width * 0.06)),
                    FadeAnimatedText('Please wait.....',
                        textStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: _width * 0.07)),
                    FadeAnimatedText(
                      'Please wait......',
                      textStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: _width * 0.08,
                      ),
                    ),
                  ],
                ),
                SpinKitPouringHourGlass(
                  color: ConstantsVar.appColor,
                  size: 50,
                ),
              ],
            );
          } else if (index == widget.list.length) {
            return DelayedDisplay(
              delay: const Duration(milliseconds: 50),
              child: Column(
                children: [
                  SizedBox(
                    width: _width,
                    child: _login == false
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person_outline, color: _color),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    child: AutoSizeText(
                                      'My Account',
                                      style: GoogleFonts.poppins(
                                        fontSize: _width * .025,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () async => await Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => const LoginScreen(
                                      screenKey: 'Home Screen',
                                    ),
                                  ),
                                ).whenComplete(
                                  () => _getLogin(),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.login, color: _color),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    AutoSizeText(
                                      'Sign In or Sign Up',
                                      style: GoogleFonts.poppins(
                                        fontSize: _width * .025,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        : ExpansionTile(
                            title: Text(
                              'My Account',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                fontSize: _width * .025,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            children: [_userInfo(context: context)],
                          ),
                  ),
                  SizedBox(
                    width: _width,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            'Customer Service Hour',
                            style: GoogleFonts.poppins(
                              fontSize: _width * .026,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Icon(Icons.call, color: _color
                                  // color: Colors.grey,
                                  ),
                              const SizedBox(
                                width: 10,
                              ),
                              AutoSizeText(
                                '(714)276-8289',
                                style: GoogleFonts.poppins(
                                  fontSize: _width * .022,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Icon(Icons.chat_bubble_outline, color: _color),
                              const SizedBox(
                                width: 10,
                              ),
                              AutoSizeText(
                                'Live Chat',
                                style: GoogleFonts.poppins(
                                  fontSize: _width * .022,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.email_outlined,
                                color: _color,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              AutoSizeText(
                                'Email Us',
                                style: GoogleFonts.poppins(
                                  fontSize: _width * .022,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            if (widget.list[index].childrenData.isEmpty) {
              return DelayedDisplay(
                delay: const Duration(milliseconds: 50),
                child: OpenContainer(
                  closedElevation: 0,
                  transitionType: transitionType2,
                  tappable: true,
                  transitionDuration: const Duration(seconds: 1),
                  openBuilder: (BuildContext context,
                      void Function({Object? returnValue}) action) {
                    return ProductList(
                        title: widget.list[index].name,
                        categoryValue: widget.list[index].id,
                        categories: const []);
                  },
                  closedBuilder:
                      (BuildContext context, void Function() action) =>
                          ListTile(
                    title: Text(
                      widget.list[index].name,
                      textAlign: TextAlign.start,
                      style: GoogleFonts.poppins(
                        fontSize: _width * .025,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Text('       '),
                  ),
                ),
              );
            } else {
              return DelayedDisplay(
                delay: const Duration(milliseconds: 50),
                child: ExpansionTile(
                  onExpansionChanged: (val) {},
                  title: OpenContainer(
                    transitionType: transitionType,
                    tappable: true,
                    transitionDuration: const Duration(seconds: 1),
                    closedElevation: 0,
                    openBuilder: (BuildContext context,
                        void Function({Object? returnValue}) action) {
                      return ProductList(
                          title: widget.list[index].name,
                          categoryValue: widget.list[index].id,
                          categories: const []);
                    },
                    closedBuilder:
                        (BuildContext context, void Function() action) => Text(
                      widget.list[index].name,
                      textAlign: TextAlign.start,
                      style: GoogleFonts.poppins(
                        fontSize: _width * .025,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  children: List.generate(
                    widget.list[index].childrenData.length,
                    (_index) => widget.list[index].childrenData[_index]
                            .childrenData.isEmpty
                        ? DelayedDisplay(
                            delay: const Duration(milliseconds: 50),
                            child: OpenContainer(
                              transitionType: transitionType2,
                              tappable: true,
                              closedElevation: 0,
                              transitionDuration: const Duration(seconds: 1),
                              openBuilder: (BuildContext context,
                                  void Function({Object? returnValue}) action) {
                                return ProductList(
                                    title: widget
                                        .list[index].childrenData[_index].name,
                                    categoryValue: widget
                                        .list[index].childrenData[_index].id,
                                    categories: const []);
                              },
                              closedBuilder: (BuildContext context,
                                      void Function() action) =>
                                  Padding(
                                padding: const EdgeInsets.only(
                                  top: 10.0,
                                  left: 15,
                                  bottom: 5.0,
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: AutoSizeText(
                                    widget
                                        .list[index].childrenData[_index].name,
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.5,
                                        fontSize: _width * .02),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : DelayedDisplay(
                            delay: const Duration(milliseconds: 50),
                            child: ExpansionTile(
                              expandedAlignment: Alignment.bottomCenter,
                              title: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: OpenContainer(
                                  closedElevation: 0,
                                  transitionType: transitionType,
                                  tappable: true,
                                  transitionDuration:
                                      const Duration(seconds: 1),
                                  openBuilder: (BuildContext context,
                                      void Function({Object? returnValue})
                                          action) {
                                    return ProductList(
                                        title: widget.list[index]
                                            .childrenData[_index].name,
                                        categoryValue: widget.list[index]
                                            .childrenData[_index].id,
                                        categories: const []);
                                  },
                                  closedBuilder: (BuildContext context,
                                          void Function() action) =>
                                      Text(
                                    widget
                                        .list[index].childrenData[_index].name,
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        fontSize: _width * .02),
                                  ),
                                ),
                              ),
                              children: List.generate(
                                widget.list[index].childrenData[_index]
                                    .childrenData.length,
                                (idx) => Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 8.0,
                                      right: 60,
                                      left: 20,
                                      bottom: 8.0,
                                    ),
                                    child: OpenContainer(
                                      closedElevation: 0,
                                      transitionType: transitionType2,
                                      tappable: true,
                                      transitionDuration:
                                          const Duration(seconds: 1),
                                      openBuilder: (BuildContext context,
                                          void Function({Object? returnValue})
                                              action) {
                                        return ProductList(
                                          title: widget
                                              .list[index]
                                              .childrenData[_index]
                                              .childrenData[idx]
                                              .name,
                                          categoryValue: widget
                                              .list[index]
                                              .childrenData[_index]
                                              .childrenData[idx]
                                              .id,
                                          categories: const [],
                                        );
                                      },
                                      closedBuilder: (BuildContext context,
                                              void Function() action) =>
                                          AutoSizeText(
                                        widget.list[index].childrenData[_index]
                                            .childrenData[idx].name,
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 1.5,
                                            fontSize: _width * .018),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  Widget _pagesPortrait() {
    Color _color = const Color.fromRGBO(251, 151, 67, 1);
    double _width = MediaQuery.of(context).size.width;
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(
        widget.list.length + 1,
        (index) {
          if (widget.isCatLoading == true) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    FadeAnimatedText('Please wait.',
                        textStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: _width * 0.03)),
                    FadeAnimatedText('Please wait..',
                        textStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: _width * 0.04)),
                    FadeAnimatedText('Please wait...',
                        textStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: _width * 0.05)),
                    FadeAnimatedText('Please wait....',
                        textStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: _width * 0.06)),
                    FadeAnimatedText('Please wait.....',
                        textStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: _width * 0.07)),
                    FadeAnimatedText(
                      'Please wait......',
                      textStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: _width * 0.08,
                      ),
                    ),
                  ],
                ),
                SpinKitPouringHourGlass(
                  color: ConstantsVar.appColor,
                  size: 50,
                ),
              ],
            );
          } else if (index == widget.list.length) {
            return DelayedDisplay(
              delay: const Duration(milliseconds: 50),
              child: Column(
                children: [
                  SizedBox(
                    width: _width,
                    child: _login == false
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person_outline, color: _color),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    child: AutoSizeText(
                                      'My Account',
                                      style: GoogleFonts.poppins(
                                        fontSize: _width * .04,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () async => await Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => const LoginScreen(
                                      screenKey: 'Home Screen',
                                    ),
                                  ),
                                ).whenComplete(
                                  () => _getLogin(),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.login, color: _color),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    AutoSizeText(
                                      'Sign In or Sign Up',
                                      style: GoogleFonts.poppins(
                                        fontSize: _width * .035,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        : ExpansionTile(
                            title: Text(
                              'My Account',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                fontSize: _width * .04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            children: [_userInfo(context: context)],
                          ),
                  ),
                  SizedBox(
                    width: _width,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            'Customer Service Hour',
                            style: GoogleFonts.poppins(
                              fontSize: _width * .045,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Icon(Icons.call, color: _color
                                  // color: Colors.grey,
                                  ),
                              const SizedBox(
                                width: 10,
                              ),
                              AutoSizeText(
                                '(714)276-8289',
                                style: GoogleFonts.poppins(
                                  fontSize: _width * .035,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Icon(Icons.chat_bubble_outline, color: _color
                                  // color: Colors.grey,
                                  ),
                              const SizedBox(
                                width: 10,
                              ),
                              AutoSizeText(
                                'Live Chat',
                                style: GoogleFonts.poppins(
                                  fontSize: _width * .035,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.email_outlined,
                                color: _color,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              AutoSizeText(
                                'Email Us',
                                style: GoogleFonts.poppins(
                                  fontSize: _width * .035,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            if (widget.list[index].childrenData.isEmpty) {
              return DelayedDisplay(
                delay: const Duration(milliseconds: 50),
                child: OpenContainer(
                  closedElevation: 0,
                  transitionType: transitionType2,
                  tappable: true,
                  transitionDuration: const Duration(seconds: 1),
                  openBuilder: (BuildContext context,
                      void Function({Object? returnValue}) action) {
                    return ProductList(
                        title: widget.list[index].name,
                        categoryValue: widget.list[index].id,
                        categories: const []);
                  },
                  closedBuilder:
                      (BuildContext context, void Function() action) =>
                          ListTile(
                    title: Text(
                      widget.list[index].name,
                      textAlign: TextAlign.start,
                      style: GoogleFonts.poppins(
                        fontSize: _width * .04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Text('       '),
                  ),
                ),
              );
            } else {
              return DelayedDisplay(
                delay: const Duration(milliseconds: 50),
                child: ExpansionTile(
                  onExpansionChanged: (val) {},
                  title: OpenContainer(
                    transitionType: transitionType,
                    tappable: true,
                    transitionDuration: const Duration(seconds: 1),
                    closedElevation: 0,
                    openBuilder: (BuildContext context,
                        void Function({Object? returnValue}) action) {
                      return ProductList(
                          title: widget.list[index].name,
                          categoryValue: widget.list[index].id,
                          categories: const []);
                    },
                    closedBuilder:
                        (BuildContext context, void Function() action) => Text(
                      widget.list[index].name,
                      textAlign: TextAlign.start,
                      style: GoogleFonts.poppins(
                        fontSize: _width * .04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  children: List.generate(
                    widget.list[index].childrenData.length,
                    (_index) => widget.list[index].childrenData[_index]
                            .childrenData.isEmpty
                        ? DelayedDisplay(
                            delay: const Duration(milliseconds: 50),
                            child: OpenContainer(
                              transitionType: transitionType2,
                              tappable: true,
                              closedElevation: 0,
                              transitionDuration: const Duration(seconds: 1),
                              openBuilder: (BuildContext context,
                                  void Function({Object? returnValue}) action) {
                                return ProductList(
                                    title: widget
                                        .list[index].childrenData[_index].name,
                                    categoryValue: widget
                                        .list[index].childrenData[_index].id,
                                    categories: const []);
                              },
                              closedBuilder: (BuildContext context,
                                      void Function() action) =>
                                  Padding(
                                padding: const EdgeInsets.only(
                                  top: 10.0,
                                  left: 15,
                                  bottom: 5.0,
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: AutoSizeText(
                                    widget
                                        .list[index].childrenData[_index].name,
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.5,
                                        fontSize: _width * .035),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : DelayedDisplay(
                            delay: const Duration(milliseconds: 50),
                            child: ExpansionTile(
                              expandedAlignment: Alignment.bottomCenter,
                              title: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: OpenContainer(
                                  closedElevation: 0,
                                  transitionType: transitionType,
                                  tappable: true,
                                  transitionDuration:
                                      const Duration(seconds: 1),
                                  openBuilder: (BuildContext context,
                                      void Function({Object? returnValue})
                                          action) {
                                    return ProductList(
                                        title: widget.list[index]
                                            .childrenData[_index].name,
                                        categoryValue: widget.list[index]
                                            .childrenData[_index].id,
                                        categories: const []);
                                  },
                                  closedBuilder: (BuildContext context,
                                          void Function() action) =>
                                      Text(
                                    widget
                                        .list[index].childrenData[_index].name,
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        fontSize: _width * .035),
                                  ),
                                ),
                              ),
                              children: List.generate(
                                widget.list[index].childrenData[_index]
                                    .childrenData.length,
                                (idx) => Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 8.0,
                                      right: 60,
                                      left: 20,
                                      bottom: 8.0,
                                    ),
                                    child: OpenContainer(
                                      closedElevation: 0,
                                      transitionType: transitionType2,
                                      tappable: true,
                                      transitionDuration:
                                          const Duration(seconds: 1),
                                      openBuilder: (BuildContext context,
                                          void Function({Object? returnValue})
                                              action) {
                                        return ProductList(
                                          title: widget
                                              .list[index]
                                              .childrenData[_index]
                                              .childrenData[idx]
                                              .name,
                                          categoryValue: widget
                                              .list[index]
                                              .childrenData[_index]
                                              .childrenData[idx]
                                              .id,
                                          categories: const [],
                                        );
                                      },
                                      closedBuilder: (BuildContext context,
                                              void Function() action) =>
                                          AutoSizeText(
                                        widget.list[index].childrenData[_index]
                                            .childrenData[idx].name,
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 1.5,
                                            fontSize: _width * .035),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  void _getLogin() async {
    if (await ConstantsVar.storage.read(key: 'customerToken') == null) {
      _login = false;
    } else {
      _login = true;
    }
    firstName = await ConstantsVar.storage.read(key: 'customerFirstName') ?? '';
    lastName = await ConstantsVar.storage.read(key: 'customerLastName') ?? '';
    emailId = await ConstantsVar.storage.read(key: 'customerEmail') ?? '';
    log('Are you logged in? ' + _login.toString());
    setState(() {});
  }
}

String firstName = '';
String lastName = '';
String emailId = '';

Widget _userInfo({required BuildContext context}) {
  return DelayedDisplay(
    delay: const Duration(milliseconds: 50),
    child: Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Information',
                  style: GoogleFonts.poppins(
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
                    style: GoogleFonts.poppins(
                      fontSize: 3.w,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: firstName,
                        style: GoogleFonts.poppins(
                          fontSize: 3.w,
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
                    style: GoogleFonts.poppins(
                      fontSize: 3.w,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: lastName,
                        style: GoogleFonts.poppins(
                          fontSize: 3.w,
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
                    style: GoogleFonts.poppins(
                      fontSize: 3.w,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: emailId,
                        style: GoogleFonts.poppins(
                          fontSize: 3.w,
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
        Card(
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
                      // onTap: () async {
                      //   ConstantsVar.prefs =
                      //   await SharedPreferences.getInstance();
                      //
                      //   Navigator.push(
                      //       context,
                      //       CupertinoPageRoute(
                      //         builder: (context) => MyOrders(
                      //           isFromWeb: false,
                      //         ),
                      //       ));
                      // },
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 3,
                            horizontal: 5,
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
                                style: GoogleFonts.poppins(
                                  fontSize: 3.5.w,
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

                      // onTap: () async {
                      //   pushNewScreen(
                      //     context,
                      //     screen: ChangePassword(),
                      //     withNavBar: false,
                      //     // OPTIONAL VALUE. True by default.
                      //     pageTransitionAnimation:
                      //     PageTransitionAnimation.cupertino,
                      //   );
                      // },
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 3,
                            horizontal: 5,
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
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: AutoSizeText(
                                  'change password'.toUpperCase(),
                                  maxLines: 1,
                                  style: GoogleFonts.poppins(
                                    fontSize: 3.5.w,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
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
                  style: GoogleFonts.poppins(
                    fontSize: 3.5.w,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        Card(
          child: ListTile(
            onTap: () => Navigator.pushNamed(context, kCartScreen
                // CupertinoPageRoute(
                //   builder: (context) => CartScreen2(
                //     isOtherScren: false,
                //     otherScreenName: '',
                //   ),
                // ),
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
                  style: GoogleFonts.poppins(
                    fontSize: 3.5.w,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        Card(
          child: ListTile(
            onTap: () async {
              await CustomerApis.clearUserDetails().whenComplete(() async {
                Phoenix.rebirth(context);
              });
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
                  style: GoogleFonts.poppins(
                    fontSize: 3.5.w,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    ),
  );
}
