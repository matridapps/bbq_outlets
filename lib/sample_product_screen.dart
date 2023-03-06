// ignore_for_file: prefer_final_fields, avoid_returning_null_for_void

import 'dart:convert';
import 'package:BBQOUTLETS/Features/CustomPaints/curve_line_paint.dart';
import 'package:BBQOUTLETS/Widgets/NeuromorphicsEffect/neuromorphics_effect.dart';
import 'package:BBQOUTLETS/utils/utils/build_config.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import 'AppPages/StreamClass/NewPeoductPage/custom_json_product_response.dart';
import 'Constants/ConstantVariables.dart';

import 'Widgets/CustomSldier/custom_slider_widget.dart';

class SampleProductPage extends StatefulWidget {
  const SampleProductPage({Key? key}) : super(key: key);

  @override
  State<SampleProductPage> createState() => _SampleProductPageState();
}

class _SampleProductPageState extends State<SampleProductPage>
    with NeuromorphicsEffect {
  CustomJsonProductResponse? initialData;
  int _pageIndex = 0;
  int defaultChoiceIndex = 0;
  int defaultSizeChoiceIndex = 0;
  String _name = '';
  String _price = '';
  String _sku = '';
  String _details = '';
  String _moreInfo = '';
  List<String> _images = [];
  List<FuelType> _fuelType = [];
  List<FuelType> _size = [];
  var _isSelected = false;

  Future<void> readJsonData() async {
    final _data = await DefaultAssetBundle.of(context)
        .loadString('SampleJSONFile/SampleProductJson.json');

    initialData = CustomJsonProductResponse.fromJson(jsonDecode(_data));
    _name = initialData!.name;
    _sku = initialData!.sku;
    _price = initialData!.price.toString();
    _images = initialData!.extensionAttributes.productImages;
    _fuelType = initialData!.fuelType;
    _size = initialData!.size;
    _details = initialData!.details;
    _moreInfo = initialData!.moreInformation;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    readJsonData();
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.landscape
        ? _landscapeOrientationBuilder()
        : _portraitOrientationBuilder();
  }

  Widget _landscapeOrientationBuilder() {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: SizedBox(
                      height: _height * 0.3,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                height: _height * .12,
                                width: _height * .12,
                                decoration:
                                    getNeuromorphicsEffect(color: Colors.white),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.arrow_back,
                                      size: _width * 0.046,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Image.asset(
                              logoImage,
                              width: _width * .28,
                              height: _width * .24,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () async {},
                              child: Container(
                                decoration:
                                    getNeuromorphicsEffect(color: Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'BBQ_Images/shopping_cart.png',
                                    width: _width * .046,
                                    height: _width * .046,
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
                  SizedBox(
                    width: _width,
                    height: _height * 0.3,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 6.0, bottom: 0, left: 7, right: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                _name.contains(_sku)
                                    ? _name.replaceAll('-' + _sku, '')
                                    : _name,
                                style: GoogleFonts.poppins(
                                    wordSpacing: .2,
                                    letterSpacing: .2,
                                    fontSize: _width * 0.025,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.start,
                              ),
                              AutoSizeText(
                                _sku,
                                style: GoogleFonts.poppins(
                                  wordSpacing: .2,
                                  letterSpacing: .5,
                                  fontSize: _width * 0.025,
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: _height * .035,
                          right: _height * .075,
                          child: RatingBarWidget(
                            rating: 4.5,
                            disable: true,
                            onRatingChanged: (val) => null,
                            activeColor: ConstantsVar.appColor.withOpacity(0.7),
                            size: _width * .035,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: CustomSlider(
                        imageList: _images.isEmpty ? [noImageUrl] : _images,
                        height: _height * 1.6,
                        width: _width * .7,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('\$',
                                      style: GoogleFonts.poppins(
                                        wordSpacing: .2,
                                        letterSpacing: .5,
                                        fontSize: _width * 0.035,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      )),
                                  Text(_price + '.00',
                                      style: GoogleFonts.poppins(
                                        wordSpacing: .2,
                                        letterSpacing: .5,
                                        fontSize: _width * 0.03,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      )),
                                ],
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              AnimatedTextKit(
                                isRepeatingAnimation: true,
                                totalRepeatCount: 3,
                                animatedTexts: [
                                  WavyAnimatedText(
                                    '45% OFF',
                                    textStyle: GoogleFonts.poppins(
                                      wordSpacing: .2,
                                      letterSpacing: .5,
                                      fontSize: _width * 0.03,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                '+ Free Shipping',
                                style: GoogleFonts.poppins(
                                  wordSpacing: .2,
                                  letterSpacing: .5,
                                  fontSize: _width * 0.02,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Regular Price: ',
                                  style: GoogleFonts.poppins(
                                    fontSize: _width * 0.024,
                                    color: Colors.black,
                                    letterSpacing: 0.30,
                                    wordSpacing: .5,
                                  ),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  '\$12850.00',
                                  style: GoogleFonts.poppins(
                                    fontSize: _width * 0.028,
                                    color: Colors.black,
                                    letterSpacing: 0.30,
                                    wordSpacing: .5,
                                    decoration: TextDecoration.lineThrough,
                                    decorationThickness: 3,
                                    decorationColor: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Starting at \$161/mo with ',
                                style: GoogleFonts.poppins(
                                  fontSize: _width * 0.024,
                                  color: Colors.black,
                                  letterSpacing: 0.30,
                                  wordSpacing: .5,
                                ),
                              ),
                              FittedBox(
                                child: SizedBox(
                                  width: _width * 0.09,
                                  height: _width * 0.06,
                                  child: CustomPaint(
                                    painter: CurveLine(
                                      color: const Color.fromRGBO(
                                          74, 75, 244, 0.9),
                                    ),
                                    child: AutoSizeText(
                                      'affirm',
                                      style: GoogleFonts.poppins(
                                        fontSize: _width * 0.1,
                                        color: Colors.black,
                                        letterSpacing: 0.30,
                                        fontWeight: FontWeight.bold,
                                        wordSpacing: .5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ),

                  /*Add to cart button placement here*/

                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      width: _width,
                      decoration: getNeuromorphicsEffect(
                          color: _isSelected == false
                              ? Colors.white
                              : ConstantsVar.appColor.withOpacity(
                                  0.7,
                                )),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: AutoSizeText(
                                'Choose Configuration'.toUpperCase(),
                                style: GoogleFonts.poppins(
                                  fontSize: _width * 0.024,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  letterSpacing: .30,
                                  wordSpacing: .2,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  'Fuel-Type',
                                  style: GoogleFonts.poppins(
                                    fontSize: _width * 0.026,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    letterSpacing: .30,
                                    wordSpacing: .2,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Wrap(
                                  spacing: 2,
                                  children: List.generate(
                                    _fuelType.length,
                                    (index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              defaultChoiceIndex = index;
                                              _name =
                                                  _fuelType[index].productName;
                                              _sku = _fuelType[index].sku;
                                              _price = _fuelType[index]
                                                  .price
                                                  .toString();
                                            });
                                          },
                                          child: Container(
                                            width: _width * 0.3,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  offset:
                                                      const Offset(-6.0, -6.0),
                                                  blurRadius: 10.0,
                                                ),
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  offset:
                                                      const Offset(6.0, 6.0),
                                                  blurRadius: 13.0,
                                                ),
                                              ],
                                              border: Border.all(
                                                color:
                                                    defaultChoiceIndex == index
                                                        ? ConstantsVar.appColor
                                                            .withOpacity(0.8)
                                                        : Colors.white,
                                                width: 3,
                                              ),
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Image.asset(
                                                    initialData!.fuelType[index]
                                                        .imageUrl,
                                                    width: 20,
                                                    height: 20,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: AutoSizeText(
                                                      _fuelType[index].fuel,
                                                      style: TextStyle(
                                                        fontSize:
                                                            _width * 0.024,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        letterSpacing: .30,
                                                        wordSpacing: .2,
                                                      )),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                AutoSizeText(
                                  'Size',
                                  style: TextStyle(
                                    fontSize: _width * 0.026,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    letterSpacing: .30,
                                    wordSpacing: .2,
                                  ),
                                ),
                                // Wrap(children: ,),
                                const SizedBox(
                                  height: 10,
                                ),
                                Wrap(
                                  spacing: 2,
                                  children:
                                      List.generate(_size.length, (index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            defaultSizeChoiceIndex = index;
                                            _name = _size[index].productName;
                                            _sku = _size[index].sku;
                                            _price =
                                                _size[index].price.toString();
                                          });
                                        },
                                        child: Container(
                                          width: _width * 0.3,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                                offset:
                                                    const Offset(-6.0, -6.0),
                                                blurRadius: 10.0,
                                              ),
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                offset: const Offset(6.0, 6.0),
                                                blurRadius: 13.0,
                                              ),
                                            ],
                                            border: Border.all(
                                              width: 3,
                                              color: defaultSizeChoiceIndex ==
                                                      index
                                                  ? ConstantsVar.appColor
                                                      .withOpacity(0.8)
                                                  : Colors.white,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.asset(
                                                  _size[index].imageUrl,
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: AutoSizeText(
                                                  _size[index].name,
                                                  style: TextStyle(
                                                    fontSize: _width * 0.024,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    letterSpacing: .30,
                                                    wordSpacing: .2,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => const CutomClass(),
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  height: _height * .15,
                                  width: _width * .4,
                                  decoration: getNeuromorphicsEffect(
                                    color:
                                        ConstantsVar.appColor.withOpacity(0.7),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal: _width * .1),
                                      child: AutoSizeText(
                                        'Add to Cart',
                                        style: GoogleFonts.poppins(
                                          wordSpacing: .2,
                                          letterSpacing: .5,
                                          fontWeight: FontWeight.bold,
                                          fontSize: _width * 0.022,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  width: _width,
                  decoration: getNeuromorphicsEffect(color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2.0,
                      vertical: 5,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                width: _width,
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _pageIndex = 0;
                                        setState(() {});
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: _width * .2,
                                            height: _width * .08,
                                            decoration: getNeuromorphicsEffect(
                                              color: Colors.white,
                                            ),
                                            child: Stack(
                                              children: [
                                                Center(
                                                  child: Text(
                                                    'Details',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: _width * 0.024,
                                                      color: Colors.black,
                                                      letterSpacing: .30,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      wordSpacing: .2,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 3,
                                                  left: 3,
                                                  child: Container(
                                                    width: 15,
                                                    height: 15,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: _pageIndex == 0
                                                          ? ConstantsVar
                                                              .appColor
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _pageIndex = 1;
                                        setState(() {});
                                      },
                                      child: Container(
                                        width: _width * .4,
                                        height: _width * .08,
                                        decoration: getNeuromorphicsEffect(
                                          color: Colors.white,
                                        ),
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: Text(
                                                'More Information',
                                                style: GoogleFonts.poppins(
                                                  fontSize: _width * 0.024,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  letterSpacing: .30,
                                                  wordSpacing: .2,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 3,
                                              right: 3,
                                              child: Container(
                                                width: 15,
                                                height: 15,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: _pageIndex == 1
                                                      ? ConstantsVar.appColor
                                                      : Colors.white,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(seconds: 01),
                                  child: _pageIndex == 0
                                      ? HtmlWidget(
                                          _details,
                                          textStyle: GoogleFonts.poppins(
                                              fontSize: _width * 0.02,
                                              fontWeight: FontWeight.w500),
                                        )
                                      : HtmlWidget(
                                          _moreInfo,
                                          textStyle: GoogleFonts.poppins(
                                              fontSize: _width * 0.02,
                                              fontWeight: FontWeight.w500),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _portraitOrientationBuilder() {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: SizedBox(
                      height: _height * 0.1,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                decoration:
                                    getNeuromorphicsEffect(color: Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.arrow_back,
                                    size: _width * 0.08,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Image.asset(
                              logoImage,
                              width: _width * .35,
                              height: _width * .30,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () async {},
                              child: Container(
                                decoration:
                                    getNeuromorphicsEffect(color: Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
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
                  SizedBox(
                    width: _width,
                    height: _height * 0.125,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 6.0, bottom: 0, left: 7, right: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AutoSizeText(
                                _name.contains(_sku)
                                    ? _name.replaceAll('-' + _sku, '')
                                    : _name,
                                style: GoogleFonts.poppins(
                                    wordSpacing: .2,
                                    letterSpacing: .2,
                                    fontSize: _width * 0.033,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.start,
                              ),
                              AutoSizeText(
                                _sku,
                                style: GoogleFonts.poppins(
                                  wordSpacing: .2,
                                  letterSpacing: .5,
                                  fontSize: _width * 0.03,
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 10,
                          child: RatingBarWidget(
                            rating: 4.5,
                            disable: true,
                            onRatingChanged: (val) => null,
                            activeColor: ConstantsVar.appColor.withOpacity(0.7),
                            size: 13,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: CustomSlider(
                        imageList: _images.isEmpty ? [noImageUrl] : _images,
                        height: _height,
                        width: _width,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FittedBox(
                            child: SizedBox(
                              width: _width * .9,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text('\$',
                                          style: GoogleFonts.poppins(
                                            wordSpacing: .2,
                                            letterSpacing: .5,
                                            fontSize: _width * 0.045,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          )),
                                      Text(_price + '.00',
                                          style: GoogleFonts.poppins(
                                            wordSpacing: .2,
                                            letterSpacing: .5,
                                            fontSize: _width * 0.055,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          )),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  AnimatedTextKit(
                                    isRepeatingAnimation: true,
                                    totalRepeatCount: 3,
                                    animatedTexts: [
                                      WavyAnimatedText(
                                        '45% OFF',
                                        textStyle: GoogleFonts.poppins(
                                          wordSpacing: .2,
                                          letterSpacing: .5,
                                          fontSize: _width * 0.055,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '+ Free Shipping',
                                    style: GoogleFonts.poppins(
                                      wordSpacing: .2,
                                      letterSpacing: .5,
                                      fontSize: _width * 0.0275,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Regular Price: ',
                                  style: GoogleFonts.poppins(
                                    fontSize: _width * 0.035,
                                    color: Colors.black,
                                    letterSpacing: 0.30,
                                    wordSpacing: .5,
                                    // decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  '\$12850.00',
                                  style: GoogleFonts.poppins(
                                    fontSize: _width * 0.043,
                                    color: Colors.black,
                                    letterSpacing: 0.30,
                                    wordSpacing: .5,
                                    decoration: TextDecoration.lineThrough,
                                    decorationThickness: 3,
                                    decorationColor: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Starting at \$161/mo with ',
                                style: GoogleFonts.poppins(
                                  fontSize: _width * 0.044,
                                  color: Colors.black,
                                  letterSpacing: 0.30,
                                  wordSpacing: .5,
                                ),
                              ),
                              FittedBox(
                                child: SizedBox(
                                  width: _width * 0.15,
                                  height: _width * 0.1,
                                  child: CustomPaint(
                                    painter: CurveLine(
                                      color: const Color.fromRGBO(
                                          74, 75, 244, 0.9),
                                    ),
                                    child: AutoSizeText(
                                      'affirm',
                                      style: GoogleFonts.poppins(
                                        fontSize: _width * 0.1,
                                        color: Colors.black,
                                        letterSpacing: 0.30,
                                        fontWeight: FontWeight.bold,
                                        wordSpacing: .5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ),

                  /*Add to cart button placement here*/

                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      width: _width,
                      decoration: getNeuromorphicsEffect(
                          color: _isSelected == false
                              ? Colors.white
                              : ConstantsVar.appColor.withOpacity(
                                  0.7,
                                )),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: AutoSizeText(
                                'Choose Configuration'.toUpperCase(),
                                style: GoogleFonts.poppins(
                                  fontSize: _width * 0.044,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  letterSpacing: .30,
                                  wordSpacing: .2,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  'Fuel-Type',
                                  style: GoogleFonts.poppins(
                                    fontSize: _width * 0.05,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    letterSpacing: .30,
                                    wordSpacing: .2,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Wrap(
                                  spacing: 2,
                                  children: List.generate(
                                    _fuelType.length,
                                    (index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              defaultChoiceIndex = index;
                                              _name =
                                                  _fuelType[index].productName;
                                              _sku = _fuelType[index].sku;
                                              _price = _fuelType[index]
                                                  .price
                                                  .toString();
                                            });
                                          },
                                          child: Container(
                                            width: _width * 0.43,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  offset:
                                                      const Offset(-6.0, -6.0),
                                                  blurRadius: 10.0,
                                                ),
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  offset:
                                                      const Offset(6.0, 6.0),
                                                  blurRadius: 13.0,
                                                ),
                                              ],
                                              border: Border.all(
                                                color:
                                                    defaultChoiceIndex == index
                                                        ? ConstantsVar.appColor
                                                            .withOpacity(0.8)
                                                        : Colors.white,
                                                width: 3,
                                              ),
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Image.asset(
                                                    initialData!.fuelType[index]
                                                        .imageUrl,
                                                    width: 25,
                                                    height: 25,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: AutoSizeText(
                                                      initialData!
                                                          .fuelType[index].fuel,
                                                      style: TextStyle(
                                                        fontSize: _width * 0.04,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        letterSpacing: .30,
                                                        wordSpacing: .2,
                                                      )),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                AutoSizeText(
                                  'Size',
                                  style: TextStyle(
                                    fontSize: _width * 0.05,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    letterSpacing: .30,
                                    wordSpacing: .2,
                                  ),
                                ),
                                // Wrap(children: ,),
                                const SizedBox(
                                  height: 10,
                                ),
                                Wrap(
                                  spacing: 2,
                                  children:
                                      List.generate(_size.length, (index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            defaultSizeChoiceIndex = index;
                                            _name = _size[index].productName;
                                            _sku = _size[index].sku;
                                            _price =
                                                _size[index].price.toString();
                                          });
                                        },
                                        child: Container(
                                          width: _width * 0.4,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                                offset:
                                                    const Offset(-6.0, -6.0),
                                                blurRadius: 10.0,
                                              ),
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                offset: const Offset(6.0, 6.0),
                                                blurRadius: 13.0,
                                              ),
                                            ],
                                            border: Border.all(
                                              width: 3,
                                              color: defaultSizeChoiceIndex ==
                                                      index
                                                  ? ConstantsVar.appColor
                                                      .withOpacity(0.8)
                                                  : Colors.white,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.asset(
                                                  initialData!
                                                      .size[index].imageUrl,
                                                  width: 25,
                                                  height: 25,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: AutoSizeText(
                                                    initialData!
                                                        .size[index].name,
                                                    style: TextStyle(
                                                      fontSize: _width * 0.04,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                      letterSpacing: .30,
                                                      wordSpacing: .2,
                                                    )),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => const CutomClass(),
                                  ),
                                ),
                                child: Container(
                                  decoration: getNeuromorphicsEffect(
                                    color:
                                        ConstantsVar.appColor.withOpacity(0.7),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15.0,
                                        horizontal: _width * .3),
                                    child: AutoSizeText(
                                      'Add to Cart',
                                      style: GoogleFonts.poppins(
                                        wordSpacing: .2,
                                        letterSpacing: .5,
                                        fontWeight: FontWeight.bold,
                                        fontSize: _width * 0.04,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  width: _width,
                  decoration: getNeuromorphicsEffect(color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2.0,
                      vertical: 5,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                width: _width,
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _pageIndex = 0;
                                        setState(() {});
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: _width * .4,
                                            height: _width * .13,
                                            decoration: getNeuromorphicsEffect(
                                              color: Colors.white,
                                            ),
                                            child: Stack(
                                              children: [
                                                Center(
                                                  child: Text(
                                                    'Details',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: _width * 0.035,
                                                      color: Colors.black,
                                                      letterSpacing: .30,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      wordSpacing: .2,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 3,
                                                  left: 3,
                                                  child: Container(
                                                    width: 15,
                                                    height: 15,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: _pageIndex == 0
                                                          ? ConstantsVar
                                                              .appColor
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          _pageIndex = 1;
                                          setState(() {});
                                        },
                                        child: Container(
                                          width: _width * .4,
                                          height: _width * .13,
                                          decoration: getNeuromorphicsEffect(
                                            color: Colors.white,
                                          ),
                                          child: Stack(
                                            children: [
                                              Center(
                                                child: Text(
                                                  'More Information',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: _width * 0.035,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                    letterSpacing: .30,
                                                    wordSpacing: .2,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 3,
                                                right: 3,
                                                child: Container(
                                                  width: 15,
                                                  height: 15,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: _pageIndex == 1
                                                        ? ConstantsVar.appColor
                                                        : Colors.white,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(seconds: 01),
                                  child: _pageIndex == 0
                                      ? HtmlWidget(
                                          _details,
                                          textStyle: GoogleFonts.poppins(
                                              fontSize: _width * 0.04,
                                              fontWeight: FontWeight.w500),
                                        )
                                      : HtmlWidget(
                                          _moreInfo,
                                          textStyle: GoogleFonts.poppins(
                                              fontSize: _width * 0.04,
                                              fontWeight: FontWeight.w500),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class MultiSelectChip extends StatefulWidget {
//   final List<FuelType> reportList;
//   final Function(String) onSelectionChanged;
//
//   MultiSelectChip({
//     required this.onSelectionChanged,
//     required this.reportList,
//   });
//
//   @override
//   _MultiSelectChipState createState() => _MultiSelectChipState();
// }
//
// class _MultiSelectChipState extends State<MultiSelectChip> {
//   String selectedChoice = "";
//
//   _buildChoiceList() {
//     List<Widget> choices = [];
//     widget.reportList.forEach((item) {
//       choices.add(Container(
//         padding: const EdgeInsets.all(2.0),
//         child: ,
//       ));
//     });
//     return choices;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       children: _buildChoiceList(),
//     );
//   }
// }
