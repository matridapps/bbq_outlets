// @dart=2.9

import 'dart:async';
import 'dart:io';
import 'package:BBQOUTLETS/AppPages/CartxxScreen/CartScreen2.dart';
import 'package:BBQOUTLETS/AppPages/LoginScreen/LoginScreen.dart';
import 'package:BBQOUTLETS/new_screen/new_home_screen/new_home_screen.dart';
import 'package:BBQOUTLETS/utils/CartBadgeCounter/CartBadgetLogic.dart';
import 'package:BBQOUTLETS/utils/Route_Package/route_class.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'AppPages/SplashScreen/SplashScreen.dart';
import 'Constants/ConstantVariables.dart';
import 'new_screen/SearchDelegate/search_delegate.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  await runZonedGuarded(() {
    HttpOverrides.global = MyHttpOverrides();
    WidgetsFlutterBinding.ensureInitialized();

    GestureBinding.instance.resamplingEnabled = true;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]).then(
      (_) async {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge).then(
          (_) async {
            ConstantsVar.prefs = await SharedPreferences.getInstance();

            runApp(
              MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (_) => cartCounter(),
                  ),
                ],
                child: Phoenix(
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'BBQ Outlets',
                    home: const SplashScreen(),
                    routes: {
                      kSplashScreen: (context) => const SplashScreen(),
                      kHomeScreen: (context) => const NewHomeScreen(),
                      kSearchScreen: (context) => const NewSearchPage(),
                      kLoginScreen: (context) => const LoginScreen(
                            screenKey: '',
                          ),
                      kCartScreen: (context) => const CartScreen2(
                          isOtherScren: false, otherScreenName: ''),
                    },
                    theme: ThemeData(
                        pageTransitionsTheme: const PageTransitionsTheme(
                          builders: {
                            TargetPlatform.android:
                                ZoomPageTransitionsBuilder(),
                          },
                        ),
                        fontFamily: 'Arial',
                        primarySwatch: MaterialColor(0xFFFFAB40, color),
                        primaryColor: Colors.orangeAccent),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }, (e, s) {});
}

Map<int, Color> color = {
  50: const Color.fromRGBO(240, 144, 74, 1),
  100: const Color.fromRGBO(240, 144, 74, .9),
  200: const Color.fromRGBO(240, 144, 74, .8),
  300: const Color.fromRGBO(240, 144, 74, .7),
  400: const Color.fromRGBO(240, 144, 74, .6),
  500: const Color.fromRGBO(240, 144, 74, .5),
  600: const Color.fromRGBO(240, 144, 74, .4),
  700: const Color.fromRGBO(240, 144, 74, .3),
  800: const Color.fromRGBO(240, 144, 74, .2),
  900: const Color.fromRGBO(240, 144, 74, .1),
};
