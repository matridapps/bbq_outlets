// ignore_for_file: file_names

import 'package:BBQOUTLETS/AppPages/HomeScreen/HomeScreen.dart';
import 'package:BBQOUTLETS/Constants/ConstantVariables.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CustomDialogBox extends StatefulWidget {
  final String descriptions, text;
  final String img;
  final bool isOkay;

  // final Route route;

  const CustomDialogBox({
    Key? key,
    required this.isOkay,
    // required this.title,
    required this.descriptions,
    required this.text,
    required this.img,
    // required this.route,
  }) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding:
              const EdgeInsets.only(left: 20, top: 45 + 20, right: 20, bottom: 20),
          margin: const EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AutoSizeText(
                widget.descriptions,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 6,
              ),
              AutoSizeText(
                widget.text,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.center,
                child: Visibility(
                  visible: widget.isOkay,
                  child: FlatButton(
                      color: Colors.black,
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => MyHomePage(pageIndex: 0,)),
                            (route) => false);
                      },
                      child: Container(
                        color: Colors.black,
                        child: const AutoSizeText(
                          'OKAY',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 45,
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(45)),
                child: Image.asset("MyAssets/logo.png")),
          ),
        ),
      ],
    );
  }
}

class CustomDialogBox1 extends StatefulWidget {
  final String descriptions, text;
  final String img;
  final String reason;

  // final Route route;

  const CustomDialogBox1({
    Key? key,
    // required this.title,
    required this.descriptions,
    required this.text,
    required this.img,
    required this.reason,
    // required this.route,
  }) : super(key: key);

  @override
  _CustomDialogBoxState1 createState() => _CustomDialogBoxState1();
}

class _CustomDialogBoxState1 extends State<CustomDialogBox1> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding:
              const EdgeInsets.only(left: 20, top: 45 + 20, right: 20, bottom: 20),
          margin: const EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AutoSizeText(
                widget.reason.isEmpty
                    ? widget.descriptions
                    : widget.descriptions +
                        '!' +
                        '\n' +
                        widget.reason + '.',
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                    color: Colors.black,
                    onPressed: () async {
                      ConstantsVar.prefs =
                          await SharedPreferences.getInstance();
                      ConstantsVar.prefs.setString('regBody', '');
                      Navigator.of(context).pop();
                    },
                    child: AutoSizeText(
                      widget.text,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    )),
              ),
            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 45,
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(45)),
                child: Image.asset("MyAssets/logo.png")),
          ),
        ),
      ],
    );
  }
}
