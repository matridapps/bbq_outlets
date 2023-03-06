import 'dart:developer';
import 'package:BBQOUTLETS/Constants/ConstantVariables.dart';
import 'package:BBQOUTLETS/Widgets/NeuromorphicsEffect/neuromorphics_effect.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider(
      {Key? key,
      required List<String> imageList,
      required double width,
      required double height})
      : _imageList = imageList,
        _width = width,
        _height = height,
        super(key: key);
  final List<String> _imageList;
  final double _width, _height;

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> with NeuromorphicsEffect {
  int _index = 0;

  final GlobalKey<CarouselSliderState> _sliderKey = GlobalKey();
  final _controller = CarouselController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.landscape
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: customSliderLandscape(
                images: widget._imageList,
                width: widget._width,
                height: widget._height),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: customSliderPortrait(
                images: widget._imageList,
                width: widget._width,
                height: widget._height),
          );
  }

  Widget customSliderLandscape(
      {required List<String> images,
      required double width,
      required double height}) {
    return SizedBox(
      width: width,
      height: height * 0.55,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: getNeuromorphicsEffect(
              color: Colors.grey.withOpacity(0.2),
            ),
            width: width * .16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      _controller.animateToPage(index,
                          duration: const Duration(seconds: 2),
                          curve: Curves.easeOutCubic);
                    },
                    child: Container(
                      width: width * 0.12,
                      height: width * 0.12,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            images[index],
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.8),
                            offset: const Offset(-6.0, -6.0),
                            blurRadius: 16.0,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(6.0, 6.0),
                            blurRadius: 16.0,
                          ),
                        ],
                        color: const Color(0xFFEFEEEE),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: index == _index
                              ? ConstantsVar.appColor
                              : Colors.white,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: width * .2,
          ),
          Expanded(
            child: CarouselSlider.builder(
              carouselController: _controller,
              key: _sliderKey,
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                disableCenter: true,
                viewportFraction: 0.95,
                height: height * 0.5,
                initialPage: 0,
                onPageChanged: (val, _) {
                  if (_index < images.length || _index == 0) {
                    setState(() {
                      _index = val;
                    });
                  } else if (_index == images.length) {
                    setState(() {
                      _index = 0;
                    });
                  }
                  log('index :- $_index');
                },
                onScrolled: (val) {
                  // log(val!.toString());
                },
              ),
              itemCount: images.length > 8 ? 7 : images.length,
              itemBuilder: (
                _,
                index,
                val,
              ) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: width * 0.55,
                    height: width * 0.55,
                    decoration: getNeuromorphicsEffect(color: Colors.white),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                        ),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            images[index],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget customSliderPortrait(
      {required List<String> images,
      required double width,
      required double height}) {
    return SizedBox(
      width: width,
      height: height * 0.60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: CarouselSlider.builder(
              carouselController: _controller,
              key: _sliderKey,
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                disableCenter: true,
                viewportFraction: 0.95,
                height: height * 0.5,
                initialPage: 0,
                onPageChanged: (val, _) {
                  if (_index < images.length || _index == 0) {
                    setState(() {
                      _index = val;
                    });
                  } else if (_index == images.length) {
                    setState(() {
                      _index = 0;
                    });
                  }
                  log('index :- $_index');
                },
                onScrolled: (val) {
                  // log(val!.toString());
                },
              ),
              itemCount: images.length > 8 ? 7 : images.length,
              itemBuilder: (
                _,
                index,
                val,
              ) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: width * 0.55,
                    height: width * 0.55,
                    decoration: getNeuromorphicsEffect(color: Colors.white),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                        ),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            images[index],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: getNeuromorphicsEffect(
              color: Colors.grey.withOpacity(0.2),
            ),
            width: width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      _controller.animateToPage(index,
                          duration: const Duration(seconds: 2),
                          curve: Curves.easeOutCubic);
                    },
                    child: Container(
                      width: width * 0.15,
                      height: width * 0.15,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            images[index],
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.8),
                            offset: const Offset(-6.0, -6.0),
                            blurRadius: 16.0,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(6.0, 6.0),
                            blurRadius: 16.0,
                          ),
                        ],
                        color: const Color(0xFFEFEEEE),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: index == _index
                              ? ConstantsVar.appColor
                              : Colors.white,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
