import 'dart:async';
import 'dart:io' show Platform;

import 'package:BBQOUTLETS/AppPages/HomeScreen/HomeScreen.dart';
import 'package:BBQOUTLETS/AppPages/MyOrders/MyOrders.dart';
import 'package:BBQOUTLETS/Constants/ConstantVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:loader_overlay/loader_overlay.dart';
import 'package:webview_flutter/webview_flutter.dart';
class PaymentPage extends StatefulWidget {
  PaymentPage({Key? key, required this.paymentUrl}) : super(key: key);
  String paymentUrl;

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  var progressCount;
  bool isLoading = true;
  bool _willGo = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();

    } else {

    }
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _willGoBack() async {
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
              builder: (context) => MyOrders(
                    isFromWeb: true,
                  )),
          (route) => false);
setState((){
  _willGo = true;
});
      return _willGo;
    }

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (currentFocus.hasFocus) {
          setState(() {
            currentFocus.unfocus();
          });
        }
      },
      child: SafeArea(
        top: true,
        child: WillPopScope(
          onWillPop: _willGo ? _willGoBack : () async => false,
          child: Scaffold(
            appBar: new AppBar(
              leading: Platform.isAndroid
                  ? InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => MyOrders(
                                      isFromWeb: true,
                                    )),
                            (route) => false);
                      },
                      child: Icon(Icons.arrow_back))
                  : InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => MyOrders(
                                      isFromWeb: true,
                                    )),
                            (route) => false);
                      },
                      child: Icon(Icons.arrow_back_ios)),
              backgroundColor: ConstantsVar.appColor,
              toolbarHeight: 18.w,
              centerTitle: true,
              title: GestureDetector(
                onTap: () {

                  Navigator.pushAndRemoveUntil(context,
                      CupertinoPageRoute(builder: (context) {
                    return MyApp();
                  }), (route) => false);
                },
                child: Image.asset(
                  'MyAssets/logo.png',
                  width: 15.w,
                  height: 15.w,
                ),
              ),
            ),
            body: Stack(
              children: <Widget>[
                WebView(
                  initialUrl: widget.paymentUrl,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                  onProgress: (int progress) {


                    setState(() {
                      isLoading = false;
                      progressCount = progress;
                    });
                  },
                  javascriptChannels: <JavascriptChannel>{
                    _toasterJavascriptChannel(context),
                  },
                  navigationDelegate: (NavigationRequest request) {
                    if (request.url.startsWith('https://www.youtube.com/')) {
                      print('blocking navigation to $request}');
                      return NavigationDecision.prevent;
                    }
                    print('allowing navigation to $request');
                    return NavigationDecision.navigate;
                  },
                  onPageStarted: (String url) {
                    setState(() {
                      _willGo = false;
                      isLoading = true;
                    });

                    print('Page started loading: $url');
                  },
                  onPageFinished: (String url) {
                    print('Page finished loading: $url');
                    setState(() {

                      _willGo = true;
                      isLoading = false;
                    });
                  },
                  gestureNavigationEnabled: true,
                ),
                isLoading
                    ? Center(
                        child: SpinKitRipple(
                        color: Colors.red,
                        size: 90,
                      ))
                    : Stack()
              ],
            ),
          ),
        ),
      ),
    );
  }



  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
