import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget sliderImages(List<String> images, List<String> largeImage,
    BuildContext context, String discountPercentage) {
  return Container(
    height: 60.h,
    width: 100.w,
    child: Stack(
      children: [
        Center(
          child: CarouselSlider.builder(
            enableAutoSlider: images.length > 1 ? true : false,
            unlimitedMode: true,
            viewportFraction: 1,
            itemCount: images.length > 8 ? 7 : images.length,
            slideBuilder: (index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(
                      20,
                    ),
                   ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    opacity: 0.2,
                    image: AssetImage(
                      'BBQ_Images/maxresdefault.jpeg',
                    ),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.w,
                    vertical: 4.w,
                  ),
                  child: CachedNetworkImage(
                    fadeInCurve: Curves.bounceInOut,
                    // fit: BoxFit.fill,
                    imageUrl: images[index],
                    placeholder: (context, reason) => Center(
                      child: SpinKitPouringHourGlass(
                        color: Colors.orange,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              );
            },
            slideTransform: DefaultTransform(),
            slideIndicator: CircularSlideIndicator(
                padding: EdgeInsets.only(
                  top: 4.w,
                ),
                alignment: Alignment.bottomCenter,
                currentIndicatorColor: Colors.black),
          ),
        ),
      ],
    ),
  );
}

class ImageDialog extends StatelessWidget {
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(6),
        child: AspectRatio(
          aspectRatio: 4 / 4,
          child: Container(
            // width: double.infinity,
            // height: 200,
            decoration: BoxDecoration(
                // color: Colors.transparent,
                image: DecorationImage(
                    image: NetworkImage(imageUrl), fit: BoxFit.fill)),
          ),
        ),
      ),
    );
  }

  ImageDialog({required this.imageUrl});
}
