// import 'dart:async';
// import 'dart:convert';
//
// import 'package:BBQOUTLETS/AppPages/Categories/DiscountxxWidget.dart';
// import 'package:BBQOUTLETS/AppPages/Categories/ProductList/SubCatProducts.dart';
// import 'package:BBQOUTLETS/AppPages/StreamClass/NewPeoductPage/NewProductScreen.dart';
// import 'package:BBQOUTLETS/Constants/ConstantVariables.dart';
// import 'package:BBQOUTLETS/utils/ApiCalls/ApiCalls.dart';
// import 'package:BBQOUTLETS/utils/HeartIcon.dart';
// import 'package:BBQOUTLETS/utils/utils/build_config.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_sizer/flutter_sizer.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:menu_button/menu_button.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:ndialog/ndialog.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
//
// import 'SearchResponse/SearchResponse.dart';
//
// enum AniProps { color }
//
// class SearchPage extends StatefulWidget {
//   SearchPage({Key? key}) : super(key: key);
//
//   @override
//   _SearchPageState createState() => _SearchPageState();
// }
//
// class _SearchPageState extends State<SearchPage>
//     with SingleTickerProviderStateMixin {
//   String _selectedSeats = '', _selectedColors = '', _selectedFaimly = '';
//   String _selectedSeatsId = '',
//       _selectedColorsId = '',
//       _selectedFaimlyId = '',
//       _mainString = '';
//
//   final colorizeColors = [
//     Colors.white,
//     Colors.grey,
//     Colors.black,
//     ConstantsVar.appColor,
//   ];
//   final _suggestController = ScrollController();
//   late AnimationController _animationController;
//   final colorizeTextStyle =
//       TextStyle(fontSize: 6.w, fontWeight: FontWeight.bold);
//   var _range;
//   var color1 = ConstantsVar.appColor;
//   var color2 = Colors.black54;
//   late Animation<double> size;
//   bool isLoadVisible = false;
//   bool isListVisible = false, isFilterVisible = false;
//   TextEditingController _searchController = TextEditingController();
//
//   List<SpecificationAttributeFilter> mList = [];
//
//   List<Color> colorList = [
//     ConstantsVar.appColor,
//     Colors.black26,
//     Colors.white60
//   ];
//   List<Alignment> alignmentList = [
//     Alignment.bottomLeft,
//     Alignment.bottomRight,
//     Alignment.topRight,
//     Alignment.topLeft,
//   ];
//   int index = 0;
//   var totalCount;
//   Color topColor = ConstantsVar.appColor;
//   Color bottomColor = Colors.black26;
//   Alignment begin = Alignment.bottomLeft;
//   Alignment end = Alignment.topRight;
//   Color btnColor = Colors.black;
//   int pageIndex = 0;
//   var guestCustomerId;
//   late bool noMore;
//   bool isVisible = false;
//   RefreshController _refreshController = RefreshController();
//
//   var _focusNode = FocusNode();
//
//   String _catId = '';
//
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//
//   double _maxPrice = 25000, _minPrice = 0, _minPRICE = 0, _maxPRICE = 0;
//
//   double _width = 0;
//   double _height = 0;
//   List<Specificationoption> _colorList = [];
//   List<Specificationoption> _numberOfSeatList = [];
//   List<Specificationoption> _familyList = [];
//
//   var _isChecked = false;
//
//   final _scrollController = ScrollController();
//   ScrollController _scrollListController = ScrollController();
//
//   var _myController = ScrollController();
//
//   _scrollListener() {
//     if (searchedProducts.length == 0) {
//       _myController.animateTo(_myController.offset + 120,
//           curve: Curves.linear, duration: Duration(milliseconds: 500));
//     }
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _scrollListController.addListener(() {
//       if (_scrollListController.position.pixels ==
//           _scrollListController.position.maxScrollExtent) {
//         print('Hi There I Am Triggered');
//         if (searchedProducts.length <= totalCount) {
//           _onLoading();
//         } else {
//           Fluttertoast.showToast(msg: 'No more product available');
//         }
//       }
//     });
//     scrollControllerFunct();
//     _animationController =
//         AnimationController(duration: Duration(seconds: 2), vsync: this);
//     _maxPRICE = _maxPrice.toStringAsFixed(0).toDouble();
//     noMore = false;
//     guestCustomerId = ConstantsVar.prefs.getString('guestCustomerID');
//   }
//
//   @override
//   void dispose() {
//     _myController.dispose();
//     _animationController.dispose();
//     _refreshController.dispose();
//     // TODO: implement dispose
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     FocusScopeNode currentFocus = FocusScope.of(context);
//     FocusNode _foucsNode = FocusNode();
//     Animation<Offset> _animation = Tween<Offset>(
//       begin: Offset(1, -1),
//       end: Offset(0, 0),
//     ).animate(_animationController)
//       ..addListener(() => setState(() => null));
//     _animationController.forward();
//     return GestureDetector(
//       onTap: () {
//         if (!currentFocus.hasPrimaryFocus) {
//           currentFocus.unfocus();
//         }
//       },
//       child: SafeArea(
//         top: true,
//         bottom: true,
//         child: Scaffold(
//           key: _scaffoldKey,
//           resizeToAvoidBottomInset: false,
//           body: Container(
//             decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                     begin: begin, end: end, colors: [bottomColor, topColor])),
//             height: MediaQuery.of(context).size.height,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 4.0),
//                   child: Container(
//                     width: 100.w,
//                     child: Stack(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: Card(
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10.0)),
//                                 elevation: 8.0,
//                                 child: RawAutocomplete<String>(
//                                   optionsBuilder:
//                                       (TextEditingValue textEditingValue) {
//                                     if (textEditingValue.text == null ||
//                                         textEditingValue.text == '') {
//                                       return const Iterable<String>.empty();
//                                     }
//                                     return ConstantsVar.suggestionList
//                                         .where((String option) {
//                                       return option.toLowerCase().contains(
//                                           textEditingValue.text.toLowerCase());
//                                     });
//                                   },
//                                   onSelected: (String selection) {
//                                     debugPrint('$selection selected');
//                                   },
//                                   fieldViewBuilder: (BuildContext context,
//                                       TextEditingController
//                                           textEditingController,
//                                       FocusNode focusNode,
//                                       VoidCallback onFieldSubmitted) {
//                                     _searchController = textEditingController;
//                                     _focusNode = focusNode;
//                                     return TextFormField(
//                                       autocorrect: true,
//                                       enableSuggestions: true,
//                                       onFieldSubmitted: (val) {
//                                         focusNode.unfocus();
//                                         if (!currentFocus.hasPrimaryFocus) {
//                                           currentFocus.unfocus();
//                                         }
//                                         setState(() {
//                                           _selectedColorsId = '';
//                                           _selectedSeatsId = '';
//                                           _selectedFaimlyId = '';
//                                           _colorList = [];
//                                           _numberOfSeatList = [];
//                                           _familyList = [];
//                                           _height = 0.h;
//                                           isVisible = false;
//                                           noMore = false;
//                                           _catId = '';
//                                           _minPrice = 0;
//                                           pageIndex = 0;
//                                           _maxPrice = 25000;
//
//                                           _range = RangeValues(
//                                               _minPrice.toDouble(),
//                                               _maxPrice.toDouble());
//                                         });
//                                         searchProducts(
//                                                 val,
//                                                 0,
//                                                 _minPRICE.toStringAsFixed(2),
//                                                 _maxPRICE.toStringAsFixed(2))
//                                             .then((value) => print(value));
//
//                                         print('Pressed via keypad');
//                                       },
//                                       textInputAction: isVisible
//                                           ? TextInputAction.done
//                                           : TextInputAction.search,
//                                       // keyboardType: TextInputType.,
//                                       keyboardAppearance: Brightness.light,
//                                       // autofocus: true,
//                                       onChanged: (_) => setState(() {
//                                         btnColor = ConstantsVar.appColor;
//                                       }),
//                                       controller: _searchController,
//                                       style: TextStyle(
//                                           color: Colors.black, fontSize: 5.w),
//                                       decoration: InputDecoration(
//                                         border: InputBorder.none,
//                                         contentPadding: EdgeInsets.symmetric(
//                                             vertical: 13, horizontal: 10),
//                                         hintText: 'Search here',
//                                         labelStyle: TextStyle(
//                                             fontSize: 7.w, color: Colors.grey),
//                                         suffixIcon: InkWell(
//                                           onTap: () async {
//                                             focusNode.unfocus();
//
//                                             if (!currentFocus.hasPrimaryFocus) {
//                                               currentFocus.unfocus();
//                                             }
//                                             setState(() {
//                                               if (isFilterVisible == true) {
//                                                 isFilterVisible = false;
//                                               }
//                                               _selectedColorsId = '';
//                                               _selectedSeatsId = '';
//                                               _selectedFaimlyId = '';
//                                               _colorList = [];
//                                               _numberOfSeatList = [];
//                                               _familyList = [];
//                                               _height = 0.h;
//                                               noMore = false;
//                                               _catId = '';
//                                               _minPrice = 0;
//                                               _maxPrice = 25000;
//                                               _range = RangeValues(
//                                                   _minPrice.toDouble(),
//                                                   _maxPrice.toDouble());
//                                             });
//                                             searchProducts(
//                                                     _searchController.text
//                                                         .toString(),
//                                                     0,
//                                                     '',
//                                                     '')
//                                                 .then((value) => null);
//                                           },
//                                           child: Icon(Icons.search_sharp),
//                                         ),
//                                       ),
//                                       focusNode: _focusNode,
//                                     );
//                                   },
//                                   optionsViewBuilder: (BuildContext context,
//                                       AutocompleteOnSelected<String> onSelected,
//                                       Iterable<String> options) {
//                                     return Padding(
//                                       padding: const EdgeInsets.only(
//                                         top: 8.0,
//                                         right: 10,
//                                       ),
//                                       child: Align(
//                                         alignment: Alignment.topCenter,
//                                         child: Material(
//                                           child: Card(
//                                             child: Container(
//                                               height: 178,
//                                               child: Scrollbar(
//                                                 controller: _suggestController,
//                                                 thickness: 5,
//                                                 isAlwaysShown: true,
//                                                 child: ListView.builder(
//                                                   // padding: EdgeInsets.all(8.0),
//                                                   itemCount: options.length + 1,
//                                                   itemBuilder:
//                                                       (BuildContext context,
//                                                           int index) {
//                                                     if (index >=
//                                                         options.length) {
//                                                       return Align(
//                                                         alignment: Alignment
//                                                             .bottomCenter,
//                                                         child: TextButton(
//                                                           child: const Text(
//                                                             'Clear',
//                                                             style: TextStyle(
//                                                               color: Colors
//                                                                   .orangeAccent,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold,
//                                                               fontSize: 16,
//                                                             ),
//                                                           ),
//                                                           onPressed: () {
//                                                             _searchController
//                                                                 .clear();
//                                                           },
//                                                         ),
//                                                       );
//                                                     }
//                                                     final String option =
//                                                         options
//                                                             .elementAt(index);
//                                                     return GestureDetector(
//                                                         onTap: () {
//                                                           onSelected(option);
//                                                         },
//                                                         child: Container(
//                                                           height: 5.2.h,
//                                                           width: 95.w,
//                                                           child: Column(
//                                                             mainAxisSize:
//                                                                 MainAxisSize
//                                                                     .min,
//                                                             crossAxisAlignment:
//                                                                 CrossAxisAlignment
//                                                                     .start,
//                                                             children: [
//                                                               Container(
//                                                                 width: 100.w,
//                                                                 child:
//                                                                     AutoSizeText(
//                                                                   '  ' + option,
//                                                                   style:
//                                                                       TextStyle(
//                                                                     fontSize:
//                                                                         16,
//                                                                     wordSpacing:
//                                                                         2,
//                                                                     letterSpacing:
//                                                                         1,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .bold,
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                               Container(
//                                                                 width: 100.w,
//                                                                 child: Divider(
//                                                                   thickness: 1,
//                                                                   color: Colors
//                                                                       .grey
//                                                                       .shade400,
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         )
//
//                                                         // ListTile(
//                                                         //   title: Text(option),
//                                                         //   subtitle: Container(
//                                                         //     width: 100.w,
//                                                         //     child: Divider(
//                                                         //       thickness: 1,
//                                                         //       color:
//                                                         //           ConstantsVar.appColor,
//                                                         //     ),
//                                                         //   ),
//                                                         // ),
//                                                         );
//                                                   },
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ),
//                             Visibility(
//                               visible: isFilterVisible,
//                               child: InkWell(
//                                 radius: 36,
//                                 splashColor: Colors.red,
//                                 hoverColor: Colors.red,
//                                 highlightColor: Colors.red,
//                                 onTap: () => _toggle(),
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 8.0, vertical: 8),
//                                   child: Icon(
//                                     HeartIcon.searchFilter,
//                                     color: Colors.white,
//                                     size: 42,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Align(
//                           alignment: Alignment.bottomCenter,
//                           child: Padding(
//                             padding: EdgeInsets.only(top: 60.0),
//                             child: showSearchFilter(_animation),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Visibility(
//                     visible: isListVisible,
//                     child: Container(
//                       // height:82.5.h,
//                       child: Scrollbar(
//                         isAlwaysShown: true,
//                         controller: _scrollController,
//                         thickness: 10,
//                         child: GridView.count(
//                           controller: _scrollListController,
//                           // physics: AlwaysScrollableScrollPhysics(),
//                           crossAxisCount: 2,
//                           crossAxisSpacing: 5,
//                           childAspectRatio: 3 / 6,
//                           mainAxisSpacing: 5,
//                           children: List.generate(
//                             searchedProducts.length,
//                             (index) {
//                               // var name = searchedProducts[index].stockQuantity.contains('In stock');
//                               return InkWell(
//                                 onTap: () {
//                                   print(searchedProducts[index].id.toString());
//
//                                   //
//                                   SchedulerBinding.instance!
//                                       .addPostFrameCallback((timeStamp) {
//                                     Navigator.push(
//                                       context,
//                                       CupertinoPageRoute(
//                                         builder: (context) {
//                                           return NewProductDetails(
//                                             productId: searchedProducts[index]
//                                                 .id
//                                                 .toString(),
//                                             screenName: 'Product List',
//                                             // customerId: ConstantsVar.customerID,
//                                           );
//                                         },
//                                       ),
//                                     );
//                                   });
//                                 },
//                                 child: Stack(
//                                   children: [
//                                     Card(
//                                       // elevation: 2,
//                                       child: Container(
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           children: [
//                                             Container(
//                                               color: Colors.white,
//                                               padding: EdgeInsets.all(4.0),
//                                               child: CachedNetworkImage(
//                                                 imageUrl:
//                                                     searchedProducts[index]
//                                                         .productPicture,
//                                                 fit: BoxFit.cover,
//                                                 placeholder:
//                                                     (context, reason) =>
//                                                         new SpinKitRipple(
//                                                   color: Colors.red,
//                                                   size: 90,
//                                                 ),
//                                               ),
//                                             ),
//                                             Container(
//                                               padding: EdgeInsets.symmetric(
//                                                   vertical: 8.0,
//                                                   horizontal: 8.0),
//                                               width: MediaQuery.of(context)
//                                                   .size
//                                                   .width,
//                                               // color: Color(0xFFe0e1e0),
//                                               child: Column(
//                                                 mainAxisSize: MainAxisSize.max,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   // sorry mam nahi hua!
//                                                   AutoSizeText(
//                                                     searchedProducts[index]
//                                                         .name,
//                                                     maxLines: 2,
//                                                     style: TextStyle(
//                                                         height: 1,
//                                                         color: Colors.black,
//                                                         fontSize: 5.w,
//                                                         fontWeight:
//                                                             FontWeight.bold),
//                                                     textAlign: TextAlign.start,
//                                                   ),
//                                                   Padding(
//                                                     padding: const EdgeInsets
//                                                             .symmetric(
//                                                         vertical: 6.0),
//                                                     child: Column(
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .start,
//                                                       children: [
//                                                         Padding(
//                                                           padding:
//                                                               EdgeInsets.only(
//                                                             top: 2.w,
//                                                             left: 2,
//                                                           ),
//                                                           child: discountWidget(
//                                                             actualPrice:
//                                                                 searchedProducts[
//                                                                         index]
//                                                                     .price,
//                                                             fontSize: 2.4.w,
//                                                             width: 25.w,
//                                                             isSpace: searchedProducts[
//                                                                             index]
//                                                                         .discountedPrice ==
//                                                                     null
//                                                                 ? true
//                                                                 : false,
//                                                           ),
//                                                         ),
//                                                         AutoSizeText(
//                                                           searchedProducts[
//                                                                           index]
//                                                                       .discountedPrice ==
//                                                                   null
//                                                               ? searchedProducts[
//                                                                       index]
//                                                                   .price
//                                                               : searchedProducts[
//                                                                       index]
//                                                                   .discountedPrice,
//                                                           maxLines: 1,
//                                                           style: TextStyle(
//                                                               height: 1,
//                                                               color: Colors.grey
//                                                                   .shade600,
//                                                               fontSize: 4.w,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold),
//                                                           textAlign:
//                                                               TextAlign.start,
//                                                         ),
//                                                         Padding(
//                                                           padding:
//                                                               EdgeInsets.only(
//                                                             top: 4,
//                                                             bottom: 2,
//                                                           ),
//                                                           child: AutoSizeText(
//                                                             searchedProducts[
//                                                                     index]
//                                                                 .stockQuantity,
//                                                             maxLines: 1,
//                                                             style: TextStyle(
//                                                                 height: 1,
//                                                                 color: searchedProducts[
//                                                                             index]
//                                                                         .stockQuantity
//                                                                         .contains(
//                                                                             'In stock')
//                                                                     ? Colors
//                                                                         .green
//                                                                     : Colors
//                                                                         .red,
//                                                                 fontSize: 20.dp,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold),
//                                                             textAlign:
//                                                                 TextAlign.start,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             AddCartBtn(
//                                               productId:
//                                                   searchedProducts[index].id,
//                                               // width: 2.w,
//                                               isTrue: true,
//                                               guestCustomerId: guestCustomerId,
//                                               checkIcon: searchedProducts[index]
//                                                       .stockQuantity
//                                                       .contains('Out of stock')
//                                                   ? Icon(HeartIcon.cross)
//                                                   : Icon(Icons.check),
//                                               text: searchedProducts[index]
//                                                       .stockQuantity
//                                                       .contains('Out of stock')
//                                                   ? 'Out of Stock'.toUpperCase()
//                                                   : 'ADD TO CArt'.toUpperCase(),
//                                               color: searchedProducts[index]
//                                                       .stockQuantity
//                                                       .contains('Out of stock')
//                                                   ? Colors.grey
//                                                   : ConstantsVar.appColor,
//                                               // fontSize: 12,
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       top: 3,
//                                       left: 3,
//                                       child: Visibility(
//                                         visible: searchedProducts[index]
//                                                     .discountPercent
//                                                     .length !=
//                                                 0
//                                             ? true
//                                             : false,
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(4.0),
//                                           child: Container(
//                                             width: 10.w,
//                                             height: 10.w,
//                                             child: Stack(
//                                               children: [
//                                                 Image.asset(
//                                                   'MyAssets/plaincircle.png',
//                                                   width: 10.w,
//                                                   height: 10.w,
//                                                 ),
//                                                 Align(
//                                                   alignment: Alignment.center,
//                                                   child: Text(
//                                                     searchedProducts[index]
//                                                         .discountPercent,
//                                                     style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.w800,
//                                                       fontSize: 3.w,
//                                                       color: Colors.white,
//                                                     ),
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Visibility(
//                   visible: noMore,
//                   child: Center(
//                     child: AnimatedTextKit(
//                       repeatForever: true,
//                       animatedTexts: [
//                         ColorizeAnimatedText(
//                           'No Product Found',
//                           textStyle: colorizeTextStyle,
//                           colors: colorizeColors,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   InputDecoration editBoxDecoration(Icon icon) {
//     return new InputDecoration(
//       contentPadding: EdgeInsets.symmetric(horizontal: 10),
//       hintText: 'Search here',
//       labelStyle: TextStyle(fontSize: 7.w, color: Colors.grey),
//       border: InputBorder.none,
//     );
//   }
//
//   List<GetProductsByCategoryIdClass> searchedProducts = [];
//
//   Future searchProducts(String productName, int pageNumber, String minPrice,
//       String maxPrice) async {
//     _refreshController.refreshToIdle();
//     CustomProgressDialog progressDialog =
//         CustomProgressDialog(context, blur: 2, dismissable: false);
//     progressDialog.setLoadingWidget(SpinKitRipple(
//       color: Colors.red,
//       size: 90,
//     ));
//     progressDialog.show();
//
//     setState(() {
//       noMore = false;
//       searchedProducts.clear();
//       isLoadVisible = true;
//       isListVisible = false;
//       _mainString = _selectedSeatsId + _selectedColorsId + _selectedFaimlyId;
//     });
//     final uri = Uri.parse(BuildConfig.base_url +
//         'apis/GetSearch?keyword=$productName&pagesize=8&pageindex=$pageNumber&minPrice=$_minPRICE&maxPrice=$_maxPRICE&specId=$_mainString');
//
//     print(uri);
//     try {
//       var response = await http.get(uri, headers: ApiCalls.header);
//       var jsonMap = jsonDecode(response.body);
//       print(jsonMap);
//       if (mounted) if (jsonMap['ResponseData'] == null) {
//         Fluttertoast.showToast(msg: 'No Product found');
//         progressDialog.dismiss();
//         if (mounted)
//           setState(() {
//             isLoadVisible = false;
//             isFilterVisible = true;
//             noMore = true;
//           });
//       } else {
//         SearchResponse mySearchResponse = SearchResponse.fromJson(jsonMap);
//         progressDialog.dismiss();
//
//         if (mySearchResponse.responseData.getProductsByCategoryIdClasses ==
//             null) {
//           setState(() {
//             noMore = true;
//             isListVisible = false;
//             isFilterVisible = true;
//             isLoadVisible = false;
//             progressDialog.dismiss();
//           });
//         } else {
//           if (mounted)
//             setState(() {
//               isLoadVisible = false;
//               isFilterVisible = true;
//               progressDialog.dismiss();
//               searchedProducts.addAll(
//                   mySearchResponse.responseData.getProductsByCategoryIdClasses);
//               mList =
//                   mySearchResponse.responseData.specificationAttributeFilters;
//
//               if (mList.length == 0) {
//               } else {
//                 for (int i = 0; i <= mList.length - 1; i++) {
//                   if (mList[i].name.contains('Number of Seats')) {
//                     _numberOfSeatList.clear();
//                     _numberOfSeatList = mList[i].specificationoptions;
//                   }
//                   if (mList[i].name.contains('Family')) {
//                     _familyList.clear();
//                     _familyList = mList[i].specificationoptions;
//                   }
//                   if (mList[i].name.contains('Colour')) {
//                     _colorList.clear();
//
//                     _colorList = mList[i].specificationoptions;
//                   }
//                 }
//               }
//
//               isListVisible = true;
//               totalCount = mySearchResponse.responseData.totalCount;
//             });
//
//           if (totalCount == 0) {
//             setState(() {
//               isListVisible = true;
//               //
//               progressDialog.dismiss();
//               Fluttertoast.showToast(msg: 'No Products found');
//             });
//           } else if (searchedProducts.length ==
//               mySearchResponse.responseData.totalCount) {
//             setState(() {
//               isLoadVisible = false;
//               progressDialog.dismiss();
//             });
//           }
//           return searchedProducts;
//         }
//       }
//     } on Exception catch (e) {
//       ConstantsVar.excecptionMessage(e);
//       progressDialog.dismiss();
//     }
//     progressDialog.dismiss();
//   }
//
//   void _onLoading() async {
//     Fluttertoast.showToast(msg: 'Loading please wait');
//     var prodName;
//     setState(() {
//       prodName = _searchController.text.toString();
//       pageIndex = pageIndex + 1;
//       print(pageIndex);
//     });
//     final uri = Uri.parse(BuildConfig.base_url +
//         'apis/GetSearch?keyword=$prodName&pagesize=8&pageindex=$pageIndex&minPrice=${_minPRICE.toStringAsFixed(2)}&maxPrice=${_maxPRICE.toStringAsFixed(2)}&specId = $_mainString');
//     print(uri);
//     try {
//       var response = await http.get(uri, headers: ApiCalls.header);
//       var result = jsonDecode(response.body);
//       print(result);
//       SearchResponse mySearchResponse = SearchResponse.fromJson(result);
//
//       setState(() {
//         searchedProducts.addAll(
//             mySearchResponse.responseData.getProductsByCategoryIdClasses);
//         _refreshController.loadComplete();
//       });
//
//       if (searchedProducts.length == totalCount) {
//         setState(() {
//           _refreshController.loadComplete();
//         });
//       }
//     } on Exception catch (e) {
//       ConstantsVar.excecptionMessage(e);
//       _refreshController.loadFailed();
//     }
//   }
//
//   Widget showSearchFilter(Animation<Offset> _animation) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       elevation: 10.0,
//       child: AnimatedContainer(
//         curve: Curves.fastOutSlowIn,
//         duration: Duration(seconds: 2),
//         // color: Colors.white,
//         height: _height,
//         width: _width,
//         child: PageView.builder(
//           physics: NeverScrollableScrollPhysics(),
//           itemBuilder: (context, index) => ListView(
//             physics: NeverScrollableScrollPhysics(),
//             padding: EdgeInsets.all(4),
//             children: [
//               Visibility(
//                 visible: _numberOfSeatList.isEmpty ? false : true,
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(vertical: 4),
//                   child: Row(children: [
//                     Container(
//                       width: 25.w,
//                       child: AutoSizeText(
//                         'No. of seats: ',
//                         maxLines: 2,
//                         style: TextStyle(
//                           fontWeight: FontWeight.w700,
//                           fontSize: 3.5.w,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: MenuButton<Specificationoption>(
//                         scrollPhysics: AlwaysScrollableScrollPhysics(),
//                         itemBuilder: (value) {
//                           return Container(
//                             height: 30,
//                             alignment: Alignment.centerLeft,
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 0.0, horizontal: 16),
//                             child: Text(value.name),
//                           );
//                         },
//                         topDivider: true,
//                         items: _numberOfSeatList,
//                         toggledChild: Container(
//                             child: Container(
//                                 height: 2.w, child: Text(_selectedSeats))),
//                         showSelectedItemOnList: true,
//                         onItemSelected: (value)
//                             // wait mam
//                             {
//                           setState(() {
//                             _isChecked = true;
//                             _selectedSeats = value.name;
//
//                             _selectedSeatsId = '';
//                             _selectedSeatsId = value.id + ',';
//                           });
//                         },
//                         child: normalChildButton(_selectedSeats),
//                         // selectedItem: _selectedSeats,
//                         // label: Text(_selectedKey,style: TextStyle(fontSize: 18),),
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         setState(() {
//                           _selectedSeats = '';
//
//                           _selectedSeatsId = '';
//                         });
//                       },
//                       icon: Icon(Icons.remove),
//                     ),
//                   ]),
//                 ),
//               ),
//               Visibility(
//                 visible: _colorList.isEmpty ? false : true,
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(vertical: 4),
//                   child: Row(children: [
//                     Container(
//                       width: 25.w,
//                       child: AutoSizeText(
//                         'Color: ',
//                         maxLines: 2,
//                         style: TextStyle(
//                           fontWeight: FontWeight.w700,
//                           fontSize: 3.5.w,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: MenuButton<Specificationoption>(
//                         scrollPhysics: AlwaysScrollableScrollPhysics(),
//                         itemBuilder: (value) {
//                           return Container(
//                             height: 30,
//                             alignment: Alignment.centerLeft,
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 0.0, horizontal: 16),
//                             child: Text(value.name),
//                           );
//                         },
//                         topDivider: true,
//                         items: _colorList,
//                         toggledChild: Text(_selectedColors),
//                         showSelectedItemOnList: true,
//                         onItemSelected: (value)
//                             // wait mam
//                             {
//                           setState(() {
//                             _selectedColorsId = '';
//
//                             _selectedColorsId = value.id + ',';
//
//                             _selectedColors = value.name;
//                           });
//                         },
//                         child: normalChildButton(_selectedColors),
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         setState(() {
//                           _selectedColors = '';
//
//                           _selectedColorsId = '';
//                         });
//                       },
//                       icon: Icon(Icons.remove),
//                     ),
//                   ]),
//                 ),
//               ),
//               Visibility(
//                 visible: _familyList.isEmpty ? false : true,
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(vertical: 4),
//                   child: Row(children: [
//                     Container(
//                       width: 25.w,
//                       child: AutoSizeText(
//                         'Family: ',
//                         maxLines: 2,
//                         style: TextStyle(
//                           fontWeight: FontWeight.w700,
//                           fontSize: 3.5.w,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: MenuButton<Specificationoption>(
//                         scrollPhysics: AlwaysScrollableScrollPhysics(),
//                         itemBuilder: (value) {
//                           return Container(
//                             height: 30,
//                             alignment: Alignment.centerLeft,
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 0.0, horizontal: 16),
//                             child: Text(value.name),
//                           );
//                         },
//                         topDivider: true,
//                         items: _familyList,
//                         toggledChild: Text(_selectedFaimly),
//                         showSelectedItemOnList: true,
//                         onItemSelected: (value)
//                             // wait mam
//                             {
//                           setState(() {
//                             _selectedFaimly = value.name;
//                             _selectedFaimlyId = '';
//                             _selectedFaimlyId = value.id + ',';
//                           });
//                         },
//                         child: normalChildButton(_selectedFaimly),
//                         // selectedItem: _selectedFaimly,
//                         // label: Text(_selectedKey,style: TextStyle(fontSize: 18),),
//                       ),
//                     ),
//                     IconButton(
//                       splashColor: Colors.red,
//                       onPressed: () {
//                         setState(() {
//                           _selectedFaimly = '';
//
//                           _selectedFaimlyId = '';
//                         });
//                       },
//                       icon: Icon(Icons.remove),
//                     ),
//                   ]),
//                 ),
//               ),
//               SizedBox(
//                 height: 6,
//               ),
//               AutoSizeText(
//                 'Price Range: ',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w700,
//                   fontSize: 3.5.w,
//                 ),
//               ),
//               Container(
//                 width: 100.w,
//                 child: SliderTheme(
//                   data: SliderThemeData(
//                     thumbColor: ConstantsVar.appColor,
//                     overlayColor: ConstantsVar.appColor,
//                     overlayShape: RoundSliderOverlayShape(
//                       overlayRadius: 16,
//                     ),
//                     trackHeight: 2,
//                     thumbShape: RoundSliderThumbShape(
//                       enabledThumbRadius: 3.0,
//                       disabledThumbRadius: 3.0,
//                     ),
//                   ),
//                   child: RangeSlider(
//                     activeColor: Colors.red,
//                     inactiveColor: Colors.black,
//                     min: 0,
//                     max: 25000,
//                     values: _range,
//                     onChanged: (value) {
//                       print('$value');
//                       setState(() {
//                         _range = value;
//                         _minPRICE = double.parse(_range.start.toString())
//                             .toStringAsFixed(2)
//                             .toDouble();
//                         _maxPRICE = double.parse(_range.end.toString())
//                             .toStringAsFixed(2)
//                             .toDouble();
//                       });
//                     },
//                   ),
//                 ),
//               ),
//               Container(
//                 width: 100.w,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('Min Price: $_minPRICE'),
//                     Text('Max Price: $_maxPRICE'),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 6,
//               ),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: AppButton(
//                   textStyle: TextStyle(color: Colors.white),
//                   height: 4.w,
//                   text: 'Apply Filters',
//                   color: ConstantsVar.appColor,
//                   splashColor: Colors.white,
//                   onTap: () async {
//                     // _minPrice = _minPriceController.text;
//                     // _maxPrice = _maxPriceController.text;
//
//                     setState(() {
//                       noMore = false;
//                       _height = 0;
//                     });
//
//                     Future.delayed(
//                         Duration(
//                           seconds: 1,
//                         ),
//                         () => setState(() => isVisible = false));
//
//                     await searchProducts(
//                             _searchController.text.toString(),
//                             0,
//                             _minPrice.toStringAsFixed(2),
//                             _maxPRICE.toStringAsFixed(2))
//                         .then((value) => print(value));
//                   },
//                   width: 100.w,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _toggle() {
//     if (mounted)
//       setState(() {
//         if (isVisible == true) {
//           isVisible = false;
//           _width = 0.w;
//           _height = 0.h;
//         } else {
//           isVisible = true;
//           _width = 100.w;
//           mList.length == 0
//               ? setState(() => _height = 25.h)
//               : setState(() => _height = 81.w);
//         }
//       });
//     _focusNode.unfocus();
//   }
//
//   _selectData(Specificationoption value, String _selectedKey) {
//     setState(() {
//       _selectedSeats = value.name;
//       _selectedKey = value.name;
//       Fluttertoast.showToast(msg: _selectedKey);
//     });
//   }
//
//   Widget normalChildButton(String _name) => SizedBox(
//         width: 93,
//         height: 30,
//         child: Padding(
//           padding: const EdgeInsets.only(left: 16, right: 11),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Flexible(
//                   child: Text(_name == null ? '' : _name,
//                       overflow: TextOverflow.ellipsis)),
//               const SizedBox(
//                 width: 12,
//                 height: 17,
//                 child: FittedBox(
//                   fit: BoxFit.fill,
//                   child: Icon(
//                     Icons.arrow_drop_down,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//
//   void scrollControllerFunct() async {
//     if (_suggestController.hasClients) {
//       await _suggestController.animateTo(
//         0.0,
//         curve: Curves.easeOut,
//         duration: const Duration(milliseconds: 300),
//       );
//     }
//   }
//
//   @override
//   void setState(VoidCallback fn) {
//     if (mounted) {
//       super.setState(fn);
//     }
//   }
// }
