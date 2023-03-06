import 'package:BBQOUTLETS/AppPages/CartxxScreen/CartScreen2.dart';
import 'package:BBQOUTLETS/AppPages/HomeScreen/HomeScreen.dart';
import 'package:BBQOUTLETS/AppPages/LoginScreen/LoginScreen.dart';
import 'package:BBQOUTLETS/AppPages/MyAccount/MyAccount.dart';
import 'package:BBQOUTLETS/AppPages/NotificationxxScreen/Notification_Screen.dart';
import 'package:BBQOUTLETS/AppPages/Registration/RegistrationPage.dart';
import 'package:BBQOUTLETS/Constants/ConstantVariables.dart';
import 'package:BBQOUTLETS/utils/ApiCalls/ApiCalls.dart';
import 'package:BBQOUTLETS/utils/CartBadgeCounter/CartBadgetLogic.dart';
import 'package:BBQOUTLETS/utils/HeartIcon.dart';
import 'package:BBQOUTLETS/utils/utils/build_config.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

enum AniProps { color }

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  var color1 = ConstantsVar.appColor;
  var color2 = Colors.black54;
  late Animation<double> size;
  bool isLoadVisible = false;
  bool isListVisible = false;
  bool isLoading = true;

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.orange, Colors.orangeAccent, Colors.deepOrange],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  List<Color> colorList = [
    ConstantsVar.appColor,
    Colors.black26,
    Colors.white60
  ];
  List<Alignment> alignmentList = [
    Alignment.bottomLeft,
    Alignment.bottomRight,
    Alignment.topRight,
    Alignment.topLeft,
  ];
  int index = 0;
  Color topColor = ConstantsVar.appColor;
  Color bottomColor = Colors.black26;
  Alignment begin = Alignment.bottomLeft;
  Alignment end = Alignment.topRight;
  Color btnColor = Colors.black;
  int pageIndex = 0;
  var customerId;
  var _firstName, _email, phnNumber, _lastName;

  bool isEmailVisible = false,
      isPhoneNumberVisible = false,
      isUserNameVisible = false;

  var customerGuid;

  // var gUId;

  // RefreshController _refreshController = RefreshController();
  @override
  void initState() {
    // TODO: implement initState

    getCustomerId();
    setState(() {
      customerId = ConstantsVar.prefs.getString('userId');
      _email = ConstantsVar.prefs.getString('customerEmail');
      _firstName = ConstantsVar.prefs.getString('customerFirstName');
      _lastName = ConstantsVar.prefs.getString('customerLastName');
      phnNumber = ConstantsVar.prefs.getString('phone');
      customerGuid = ConstantsVar.prefs.getString('guestGUID');
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<cartCounter>(context, listen: false).showModelSheet(
          context: context,
          lastName: _lastName,
          emailId: _email,
          firstName: _firstName);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        backgroundColor: ConstantsVar.appColor,
        backwardsCompatibility: true,
        toolbarHeight: 14.w,
        // leading: IconButton(
        //   onPressed: () {},
        //   icon: Icon(Icons.arrow_back),
        // ),
        title: InkWell(
          onTap: () => Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                builder: (context) => MyHomePage(
                  pageIndex: 0,
                ),
              ),
              (route) => false),
          child: Image.asset(
            logoImage,
            width: 13.w,
            height: 13.w,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Center(
            child: Container(
              width: 130,
              height: 80,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    logoImage,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              'BBQ OUTLETS',
              style: GoogleFonts.montserrat(
                  fontSize: 8.w,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()..shader = linearGradient),
            ),
          ),
          Center(
            child: AutoSizeText(
              'Version 1.0.0, build \#1',
              style: GoogleFonts.montserrat(
                fontSize: 4.w,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Center(
            child: AutoSizeText(
              '\© 1996-2021 BBQ Outlets Inc. All Rights Reserved.',
              style: GoogleFonts.montserrat(
                fontSize: 1.w,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 6,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 2,
            ),
            child: Container(
              width: 100.w,
              child: Divider(
                thickness: 1,
                color: Colors.grey,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: AutoSizeText(
                'Founded in 2005, BBQ Outlets operates 2 showrooms in Southern California (more on the way!) as well as an unmatched e-commerce site.',
                style: GoogleFonts.montserrat(
                  fontSize: 6,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 1,
            ),
            child: Container(
              width: 100.w,
              child: Divider(
                thickness: 1,
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: AutoSizeText(
              'About Us',
              style: GoogleFonts.montserrat(
                fontSize: 5.w,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 1,
            ),
            child: ListTile(
              onTap: () => ApiCalls.launchUrl(
                  'https://www.bbqoutlets.com/price-matching-quotes'),
              visualDensity: VisualDensity.compact,
              dense: true,
              shape: Border.all(color: Colors.black),
              title: Text(
                'Price Matching Guarantee',
                style: GoogleFonts.montserrat(
                  fontSize: 4.w,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 1,
            ),
            child: ListTile(
              onTap: () =>
                  ApiCalls.launchUrl('https://www.bbqoutlets.com/testimonials'),
              visualDensity: VisualDensity.compact,
              dense: true,
              shape: Border.all(color: Colors.black),
              title: Text(
                'Customer Testimonials',
                style: GoogleFonts.montserrat(
                  fontSize: 4.w,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 1,
            ),
            child: ListTile(
              onTap: () => ApiCalls.launchUrl(
                  'https://www.bbqoutlets.com/become-a-vendor'),
              visualDensity: VisualDensity.compact,
              shape: Border.all(color: Colors.black),
              dense: true,
              title: Text(
                'Become a Vendor',
                style: GoogleFonts.montserrat(
                  fontSize: 4.w,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 1,
            ),
            child: ListTile(
              onTap: () => ApiCalls.launchUrl(
                  'https://www.bbqoutlets.com/why-shop-bbq-outlets'),
              visualDensity: VisualDensity.compact,
              dense: true,
              shape: Border.all(color: Colors.black),
              title: Text(
                'Why Shop BBQ Outlets',
                style: GoogleFonts.montserrat(
                  fontSize: 4.w,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 1,
            ),
            child: ListTile(
              onTap: () => ApiCalls.launchUrl(
                  'https://www.bbqoutlets.com/join-our-team'),
              visualDensity: VisualDensity.compact,
              dense: true,
              shape: Border.all(color: Colors.black),
              title: Text(
                'Join Our Team',
                style: GoogleFonts.montserrat(
                  fontSize: 4.w,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 1,
            ),
            child: ListTile(
              onTap: () =>
                  ApiCalls.launchUrl('https://www.bbqoutlets.com/history'),
              visualDensity: VisualDensity.compact,
              dense: true,
              shape: Border.all(color: Colors.black),
              title: Text(
                'Our History',
                style: GoogleFonts.montserrat(
                  fontSize: 4.w,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 1,
            ),
            child: ListTile(
              onTap: () =>
                  ApiCalls.launchUrl('https://www.bbqoutlets.com/AboutUs/'),
              visualDensity: VisualDensity.compact,
              dense: true,
              shape: Border.all(color: Colors.black),
              title: Text(
                'About us',
                style: GoogleFonts.montserrat(
                  fontSize: 4.w,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 1,
            ),
            child: ListTile(
              onTap: () => ApiCalls.launchUrl(
                  'https://www.bbqoutlets.com/grill-buying-guides'),
              visualDensity: VisualDensity.compact,
              dense: true,
              shape: Border.all(color: Colors.black),
              title: Text(
                'Grill Buying Guides',
                style: GoogleFonts.montserrat(
                  fontSize: 4.w,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Future getCustomerId() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance().whenComplete(() {
      print('customerId ==>>' + ConstantsVar.customerID);
    });
  }

  void getUserCreds() async {
    print(_firstName + _email + phnNumber);

    if (_email == '') {
      setState(() {
        isEmailVisible = false;
        _email = '';
      });
    }
    if (_firstName == '') {
      setState(() {
        _firstName =
            'Guestuser' + ConstantsVar.prefs.getString('guestCustomerID')!;

        print(_firstName);
      });
    }
    if (phnNumber == '') {
      setState(() {
        isPhoneNumberVisible = false;
        phnNumber = '';
      });
    }
  }

  Future clearUserDetails() async {
    ConstantsVar.prefs.clear();
  }
}

// DelayedDisplay(
//   delay: Duration(
//     seconds: 1,
//     microseconds: 100,
//   ),
//   child: Card(
//     color: Colors.white,
//
//     // color: Colors.white,
//     child: Padding(
//       padding: EdgeInsets.symmetric(
//         vertical: 6.w,
//         horizontal: 8.w,
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Card(
//             child: Icon(
//               HeartIcon.user,
//               color: ConstantsVar.appColor,
//               size: 34,
//             ),
//           ),
//           SizedBox(
//             width: 20,
//           ),
//           Container(
//             child: Text(
//               'My Account'.toUpperCase(),
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 5.w,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   ),
// ),
