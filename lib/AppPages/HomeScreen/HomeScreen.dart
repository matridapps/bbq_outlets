import 'dart:async';
import 'package:BBQOUTLETS/AppPages/CartxxScreen/CartScreen2.dart';
import 'package:BBQOUTLETS/AppPages/HomeCategory/HomeCategory.dart';
import 'package:BBQOUTLETS/AppPages/MagentoAdminApis/CustomerApis.dart';
import 'package:BBQOUTLETS/AppPages/NavigationPage/MenuPage.dart';
import 'package:BBQOUTLETS/Constants/ConstantVariables.dart';
import 'package:BBQOUTLETS/PojoClass/GridViewModel.dart';
import 'package:BBQOUTLETS/PojoClass/itemGridModel.dart';
import 'package:BBQOUTLETS/utils/ApiCalls/ApiCalls.dart';
import 'package:BBQOUTLETS/utils/CartBadgeCounter/CartBadgetLogic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
// import 'package:loader_overlay/loader_overlay.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomeScreenMain/home_screen_main.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _token = '';

  @override
  void initState() {
    initShared().then((value) => getCartBagdge(0));
    super.initState();
  }

  Future getCartBagdge(int val) async {
    CustomerApis.showMagentoCart(token: _token);

    ApiCalls.readCounter(context: context).then((value) {
      if (mounted) {
        context.read<cartCounter>().changeCounter(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return
       FlutterSizer(
        builder: (context, ori, deviceType) => MaterialApp(
          title: 'BBQ Outlets',
          theme: ThemeData(
              primarySwatch: Colors.red,
              appBarTheme: AppBarTheme(
                backgroundColor: ConstantsVar.appColor,
              )),
          home: MyHomePage(
            pageIndex: 0,
          ),

      ),
    );
  }

  Future initShared() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    _token = ConstantsVar.prefs.getString('customerToken')!;
    print('Hi There its me token $_token');
    setState(() {});
  }
}

@immutable
class MyHomePage extends StatefulWidget {
  MyHomePage({required this.pageIndex});

  final int pageIndex;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with AutomaticKeepAliveClientMixin {
  List<GridViewModel> mList = [];
  List<GridPojo> mList1 = [];
  final PageStorageBucket bucket = PageStorageBucket();
  var activeIndex = 0;

  // ListQueue<int> _navQueue = new ListQueue();

  late PersistentTabController _controller;


  @override
  void initState() {
    setState(() => activeIndex = widget.pageIndex);

    initSharedPrefs().then((value) => getCartBagdge(0));
    _controller = PersistentTabController(initialIndex: activeIndex);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        body: PersistentTabView(
          context,
          navBarHeight: 44,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: Colors.white,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: false,
          stateManagement: false,
          hideNavigationBarWhenKeyboardShows: true,
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(5.0),
            colorBehindNavBar: Colors.white,
          ),
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          itemAnimationProperties: ItemAnimationProperties(
            duration: Duration(milliseconds: 200),
            curve: Curves.elasticInOut,
          ),
          screenTransitionAnimation: ScreenTransitionAnimation(
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle: NavBarStyle.style9,
        ),
      ),
    );
  }

  Future initSharedPrefs() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  Future getCartBagdge(int val) async {
    ApiCalls.readCounter( context: context).then((value) {
      setState(() {
        context.read<cartCounter>().changeCounter(value);
      });
    });
  }

  @override
  bool get wantKeepAlive => false;

  Widget getBodies(int index) {
    switch (index) {
      case 0:
        return HomeScreenMain();

      case 1:
        return HomeCategory();
      case 2:
        return CartScreen2(
          isOtherScren: false,
          otherScreenName: '',
        );
      case 3:
        return MenuPage();
      default:
        return Container(
          child: Center(
            child: Text('Wrong Route'),
          ),
        );
    }
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreenMain(),
      HomeCategory(),
      CartScreen2(
        isOtherScren: false,
        otherScreenName: '',
      ),
      MenuPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.home_filled,
          size: 20,
        ),
        title: ("Home"),
        activeColorPrimary: CupertinoColors.activeOrange,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.shopping_bag,
          size: 20,
        ),
        title: ("Categories"),
        activeColorPrimary: CupertinoColors.activeOrange,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.shopping_cart,
          size: 20,
        ),
        title: ("Cart"),
        activeColorPrimary: CupertinoColors.activeOrange,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        iconSize: 20,
        icon: Icon(
          Icons.menu,
          size: 20,
        ),
        contentPadding: 2,
        title: ("Profile"),
        activeColorPrimary: CupertinoColors.activeOrange,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }
}
