import 'dart:convert';

import 'package:BBQOUTLETS/AppPages/HomeCategory/HomeCategory.dart';
import 'package:advanced_search/advanced_search.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:progress_loading_button/progress_loading_button.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../AppPages/CartxxScreen/CartScreen2.dart';
import '../../AppPages/LoginScreen/LoginScreen.dart';
import '../../AppPages/MagentoAdminApis/CustomerApis.dart';
import '../../AppPages/StreamClass/NewPeoductPage/NewProductScreen.dart';
import '../../Constants/ConstantVariables.dart';
import '../../utils/utils/build_config.dart';
import '../search_model/search_model.dart';

class NewSearchPage extends StatefulWidget {
  const NewSearchPage({Key? key}) : super(key: key);

  @override
  _NewSearchPageState createState() => _NewSearchPageState();
}

class _NewSearchPageState extends State<NewSearchPage> {
  var guestCustomerId;

  bool isLoadVisible = false;

  var totalCount;

  String _searchText = 'Search Here...';
  List<Item> items = [];

  var _isLoading = false;
  var _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<String> searchableList = [
    'Burners',
    'Oven',
    'Grills',
    'Delta',
  ];

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 10.0, right: 10.0, top: _height * .18),
                child: SizedBox(
                    width: _width,
                    child: _isLoading == true
                        ? Center(child: CircularProgressIndicator())
                        : items.isEmpty
                            ? Center(
                                child: DefaultTextStyle(
                                  style: const TextStyle(
                                    fontSize: 40.0,
                                    fontFamily: 'Horizon',
                                  ),
                                  child: AnimatedTextKit(
                                    animatedTexts: [
                                      RotateAnimatedText(
                                        'Burners',
                                        textStyle: GoogleFonts.poppins(
                                          color: ConstantsVar.appColor,
                                        ),
                                      ),
                                      RotateAnimatedText(
                                        'Ovens',
                                        textStyle: GoogleFonts.poppins(
                                          color: ConstantsVar.appColor,
                                        ),
                                      ),
                                      RotateAnimatedText(
                                        'Grills',
                                        textStyle: GoogleFonts.poppins(
                                          color: ConstantsVar.appColor,
                                        ),
                                      ),
                                      RotateAnimatedText(
                                        'and many more.',
                                        textStyle: GoogleFonts.poppins(
                                          color: ConstantsVar.appColor,
                                        ),
                                      ),
                                      RotateAnimatedText(
                                        'Find your favorite.',
                                        textStyle: GoogleFonts.poppins(
                                          color: ConstantsVar.appColor,
                                        ),
                                      ),
                                    ],
                                    onTap: () {
                                      print("Tap Event");
                                    },
                                  ),
                                ),
                              )
                            : Container(
                                height: _height,
                                child: GridView.count(
                                  shrinkWrap: true,
                                  // physics: NeverScrollableScrollPhysics(),
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 5,
                                  childAspectRatio: 3 / 6,
                                  mainAxisSpacing: 5,
                                  children: List.generate(
                                    items.length,
                                    (index) {
                                      print(items.length);
                                      // var name = searchedProducts[index].stockQuantity.contains('In stock');
                                      return GestureDetector(
                                        onTap: () async => await Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                NewProductDetails(
                                              productId:
                                                  items[index].id.toString(),
                                              screenName: 'Home Screen',
                                            ),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Container(
                                            width: _width * .46,
                                            // height: Adaptive.w(50),
                                            color: Colors.white,

                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.max,

                                              // mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Card(
                                                  child: FadeImageEffect(
                                                    imageList: items[index]
                                                        .extensionAttributes
                                                        .productImages,
                                                    width: _width * .44,
                                                    height: _width * .44,
                                                    type: 'network',
                                                  ),
                                                ),
                                                RatingBarWidget(
                                                  rating: 5,
                                                  disable: true,
                                                  onRatingChanged: (val) =>
                                                      null,
                                                  activeColor:
                                                      ConstantsVar.appColor,
                                                  size: 25,
                                                ),
                                                Container(
                                                  width: _width * .46,
                                                  child: AutoSizeText(
                                                    items[index].name,
                                                    textAlign: TextAlign.start,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: _width * 0.043,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                RichText(
                                                  text: new TextSpan(
                                                    text:
                                                        '\$${items[index].price.toString()} ',
                                                    style: TextStyle(
                                                      wordSpacing: 2,
                                                      color: Colors.black,
                                                      fontSize: _width * 0.028,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    children: <TextSpan>[
                                                      new TextSpan(
                                                        text:
                                                            '\+ FREE Shipping',
                                                        style: TextStyle(
                                                          wordSpacing: 2,
                                                          color: Color.fromRGBO(
                                                              228, 122, 39, 1),
                                                          fontSize:
                                                              _width * 0.028,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: new TextSpan(
                                                    text: 'Regular Price',
                                                    style: TextStyle(
                                                      wordSpacing: 2,
                                                      color: Colors.black,
                                                      fontSize: _width * 0.028,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    children: <TextSpan>[
                                                      new TextSpan(
                                                        text:
                                                            ' \$${items[index].price.toString()}',
                                                        style: TextStyle(
                                                          wordSpacing: 2,
                                                          fontSize:
                                                              _width * 0.028,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                AutoSizeText(
                                                  'Starting Price at \$122\/mo with easy financing',
                                                  textAlign: TextAlign.start,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: _width * 0.028,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                LoadingButton(
                                                  // key: _loadingKey,
                                                  type:
                                                      LoadingButtonType.Raised,
                                                  loadingWidget:
                                                      SpinKitPianoWave(
                                                    color: Colors.white,
                                                    size: 14,
                                                  ),
                                                  color: Color.fromARGB(
                                                    255,
                                                    102,
                                                    102,
                                                    102,
                                                  ),
                                                  width: _width * .25,
                                                  height: 35,
                                                  onPressed: () async {
                                                    var _login = await ConstantsVar
                                                            .storage
                                                            .read(
                                                                key:
                                                                    'customerId') ??
                                                        false;
                                                    // print(_login);
                                                    if (_login == false) {
                                                      await Navigator.push(
                                                        context,
                                                        CupertinoPageRoute(
                                                          builder: (context) =>
                                                              LoginScreen(
                                                            screenKey:
                                                                'Home Screen',
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      await CustomerApis.addToCart(
                                                          cartId: await ConstantsVar
                                                                  .storage
                                                                  .read(
                                                                      key:
                                                                          'cartID') ??
                                                              '',
                                                          sku: items[index].sku,
                                                          context: context,
                                                          customerToken:
                                                              await ConstantsVar
                                                                      .storage
                                                                      .read(
                                                                          key:
                                                                              'customerToken') ??
                                                                  '',
                                                          quantity: '1');
                                                    }
                                                  },
                                                  defaultWidget: Container(
                                                    child: Center(
                                                      child: AutoSizeText(
                                                        'Add to cart',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
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
                              )),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: SizedBox(
                        // width: 100.w,
                        height: _height * .12,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Icon(
                                  Icons.arrow_back,
                                  size: _width * .08,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child:Image.asset(
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
                                  var _login = await ConstantsVar.storage
                                          .read(key: 'customerId') ??
                                      false;
                                  _login == false
                                      ? await Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) => LoginScreen(
                                                screenKey: 'Home Screen'),
                                          ),
                                        )
                                      : await Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) => CartScreen2(
                                              isOtherScren: true,
                                              otherScreenName: 'Home Screen',
                                            ),
                                          ),
                                        );
                                },
                                child: Image.asset(
                                  'BBQ_Images/shopping_cart.png',
                                  width: _width * .1,
                                  height: _width * .1,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: _width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            // color: Colors.red,
                            //                   <--- border color
                            width: 2.0,
                          ),
                        ),
                        child: AdvancedSearch(
                          searchMode: SearchMode.STARTING_WITH,
                          maxElementsToDisplay: 7,
                          focusedBorderColor: Colors.transparent,
                          enabledBorderColor: Colors.transparent,
                          disabledBorderColor: Colors.transparent,
                          hintTextColor: Colors.black,
                          onSearchClear: () {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                          },
                          onItemTap: (int index, String value) {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }

                            print(value);
                            mySearchProduct(query: value);
                          },
                          onSubmitted: (val1, val2) {
                            print('Value 1 >>>>>$val1');
                            print('Value 2 >>>>>$val2');
                            mySearchProduct(query: val1);
                          },
                          data: searchableList,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> mySearchProduct({required String query}) async {
    setState(() {
      _isLoading = true;
      print(query);
      items = [];
    });
    // = '';
    ConstantsVar.storage = const FlutterSecureStorage();
    String _token = await ConstantsVar.storage.read(
          key: 'adminToken',
        ) ??
        '';

    final _header = {'Authorization': 'Bearer $_token'};

    final uri = Uri.parse(magentoBaseUrl +
        'products?' +
        'searchCriteria[filter_groups][0][filters][0][field]=name&searchCriteria[filter_groups][0][filters][0][condition_type]=like&searchCriteria[pageSize]=50&searchCriteria[filter_groups][0][filters][0][value]=%25$query%25');
    try {
      var response = await get(uri, headers: _header);
      setState(() {
        _isLoading = false;
      });
      print(response.body);

      BBQSearchResponse _resultResponse =
          BBQSearchResponse.fromJson(jsonDecode(response.body));
      setState(() {
        items = _resultResponse.items;
        print('List Size ${items.length}');
        _isLoading = false;
      });
      // _isLoading = false;

      // _isLoading = false;
      // notifyListeners();

    } on Exception catch (e) {
      // _isLoading = false;
      ConstantsVar.excecptionMessage(e);
      // notifyListeners();
      setState(() {
        _isLoading = false;
        items = [];
      });
    }
    // return _resultResponse;

    // notifyListeners();
  }
}
