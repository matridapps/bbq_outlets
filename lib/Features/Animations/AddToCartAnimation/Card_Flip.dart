import 'package:auto_size_text/auto_size_text.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FlipMyCard extends StatelessWidget {
  FlipMyCard({Key? key, required this.callback}) : super(key: key);
              VoidCallback callback;
    FlipCardController controller  = FlipCardController();

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return FlipCard(
      controller: controller,
      flipOnTouch: true,
      front: Center(
        child: GestureDetector(
          onTap:() {
            controller.toggleCard();
            callback() ;
            controller.toggleCard();
          },
          child: Container(
            decoration: ShapeDecoration(
              color: Color.fromARGB(
                255,
                102,
                102,
                102,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            width: _width * .25,
            height: 35,
            child: Center(
              child: AutoSizeText(
                'Add to cart',
                style: TextStyle(
                  color:
                  Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      back: Container(
        decoration: ShapeDecoration(
          color: Color.fromARGB(
            255,
            102,
            102,
            102,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        width: _width * .25,
        height: 35,
        child:   SpinKitPianoWave(
          color: Colors.yellow,
          size: 14,
        ),
      ),
    );
  }
}
