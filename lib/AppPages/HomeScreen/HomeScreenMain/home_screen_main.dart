import 'dart:ui';
import 'package:BBQOUTLETS/AppPages/Categories/ProductList/SubCatProducts.dart';
import 'package:BBQOUTLETS/BBQStaticModelClass/PopularDepartMent.dart';
import 'package:BBQOUTLETS/BBQStaticModelClass/toBrands.dart';
import 'package:BBQOUTLETS/BBQStaticModelClass/topdeals.dart';
import 'package:BBQOUTLETS/Constants/ConstantVariables.dart';
import 'package:BBQOUTLETS/models/home_response.dart';
import 'package:BBQOUTLETS/utils/utils/build_config.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:shared_preferences/shared_preferences.dart';

// @dart=2.9

class HomeScreenMain extends StatefulWidget {
  _HomeScreenMainState createState() => _HomeScreenMainState();

  HomeScreenMain({Key? key}) : super(key: key);
}

class _HomeScreenMainState extends State<HomeScreenMain> {
  String bannerImage = '';
  List<TopBrands> banners = [];
  List<HomePageCategoriesImage> categoryList = [];
  List<topDeals> productList = [];
  AssetImage assetImage = AssetImage("MyAssets/imagebackground.png");
  List<Widget> viewsList = [];
  List<popularDepartMent> _listpupulardepartment = [];
  int activeIndex = 0;
  bool showLoading = true;
  bool categoryVisible = false;
  List<dynamic> myList = [];
  late bool isSubCategory;

  int _listLength = 5;

  var _isMore = false;
  String _viewTitle = 'View More';

  void tapped(int index) {
    if (index == 1) {
      print("huray 1");
    } else {
      print("not the one :(");
    }
  }

  @override
  void initState() {
    super.initState();
    // ApiCa readCounter(customerGuid: gUId).then((value) => context.read<cartCounter>().changeCounter(value));

    // getApiToken().then((value) => apiCallToHomeScreen(value));

    getTopBrands();
    getTopDeals();
    getPopularDepartMent();
    // MagentoApis.getMegentoProductsbyCatId('3');
  }

  @override
  void didUpdateWidget(covariant HomeScreenMain oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    buildSafeArea(context);
  }

  // @override
  // void didUpdateWidget (
  //     )
  //

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: buildSafeArea(context),
      ),
    );
  }

  Widget buildSafeArea(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          // physics: NeverScrollableScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6),
              child: Container(
                width: 100.w,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Hero(
                    tag: homeTag,
                    child: Image.asset('BBQ_Images/bbqologomaster.png',
                        fit: BoxFit.fill,
                        width: Adaptive.w(14),
                        height: Adaptive.w(14)),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: 2,
                    right: 2,
                    bottom: 4,
                  ),
                  child: CarouselSlider(
                    options: CarouselOptions(
                        // enlargeStrategy: CenterPageEnlargeStrategy.height,
                        disableCenter: true,
                        pageSnapping: true,
                        // height: 24.h,
                        viewportFraction: 1,
                        aspectRatio: 6 / 1.5,
                        autoPlay: true,
                        enlargeCenterPage: true),
                    items: banners.map((banner) {
                      return Builder(
                        builder: (BuildContext context) {
                          return InkWell(
                            onTap: () {
                              String id = banner.id;
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => ProductList(

                                    title: banner.title,
                                    categoryValue: banner.categoriesvalueId, categories: [],

                                  ),
                                ),
                              );
                            },
                            child: Container(
                                color: Colors.white,
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 2.0),
                                child: Container(
                                  child: CachedNetworkImage(
                                    imageUrl:banner.imageName,
                                    fit: BoxFit.fill,
                                  ),
                                )),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 7.0),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: AutoSizeText(
                          'Top Deals & Special Grill Offers',
                          style: GoogleFonts.montserrat(
                            fontSize: 5.1.w,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: 100.w,
                        height: 26.h,
                        child: ListView.builder(
                            shrinkWrap: true,
                            // padding: EdgeInsets.symmetric(vertical:6),
                            scrollDirection: Axis.horizontal,
                            itemCount: productList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return listContainer(productList[index]);
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: AutoSizeText(
                          'Shop Popular Departments',
                          style: GoogleFonts.montserrat(
                            fontSize: 5.1.w,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(4),
                    //   margin: EdgeInsets.all(10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          GridView.count(
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              // semanticChildCount: 5,
                              childAspectRatio: 5 / 6,
                              scrollDirection: Axis.vertical,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 3,
                              shrinkWrap: true,
                              children: List.generate(_listLength + 1, (index) {
                                if (index > _listLength - 1) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (_isMore == true) {
                                        _isMore = false;
                                        _viewTitle = 'View More';
                                        _listLength = 5;
                                        print(_isMore);
                                        setState(() {});
                                      } else {
                                        _isMore = true;
                                        _viewTitle = 'View Less';
                                        _listLength =
                                            _listpupulardepartment.length;
                                        setState(() {});
                                        print(_isMore);
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      padding: EdgeInsets.all(1.w),
                                      height: 50.w,
                                      width: 48.w,
                                      // width: Adaptive.w(32),
                                      // height: Adaptive.w(40),
                                      child: Center(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
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
                                return listContainerpupularList(
                                    _listpupulardepartment[index]);
                              })),
                        ])),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Stack homeView(){
  //   return
  // }

  InkWell listContainer(topDeals list) {
    return InkWell(
      onTap: () {
        print('Categories:-${list.id}');
        ConstantsVar.prefs.setInt("subcategories", list.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return new ProductList(
                // customerId: ConstantsVar.customerID,
                title: list.name,
                categoryValue: ConstantsVar.prefs
                    .getInt("subcategories")
                    .toString(), categories: [], /*,subvalue:list.id*/
              );
            },
          ),
        );
      },
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          color: Colors.white,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.white,
                width: 41.w,
                padding: EdgeInsets.symmetric(
                  horizontal: 1.w,
                ),

                height: 36.w,
                // width: Adaptive.w(32),
                // height: Adaptive.w(40),
                child: Image.asset(
                  list.imageName,
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                width: 36.w,
                child: Center(
                  child: AutoSizeText(
                    list.name,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      wordSpacing: 1,
                      color: Colors.grey,
                      fontSize: 4.1.w,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell listContainerpupularList(popularDepartMent list) {
    return InkWell(
      onTap: () {
        print('Categoriespupularlist:-${list.id}');
        if (list.id != null) {
          ConstantsVar.prefs.setInt("subcategories", list.id);
        }
        ConstantsVar.prefs.setInt("subcategories", list.id);
        var categoriesvalueId =
            ConstantsVar.prefs.getInt("subcategories").toString();
        String valueee = ConstantsVar.prefs.getInt("subcategories").toString();
        print(valueee);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return new ProductList(
            // customerId: ConstantsVar.customerID,
            title: list.name, categoryValue: categoriesvalueId, categories: [],
          );
        }));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        // height: Adaptive.w(50),
        color: Colors.white,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,

          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Card(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(1.w),

                  // width: Adaptive.w(32),
                  // height: Adaptive.w(40),
                  child: Image.asset(
                    list.image,
                    fit: BoxFit.fill,
                    height: 50.w,
                  ),
                ),
              ),
            ),
            Container(
              child: Center(
                child: AutoSizeText(
                  list.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    wordSpacing: 4,
                    color: Colors.grey,
                    fontSize: 4.1.w,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget categroryLeftView(
      String name, String imageUrl, final categoryId /*, final type*/) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      // padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 100.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            /*InkWell(
              onTap: () {
                if (type == true) {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) =>
                              SubCatNew(catId: '$categoryId', title: name)));
                } else {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
                        return ProductList(
                          categoryId: '$categoryId',
                          title: name,
                        );
                      }));
                }
              },
              child: Container(
                  width: Adaptive.w(45),
                  height: Adaptive.w(45),
                  child:
                  CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.fill)),
            ),
            InkWell(
              onTap: () {
                if (type == true) {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) =>
                              SubCatNew(catId: '$categoryId', title: name)));
                } else {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
                        return ProductList(
                          categoryId: '$categoryId',
                          title: name,
                        );
                      }));
                }
              },
              child: Container(
                width: Adaptive.w(48),
                height: Adaptive.w(45),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Container(
                        width: Adaptive.w(48),
                        height: Adaptive.w(45),
                        color: Colors.black,
                        // height: 12.h,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.w, horizontal: 5.w),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              AutoSizeText(
                                name.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  width: 15.w,
                                  child:
                                  Divider(height: 2, color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: AutoSizeText('Shop Now',
                                    style: TextStyle(color: Colors.grey),
                                    textAlign: TextAlign.center),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          width: 5.w,
                          height: 5.w,
                          child: Image.asset('MyAssets/icon.png')),
                    )
                  ],
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  Widget categoryRightView(
      String name, String imageUrl, final categoryId /*, final type*/) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        width: 100.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  return ProductList(
                    categoryValue: null,
                    title: null, categories: [],
                  );
                }));
              },
              child: Container(
                width: Adaptive.w(48),
                height: Adaptive.w(45),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 11.0),
                      child: Container(
                        width: Adaptive.w(48),
                        height: Adaptive.w(45),
                        color: Colors.black,
                        // height: 12.h,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.w, horizontal: 8.w),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              AutoSizeText(
                                name.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  width: 15.w,
                                  child:
                                      Divider(height: 2, color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: AutoSizeText('Shop Now',
                                    style: TextStyle(color: Colors.grey),
                                    textAlign: TextAlign.center),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                          width: 10.w,
                          height: 10.w,
                          child: Image.asset(
                            'MyAssets/icon1.png',
                            fit: BoxFit.fill,
                          )),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) {
                      return ProductList(
                        // categoryId: '$',
                        title: name, categoryValue: categoryId, categories: [],
                      );
                    },
                  ),
                );
              },
              child: Container(
                  width: Adaptive.w(45),
                  height: Adaptive.w(45),
                  child:
                      CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.fill)),
            ),
          ],
        ),
      ),
    );
  }

  Future getApiToken() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    return ConstantsVar.prefs.get('apiTokken');
  }

  void navigate(Widget className) => Navigator.push(
      context, CupertinoPageRoute(builder: (context) => className));

  void getTopBrands() {
    banners.add(
      new TopBrands(
          imageName: 'https://www.bbqoutlets.com/pub/media/catalog/category/alfresco.png',
          id: '62',
          title: 'Alfresco',
          categoriesvalueId:
              ConstantsVar.prefs.getInt("subcategories").toString()),
    );
    banners.add(
      new TopBrands(
          imageName: 'https://www.bbqoutlets.com/pub/media/catalog/category/blaze.jpg',
          id: '7',
          title: 'Blaze',
          categoriesvalueId:
              ConstantsVar.prefs.getInt("subcategories").toString()),
    );
    banners.add(
      new TopBrands(
          imageName: 'https://www.bbqoutlets.com/pub/media/catalog/category/coyoto.png',
          id: '78',
          title: 'Coyote',
          categoriesvalueId:
              ConstantsVar.prefs.getInt("subcategories").toString()),
    );
    banners.add(
      new TopBrands(
          imageName: 'https://www.bbqoutlets.com/pub/media/catalog/category/delta-heat.png',
          id: '39',
          title: 'Delta Heat',
          categoriesvalueId:
              ConstantsVar.prefs.getInt("subcategories").toString()),
    );
    banners.add(
      new TopBrands(
          imageName: 'https://www.bbqoutlets.com/pub/media/catalog/category/twin-eagle_1.png',
          id: '41',
          title: 'Twin Eagle',
          categoriesvalueId:
              ConstantsVar.prefs.getInt("subcategories").toString()),
    );
    setState(() {});
  }

  void getTopDeals() {
    productList.add(
      new topDeals(
        id: 4,
        imageName: 'BBQ_Images/topDeals/free_standing_grills.png',
        name: 'Gas Grills',
      ),
    );
    productList.add(
      new topDeals(
        id: 82,
        imageName: 'BBQ_Images/topDeals/gas_grill.png',
        name: 'Pellet Grills',
      ),
    );
    productList.add(
      new topDeals(
        id: 85,
        imageName: 'BBQ_Images/topDeals/pallet_grills.png',
        name: 'Pizza Oven',
      ),
    );
    productList.add(
      new topDeals(
        id: 88,
        imageName: 'BBQ_Images/topDeals/pizza_oven.png',
        name: 'Free Standing Grills',
      ),
    );
    setState(() {});
  }

  void getPopularDepartMent() {
    _listpupulardepartment.add(
      //  ConstantsVar.prefs.setInt("accessory", 139);
      new popularDepartMent(
          image: 'BBQ_Images/populardepartment/accessories.png',
          name: 'Accessories',
          id: 139),
    );
    _listpupulardepartment.add(
      new popularDepartMent(
          image: 'BBQ_Images/populardepartment/door-and-drawers.png',
          name: 'Door & Drawers',
          id: 106),
    );
    _listpupulardepartment.add(
      new popularDepartMent(
          image: 'BBQ_Images/populardepartment/fire-logs.png',
          name: 'Fire Logs',
          id: 135),
    );
    _listpupulardepartment.add(new popularDepartMent(
        image: 'BBQ_Images/populardepartment/fire-pit-place.png',
        name: 'Fire Places',
        id: 126));
    _listpupulardepartment.add(
      new popularDepartMent(
          image: 'BBQ_Images/populardepartment/fire-pit-burners_1.png',
          name: 'Fire Pit Burners',
          id: 132),
    );
    _listpupulardepartment.add(
      new popularDepartMent(
          image: 'BBQ_Images/populardepartment/fire-place.png',
          name: 'Fire Place',
          id: 126),
    );

    _listpupulardepartment.add(
      new popularDepartMent(
          image: 'BBQ_Images/populardepartment/grill.png',
          name: 'Grills',
          id: 7),
    );
    _listpupulardepartment.add(
      new popularDepartMent(
          image: 'BBQ_Images/populardepartment/Heater-from-infratech1.png',
          name: 'Heaters',
          id: 138),
    );
    _listpupulardepartment.add(
      new popularDepartMent(
          image: 'BBQ_Images/populardepartment/island.png',
          name: 'Island',
          id: 137),
    );
    _listpupulardepartment.add(
      new popularDepartMent(
          image: 'BBQ_Images/populardepartment/patio-furniture.png',
          name: 'Patio Furniture',
          id: 78),
    );

    _listpupulardepartment.add(
      new popularDepartMent(
          image: 'BBQ_Images/populardepartment/Refrigerator-from-Hestan.png',
          name: 'Refrigerators',
          id: 133),
    );

    _listpupulardepartment.add(
      new popularDepartMent(
          image: 'BBQ_Images/populardepartment/side-burners.png',
          name: 'Side Burners',
          id: 105),
    );
    setState(() {});
  }
}
//Please wait for few seconds
