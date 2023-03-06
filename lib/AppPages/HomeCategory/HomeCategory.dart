// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'dart:async';

import 'package:BBQOUTLETS/AppPages/Categories/ProductList/SubCatProducts.dart';
import 'package:BBQOUTLETS/AppPages/HomeScreen/HomeScreen.dart';
import 'package:BBQOUTLETS/Constants/ConstantVariables.dart';
import 'package:BBQOUTLETS/utils/utils/build_config.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeCategory extends StatefulWidget {
  const HomeCategory({Key? key}) : super(key: key);

  @override
  _HomeCategoryState createState() => _HomeCategoryState();
}

class _HomeCategoryState extends State<HomeCategory> {
  List<HomeCategoryModel> categoryList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllCategory();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 14.w,
          backgroundColor: ConstantsVar.appColor,
          title: InkWell(
            onTap: () => Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (context) => const MyApp()),
                (route) => false),
            child: Image.asset(
              logoImage,
              width: 13.w,
              height: 13.w,
            ),
          ),
        ),
        body: SizedBox(
          width: 100.w,
          height: 100.h,
          child: ListView(
            shrinkWrap: true,
            children: List.generate(
                categoryList.length,
                (index) => Column(
                      children: [
                        Card(
                          child: SizedBox(
                            width: 100.w,
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: AutoSizeText(
                                    categoryList[index].title,
                                    style: GoogleFonts.openSans(
                                      fontSize: 4.w,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Fluttertoast.showToast(
                                          msg: categoryList[index].id);
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) => ProductList(
                                            title: categoryList[index].title,
                                            categoryValue:
                                                categoryList[index].id,
                                            categories: const [],
                                          ),
                                        ),
                                      );
                                    },
                                    child: SizedBox(
                                      width: 20.w,
                                      height: 30,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AutoSizeText(
                                            'View All',
                                            style: GoogleFonts.openSans(
                                              fontSize: 3.w,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Icon(
                                            Icons.arrow_forward,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        CategoryWidget(
                          subCategoryList: categoryList[index].subCategory,
                        )
                      ],
                    )),
          ),
        ),
      ),
    );
  }

  void getAllCategory() {
    categoryList.add(
      HomeCategoryModel(
          title: 'BBQ Grills & Smokers',
          subCategory: [
            SubCategoryModel(
                image: [
                  'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BBQ-FIRE-MAGIC-A790I-7EAN-BBQOUTLET.jpg',
                  'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BBQ-FIRE-MAGIC-A830I-8EAN-CB-BBQOUTLET.jpg',
                  'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BBQ-FIRE-MAGIC-A830I-8EAN-CB-BBQOUTLET.jpg',
                ],
                title: 'Gas Grills',
                subCategoryies: [
                  FurtherCategory(
                    subId: '38',
                    image: [
                      'https://www.bbqoutlets.com/pub/media/catalog/product//b/l/blz-4-lbm-lp_12.jpg'
                    ],
                    title: 'Built In',
                  ),
                  FurtherCategory(
                    subId: '40',
                    image: [
                      'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BBQ-HESTAN-GABR30-NG-TQ-BBQOUTLET.jpg'
                    ],
                    title: 'Freestanding',
                  ),
                  FurtherCategory(
                    subId: '206',
                    image: [
                      'https://www.bbqoutlets.com/pub/media/catalog/product//b/l/blz-3-lbm-ng_blz-3-cart_12.jpg'
                    ],
                    title: 'Flat Top Grills',
                  ),
                ],
                subId: '4'),
            SubCategoryModel(
                image: [
                  'https://www.bbqoutlets.com/pub/media/catalog/product//b/l/blz-4-char-blz-4-cart.jpg',
                  'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BBQ-twin-eagle-TECG30-C-BBQOUTLET.jpg',
                  'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BBQ-FIRE-MAGIC-A830I-8EAN-CB-BBQOUTLET.jpg',
                ],
                title: 'Charcoal Grills',
                subCategoryies: [
                  FurtherCategory(
                    subId: '59',
                    image: [
                      'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BBQ-FIRE-MAGIC-A830I-7EAN-CB-BBQOUTLET.jpg'
                    ],
                    title: 'Built In',
                  ),
                  FurtherCategory(
                    subId: '98',
                    image: [
                      'https://www.bbqoutlets.com/pub/media/catalog/product//b/l/blz-4-char-blz-4-cart.jpg'
                    ],
                    title: 'Freestanding',
                  ),
                ],
                subId: '58'),
            SubCategoryModel(
                image: [
                  'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/bbq-blz-elec-21_blz-elec21-base-bbqoutlet.jpg',
                  'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BBQ-HESTAN-C1P36_1-BBQOUTLET.jpg',
                  // 'https://www.bbqoutlets.com/memphis-grills-elite-wi-fi-controlled-39-inch-304-stainless-steel-built-in-pellet-grill-vgb0002s',
                ],
                title: 'Electric Grills',
                subCategoryies: [
                  FurtherCategory(
                    subId: '59',
                    image: [
                      'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/bbq-blz-elec-21-bbqoutlet.jpg'
                    ],
                    title: 'Built In',
                  ),
                  FurtherCategory(
                    subId: '87',
                    image: [
                      'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/bbq-blz-elec-21-bbqoutlet.jpg'
                    ],
                    title: 'Portable Electric',
                  ),
                ],
                subId: '60'),
            SubCategoryModel(
                image: [
                  'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BBQ-HESTAN-C1P36_1-BBQOUTLET.jpg',
                  'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BBQ-HESTAN-VGB0002S_1-BBQOUTLET.jpg',
                  'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BBQ-TWIN-EAGLE-tepg36r-tepgb36-BBQOUTLET.jpg',
                ],
                title: 'Pellet Grills',
                subCategoryies: [
                  FurtherCategory(
                    subId: '88',
                    image: [
                      'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BBQ-TWIN-EAGLE-tepg36g-tepgb36-BBQOUTLET.jpg'
                    ],
                    title: 'Freestanding',
                  ),
                  FurtherCategory(
                    subId: '89',
                    image: [
                      'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BBQ-HESTAN-C1P36_1-BBQOUTLET.jpg'
                    ],
                    title: 'Built In',
                  ),
                ],
                subId: '82'),
            SubCategoryModel(
                image: [
                  'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/bbq-kamado-bj24rhc-bbqoutlet.jpg',
                  'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/bbq-kamado-kj23nrhc-bbqoutlet.jpg',
                ],
                title: 'Kamado Grills',
                subCategoryies: [
                  FurtherCategory(
                    subId: '90',
                    image: [
                      'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/bbq-kamado-c1chcs-fs-bbqoutlet.jpg'
                    ],
                    title: 'Freestanding',
                  ),
                  FurtherCategory(
                    subId: '91',
                    image: [
                      'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/bbq-kamado-kj23nrhc-bbqoutlet.jpg'
                    ],
                    title: 'Built In',
                  ),
                ],
                subId: '83'),
            SubCategoryModel(
                image: [
                  'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BLZ-4LTE2MG-LP_1.jpg',
                ],
                title: 'Hybrid Infrared',
                subCategoryies: [
                  FurtherCategory(
                    subId: '38',
                    image: [
                      'https://www.bbqoutlets.com/pub/media/catalog/product//b/l/blz-4-lbm-lp_12.jpg'
                    ],
                    title: 'Built In',
                  ),
                  FurtherCategory(
                    subId: '40',
                    image: [
                      'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BBQ-HESTAN-GABR30-NG-TQ-BBQOUTLET.jpg'
                    ],
                    title: 'Freestanding',
                  ),
                  FurtherCategory(
                    subId: '206',
                    image: [
                      'https://www.bbqoutlets.com/pub/media/catalog/product//b/l/blz-3-lbm-ng_blz-3-cart_12.jpg'
                    ],
                    title: 'Flat Top Grills',
                  ),
                ],
                subId: '4'),
            SubCategoryModel(
                image: [
                  'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BBQ-HESTAN-FX4PIZ-LRAM_1-BBQOUTLET.jpg',
                  'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BBQ-HESTAN-CBO-O-KIT-750-HYB-NG-R-3K_1-BBQOUTLET.jpg',
                  'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BBQ-HESTAN-CBO-O-KIT-750_1-BBQOUTLET.jpg',
                ],
                title: 'Outdoor Pizza Ovens',
                subCategoryies: [
                  FurtherCategory(
                    subId: '94',
                    image: [
                      'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BBQ-HESTAN-SS-OVFS-LP_1-BBQOUTLET.jpg'
                    ],
                    title: 'Freestanding',
                  ),
                  FurtherCategory(
                    subId: '117',
                    image: [
                      'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BBQ-HESTAN-FX4PIZ-LRAM_1-BBQOUTLET.jpg'
                    ],
                    title: 'Wood-Fired Pizza Ovens',
                  ),
                  FurtherCategory(
                    subId: '115',
                    image: [
                      'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BBQ-HESTAN-SS-OVFS-LP_1-BBQOUTLET.jpg'
                    ],
                    title: 'Pizza Accessories',
                  ),
                ],
                subId: '85'),
            SubCategoryModel(
                image: [
                  'https://www.bbqoutlets.com/pub/media/catalog/product//b/l/blz-1pro-prtmg-lp.jpg',
                  'https://www.bbqoutlets.com/pub/media/catalog/product//b/l/blz-1pro-prt-lp-mg-blz-prtped-mg10_25.jpg',
                  'https://www.bbqoutlets.com/pub/media/catalog/product//b/l/blz-1pro-prt-lp-mg-blz-prtped-mg10_25_1.jpg'
                ],
                title: 'Portable Grills',
                subCategoryies: [
                  FurtherCategory(
                    subId: '190',
                    image: [
                      'https://www.bbqoutlets.com/pub/media/catalog/product//b/l/blz-1pro-prt-lp.jpg'
                    ],
                    title: 'Gas Grills',
                  ),
                  FurtherCategory(
                    subId: '191',
                    image: [
                      'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BBQ-Napoleon-PRO285-BK-BBQOUTLET.jpg'
                    ],
                    title: 'Electric Grills',
                  ),
                ],
                subId: '189'),
          ],
          id: '3'),
    );
    categoryList.add(
      HomeCategoryModel(
          title: 'Outdoor Kitchens',
          subCategory: [
            SubCategoryModel(
              image: [
                'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BBQ-BLAZE-BLZ-4LTE2-LP-4BICV-BLZ-AD32-R-BBQOUTLET.jpg',
                'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BBQ-BLAZE-BLZ-3PRO-LP-3PROBICV-BLZ-AD32-R-BBQOUTLET.jpg',
              ],
              title: 'BBQ Islands & Kits',
              subCategoryies: [],
              subId: '36',
            ),
            SubCategoryModel(
                image: [
                  'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BBQ-BLAZE-BLZ-3PRO-NG-PROPB-NG-50DH-DDC-R-TREC-DRW-3PROBICV-BBQOUTLET.jpg',
                  'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BLZ-GRIDDLE-IJ_1.jpg',
                ],
                title: 'BBQ Island Equipment Packages',
                subCategoryies: [],
                subId: '37'),
            SubCategoryModel(
                image: [
                  'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/bbq-blaze-blz-ssrf130_blz-ssfp-4.5-bbqoutlet_1.jpg',
                  'https://www.bbqoutlets.com/pub/media/catalog/product//d/b/dbc120bls-1.jpg',
                  'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BBQ-twin-eagle-TEOR24-F-BBQOUTLET.jpg',
                ],
                title: 'Outdoor Refrigerators',
                subCategoryies: [],
                subId: '133'),
            SubCategoryModel(
                image: [
                  'https://www.bbqoutlets.com/pub/media/catalog/product/b/b/BBQ-DELTA-HEAT-DHSB2-C-N-BBQOUTLET.jpg',
                  'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BBQ-DCS-BH1-48RS-L-BBQOUTLET.jpg',
                  'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BLZ-SB1-LP_1.jpg',
                ],
                title: 'Side Burners',
                subCategoryies: [],
                subId: '105'),
            SubCategoryModel(
                image: [
                  'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BBQ-TWIN-EAGLE-tesd361-b-BBQOUTLET.jpg',
                  'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BLZ-30W-3DRW_1.jpg',
                ],
                title: 'Door & Drawers',
                subCategoryies: [],
                subId: '106'),
            SubCategoryModel(
                image: [
                  'https://www.bbqoutlets.com/pub/media/catalog/product//kb/d/201660-7CH-6_1.jpg',
                  'https://www.bbqoutlets.com/pub/media/catalog/product//kb/d/201010-1-AB_8_201010-101_8_201099-LD_201080-39-28-AB_1.jpg',
                  'https://www.bbqoutlets.com/pub/media/catalog/product//kb/d/301126-3-4_1.jpg',
                ],
                title: 'Patio Furniture',
                subCategoryies: [],
                subId: '112'),
            SubCategoryModel(
                image: [
                  'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BLZ-TRNW-DRW_1.jpg',
                  'https://www.bbqoutlets.com/pub/media/catalog/product//b/b/BLZ-ICEB-WH_1.jpg',
                ],
                title: 'Outdoor Kitchen Storage',
                subCategoryies: [],
                subId: '267'),
          ],
          id: '35'),
    );
    setState(() {});
  }
}

class HomeCategoryModel {
  String title;
  String id;
  List<SubCategoryModel> subCategory;

  HomeCategoryModel({
    required this.title,
    required this.subCategory,
    required this.id,
  });
}

class SubCategoryModel {
  String title;
  String subId;
  List<String> image;
  List<FurtherCategory> subCategoryies;

  SubCategoryModel({
    required this.title,
    required this.image,
    required this.subId,
    required this.subCategoryies,
  });
}

class FurtherCategory {
  String title;
  String subId;
  List<String> image;

  FurtherCategory({
    required this.title,
    required this.subId,
    required this.image,
  });
}

class CategoryWidget extends StatefulWidget {
  CategoryWidget({
    Key? key,
    required this.subCategoryList,
  }) : super(key: key);
  List<SubCategoryModel> subCategoryList;

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  var _length = 5;

  var _isMore = false;
  String _viewTitle = 'View More';
  var _currentIndex = 0;
  late Timer _timer;
  List<String> _imageList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < widget.subCategoryList.length; i++) {
      _imageList = widget.subCategoryList[i].image;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      // semanticChildCount: 5,
      childAspectRatio: 5 / 6,
      scrollDirection: Axis.vertical,
      mainAxisSpacing: 5,
      crossAxisSpacing: 3,
      shrinkWrap: true,
      children: List.generate(
        _length + 1,
        (_index) {
          if (_index > _length - 1) {
            return GestureDetector(
              onTap: () {
                if (_isMore == true) {
                  _isMore = false;
                  _viewTitle = 'View More';
                  _length = 5;
                  log(_isMore);
                  setState(() {});
                } else {
                  _isMore = true;
                  _viewTitle = 'View Less';
                  _length = widget.subCategoryList.length - 1;
                  setState(() {});
                  log(_isMore);
                }
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(1.w),
                height: 43.w,
                width: 43.w,
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        _viewTitle,
                        style: TextStyle(
                          fontSize: 5.w,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        _isMore == false
                            ? Icons.arrow_forward
                            : Icons.arrow_back,
                        color: ConstantsVar.appColor,
                        size: 34,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
            if (mounted) {
              if (_currentIndex + 1 <=
                  widget.subCategoryList[_index].image.length) {
                _currentIndex = 0;
              } else {
                _currentIndex = _currentIndex + 1;
              }
              setState(() {});
            }
          });
          return InkWell(
            onTap: () => Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ProductList(
                  title: widget.subCategoryList[_index].title,
                  categoryValue: widget.subCategoryList[_index].subId,
                  categories: widget.subCategoryList[_index].subCategoryies,
                ),
              ),
            ),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: FadeImageEffect(
                        imageList: widget.subCategoryList[_index].image,
                        width: _width * .44,
                        height: _width * .44,
                        type: 'network',
                      ),
                    ),
                  ),
                  Center(
                    child: AutoSizeText(
                      widget.subCategoryList[_index].title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                        fontSize: 2.6.w,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class FadeImageEffect extends StatefulWidget {
  FadeImageEffect({
    Key? key,
    this.aspectRatio,
    required this.imageList,
    required this.height,
    required this.width,
    required this.type,
  }) : super(key: key);
  final List<String> imageList;
  final height;
  final width;
  final String type;
  double? aspectRatio;

  @override
  _FadeImageEffectState createState() => _FadeImageEffectState();
}

class _FadeImageEffectState extends State<FadeImageEffect>
    with TickerProviderStateMixin {
  var _currentIndex = 0;
  // var _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer.periodic(const Duration(seconds: 2, milliseconds: 500), (timer) async {
      if (mounted) {
        setState(() {
          if (_currentIndex + 1 == widget.imageList.length) {
            _currentIndex = 0;
          } else {
            _currentIndex = _currentIndex + 1;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(seconds: 2, milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          child: child,
          opacity: animation,
        );
      },
      child: widget.type.contains('network')
          ? CachedNetworkImage(
              width: widget.height,
              height: widget.width,
              imageUrl: widget.imageList[_currentIndex],
              key: ValueKey<int>(_currentIndex),
              fit: BoxFit.fill,
              progressIndicatorBuilder: (context, string, progress) =>
                  const SpinKitPouringHourGlass(
                color: Colors.orange,
                size: 40,
              ),
            )
          : AspectRatio(
              aspectRatio: widget.aspectRatio!,
              child: Image.asset(
                widget.imageList[_currentIndex],
                width: widget.height,
                height: widget.width,
                key: ValueKey<int>(_currentIndex),
                // fit: BoxFit.fitWidth,
              ),
            ),
    );
  }

  // @override
  // void dispose() {
  //   _controller.dispose() ;
  // }
}
