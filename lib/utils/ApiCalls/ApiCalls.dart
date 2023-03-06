// ignore_for_file: prefer_const_declarations, implementation_imports

import 'dart:convert';
import 'dart:developer';
import 'package:BBQOUTLETS/AppPages/MyAddresses/MyAddresses.dart';
import 'package:BBQOUTLETS/AppPages/ShippingxxxScreen/BillingxxScreen/ShippingAddress.dart';
import 'package:BBQOUTLETS/Constants/ConstantVariables.dart';
import 'package:BBQOUTLETS/PojoClass/CounterModel.dart';
import 'package:BBQOUTLETS/utils/CartBadgeCounter/CartBadgetLogic.dart';
import 'package:BBQOUTLETS/utils/utils/ApiParams.dart';
import 'package:BBQOUTLETS/utils/utils/build_config.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:provider/src/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ApiCalls {
  static var customerGuid = ConstantsVar.prefs.getString('guestGUID');
  static final String cookie = '.Nop.Customer=' + customerGuid!;
  static final header = {'Cookie': cookie.trim()};
  static final String cartCustomertoken = 'hrxuhddjt1f9rtg45sfuzd5385ztrc6w';

  // static final

  static final headermagentocartdetail = {};

  static Future getCategoryById(
      String id, BuildContext context, int pageIndex) async {
    print('Testing Api');

    final baseUrl = Uri.parse(BuildConfig.base_url +
        'apis/GetProductsByCategoryId?CategoryId=$id&pageindex=$pageIndex&pagesize=16');

    print(baseUrl);

    try {
      ConstantsVar.isVisible = true;
      var response = await http.get(baseUrl, headers: header);

      print(jsonDecode(response.body)['ResponseData']);
      return jsonDecode(response.body);
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  static Future getApiTokken(BuildContext context) async {
    final body = {'email': 'apitest@gmail.com', 'password': '12345'};

    final uri = Uri.parse(BuildConfig.base_url + 'token/GetToken?');
    try {
      var response = await http.post(
        uri,
        body: body,
      );
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var apiTokken = responseData['tokenId'];
        ConstantsVar.prefs = await SharedPreferences.getInstance();
        ConstantsVar.prefs.setString('apiTokken', apiTokken);

        print(responseData);
        return responseData;
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong');
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  static Future forgotPass(
    BuildContext context,
    String email,
  ) async {
    bool? boolean;
    final uri = Uri.parse(BuildConfig.base_url +
        'customer/ForgotPassword?apiToken=${ConstantsVar.apiTokken}&email=$email');

    try {
      var response = await http.get(uri, headers: header);
      print('${jsonDecode(response.body)}');
    } on Exception catch (e) {
      boolean = false;
      ConstantsVar.excecptionMessage(e);
      return boolean;
    }
  }

  static Future getCategory(BuildContext context) async {
    final uri = Uri.parse(BuildConfig.base_url + 'apis/GetCategoryPage');
    try {
      var response = await http.get(uri, headers: header);
      dynamic result = jsonDecode(response.body);
      print(result);
      return result;
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  static Future getHomeScreenCategory() async {
    final uri = Uri.parse(BuildConfig.base_url +
        'apis/GetTopLevelCategories'
            '?apiToken=${ConstantsVar.apiTokken}');
    try {
      var response = await http.get(
        uri,
      );
      switch (response.statusCode) {
        case 200:
          var result = jsonDecode(response.body);
          print(result);
          return result;
        case 400:
          return Fluttertoast.showToast(msg: 'Bad Request to the server');
        case 401:
          break;
        default:
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  static Future getProductData(String productId) async {
    final url = BuildConfig.base_url + 'apis/GetProductModelById?id=$productId';
    print(url);
    try {
      final response = await http.get(Uri.parse(url), headers: header);

      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  static Future showCart(String customerId) async {
    final uri = Uri.parse(BuildConfig.base_url +
        'customer/Cart?apiToken=${ConstantsVar.apiTokken}&CustomerId=$customerId');
    print(uri);
    try {
      var response = await http.get(uri, headers: header);

      var result = jsonDecode(response.body);

      print(result);
      return result;
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);

      ConstantsVar.isCart = true;
    }
  }

  static Future deleteCartItem(
      String customerId, int itemID, BuildContext ctx) async {
    final queryParameters = {
      'apiToken': ConstantsVar.apiTokken,
      'CustomerId': customerId,
      'shoppingCartItemId': itemID.toString(),
    };

    final uri = Uri.https(BuildConfig.base_url_for_apis,
        BuildConfig.remove_cart_item_url, queryParameters);
    print('remove_cart_url>>>> $uri');
    try {
      var response = await http.get(uri, headers: header);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        return result;
      } else {
        Fluttertoast.showToast(
          msg: 'Something went wrong',
        );
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  static Stream<dynamic> cartFun(String customerId) {
    return Stream.periodic(
      Duration(minutes: 1),
    ).asyncMap((event) => showCart(customerId));
  }

  static Future<String> applyCoupon(String apiToken, String customerId,
      String coupon, RefreshController refresh) async {
    ConstantsVar.prefs.setString('discount', coupon);
    String success = '';
    final uri = Uri.parse(BuildConfig.base_url + BuildConfig.apply_coupon_url);

    final body = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID: customerId,
      ApiParams.PARAM_DISCOUNT_COUPON: coupon,
    };

    try {
      var response = await http.post(uri, body: body, headers: header);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print('coupon result>>>> $result');

        Map<String, dynamic> map = json.decode(response.body);

        if (map['status'] == 'Success') {
          List<dynamic> data = map["Message"];
          print(data[0]);

          if (data[0] ==
              'The coupon code you entered couldn\'t be applied to your order') {
            success = 'false';
          } else {
            refresh.requestRefresh(needMove: true);
            success = 'true';
          }
          Fluttertoast.showToast(msg: data[0]);
        } else {
          List<dynamic> data = map["Message"];
          print(data[0]);
          Fluttertoast.showToast(msg: data[0]);
        }
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
    return success;
  }

  static Future<String> removeCoupon(BuildContext context, String apiToken,
      String customerId, String coupon, RefreshController refresh) async {
    String success = '';
    final uri = Uri.parse(BuildConfig.base_url + BuildConfig.remove_coupon_url);

    final body = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID: customerId,
      ApiParams.PARAM_DISCOUNT_COUPON: coupon,
    };
    print(body);
    try {
      var response = await http.post(uri, body: body, headers: header);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print('coupon result>>>> $result');

        Map<String, dynamic> map = json.decode(response.body);
        String couponStats = map['status'];
        String data = map["Message"];
        print(data);

        if (couponStats.contains('Failed')) {
          print(couponStats);
        } else {
          ConstantsVar.prefs.setString('discount', '');
          refresh.requestRefresh(needMove: true);
        }
        success = 'true';
        Fluttertoast.showToast(msg: data);
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
    return success;
  }

  static Future<String> applyGiftCard(
      String apiToken, String customerId, String giftcard) async {
    String success = '';
    final uri = Uri.parse(BuildConfig.base_url + BuildConfig.gift_card_url);

    final body = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID: customerId,
      ApiParams.PARAM_GIFT_COUPON: giftcard,
    };

    try {
      var response = await http.post(uri, body: body, headers: header);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print('gift card result>>>> $result');

        Map<String, dynamic> map = json.decode(response.body);

        if (map['status'] == 'Failed') {
          success = 'false';
        } else {
          success = 'true';
        }

        Fluttertoast.showToast(msg: map['Message']);
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
    return success;
  }

  static Future<String> removeGiftCoupon(String apiToken, String customerId,
      String giftcard, RefreshController refreshController) async {
    String success = '';
    final uri =
        Uri.parse(BuildConfig.base_url + BuildConfig.remove_gift_card_url);

    final body = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID: customerId,
      ApiParams.PARAM_GIFT_COUPON: giftcard,
    };

    try {
      var response = await http.post(uri, body: body, headers: header);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print('remove gift card result>>>> $result');

        Map<String, dynamic> map = json.decode(response.body);

        if (map['status'] == 'Failed') {
          success = 'false';
        } else {
          success = 'true';
          refreshController.requestRefresh(needMove: true);
        }

        Fluttertoast.showToast(msg: map['Message']);
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
    return success;
  }

  static Future allAddresses(
      String apiToken, String customerId, BuildContext ctx) async {
    final uri = Uri.parse(BuildConfig.base_url +
        'apis/GetCustomerAddressList?apiToken=$apiToken&customerid=$customerId');

    print('address url>>> $uri');
    try {
      var response = await http.get(uri, headers: header);
      if (response.statusCode == 200) {
        Map<String, dynamic> result = json.decode(response.body);

        print('addresses>>> $result');
        return result;
      } else {
        Fluttertoast.showToast(
          msg: 'Something went wrong',
        );
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  static Future selectBillingAddress(
      String apiToken, String customerId, String addressId) async {
    final queryParameters = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID: customerId,
      ApiParams.PARAM_ADDRESS_ID: addressId
    };

    final uri = Uri.https(BuildConfig.base_url_for_apis,
        BuildConfig.select_billing_address, queryParameters);

    print('select address url>>> $uri');
    try {
      var response = await http.get(uri, headers: header);
      if (response.statusCode == 200) {
        Map<String, dynamic> result = json.decode(response.body);
        print('selectbillingaddress>>> $result');
        return result;
      } else {
        Fluttertoast.showToast(
          msg: 'Something went wrong',
        );
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  static Future getShippingAddresses(String apiToken, String customerId) async {
    final queryParameters = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID: customerId,
    };

    final uri = Uri.https(BuildConfig.base_url_for_apis,
        BuildConfig.get_shipping_address_url, queryParameters);

    print('shipping>>> $uri');
    try {
      var response = await http.get(uri, headers: header);
      if (response.statusCode == 200) {
        Map<String, dynamic> result = json.decode(response.body);
        print('shippingaddress>>> $result');
        return result;
      } else {
        Fluttertoast.showToast(
          msg: 'Something went wrong',
        );
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  static Future selectShippingAddress(
      String apiToken, String customerid, String addressId) async {
    final queryParameters = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID: customerid,
      ApiParams.PARAM_ADDRESS_ID: addressId,
    };

    final uri = Uri.https(BuildConfig.base_url_for_apis,
        BuildConfig.select_shipping_address_url, queryParameters);

    print('selectshipping>>> $uri');
    try {
      var response = await http.get(uri, headers: header);
      if (response.statusCode == 200) {
        Map<String, dynamic> result = json.decode(response.body);
        print('selectshippingaddress>>> $result');
        return result;
      } else {
        Fluttertoast.showToast(
          msg: 'Something went wrong',
        );
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  static Future showOrderSummary(String apiToken, String customerId) async {
    final queryParameters = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      "CustomerId": customerId,
    };

    final uri = Uri.https(BuildConfig.base_url_for_apis,
        BuildConfig.show_order_summary_url, queryParameters);

    print('Order Summary>>> $uri');
    try {
      var response = await http.get(uri, headers: header);
      if (response.statusCode == 200) {
        Map<String, dynamic> result = json.decode(response.body);
        print('Order Summary result>>> $result');
        return result;
      } else {
        Fluttertoast.showToast(
          msg: 'Something went wrong',
        );
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  static Future updateCart(
      String customerId, String quantity, int itemId, BuildContext ctx) async {
    final uri = Uri.parse(BuildConfig.base_url +
        'apis/UpdateCart?ShoppingCartItemIds=$itemId&Qty=$quantity&CustomerId=$customerId');

    try {
      var response = await http.post(uri, headers: header);
      var result = jsonDecode(response.body);
      print('update cart result>>>> $result');
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  static Future<bool> onWillPop() {
    DateTime currentBackPressTime = DateTime.now();
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Press again to exit');
      return Future.value(false);
    }
    return Future.value(true);
  }

  static launchUrl(String myUrl) async {
    if (await canLaunch(myUrl)) {
      await launch(
        myUrl,
      );
      await launch(
        myUrl,
        forceWebView: true,
        enableDomStorage: true,
      );
    } else {
      Fluttertoast.showToast(msg: 'Cannot launch this $myUrl');
    }
  }

  static Future addNewAddress(BuildContext context, String uriName,
      String apiToken, String customerId, String snippingModel) async {
    final body = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID: customerId,
      'data': snippingModel,
    };

    final uri =
        Uri.parse(BuildConfig.base_url + 'customer/AddCustomerAddress?');
    print(uri);
    try {
      var response = await http.post(uri, body: body, headers: header);
      print(jsonDecode(response.body));

      Navigator.pushReplacement(
          context, CupertinoPageRoute(builder: (context) => MyAddresses()));
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  static Future addBillingORShippingAddress(
      BuildContext context,
      String uriName,
      String apiToken,
      String customerId,
      String snippingModel) async {
    final body = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID: customerId,
      ApiParams.PARAM_SHIPPING: snippingModel,
    };

    final uri =
        Uri.parse(BuildConfig.base_url + 'apis/AddSelectNewBillingAddress?');
    print(uri);
    try {
      var response = await http.post(uri, body: body, headers: header);
      print(jsonDecode(response.body));
      if (uriName == 'MyAccountAddAddress') {
        Navigator.pushReplacement(
            context, CupertinoPageRoute(builder: (context) => MyAddresses()));
      } else {
        Navigator.pushReplacement(context,
            CupertinoPageRoute(builder: (context) => ShippingAddress()));
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  static Future addAndSelectShippingAddress(
      String apiToken, String customerId, String id2) async {
    final uri = Uri.parse(
        BuildConfig.base_url + BuildConfig.add_select_shipping_address_url);
    final snippingModel = jsonEncode({
      'address': {},
      'PickUpInStore': true,
      'pickupPointId': id2,
    });
    final body = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID: customerId,
      'ShippingAddressModel': snippingModel,
    };
    try {
      var resp = await http.post(
        uri,
        body: body,
        headers: header,
      );
      print(jsonDecode(resp.body));
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  static Future readCounter({required BuildContext context}) async {
    int count = 0;
    ConstantsVar.storage = const FlutterSecureStorage();
    String _customerToken =
        await ConstantsVar.storage.read(key: 'customerToken') ?? '';
    print("customer Token :- $_customerToken");
    final uri = Uri.parse(magentoBaseUrl + 'carts/mine/totals');

    try {
      var response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $_customerToken',
        },
      );

      print('Read Counter Response>>>>' + response.body);

      CounterModel model = CounterModel.fromJson(jsonDecode(response.body));
      print("model quantity :- ${model.quantity}");
      count = int.parse(model.quantity);
      context.read<cartCounter>().changeCounter(count);
      /* if (result['ResponseData'] != null &&
          result['status'].contains('success')) {
        count = int.parse(result['ResponseData']);


      } else {
        return count;
      }*/

      return count;
    } on Exception catch (e) {
      return count;

      // ConstantsVar.excecptionMessage(e);
    }
    // return count;
  }

  /* Edit and save address */
  static Future editAndSaveAddress(
      BuildContext context,
      String apiToken,
      String customerId,
      String addressId,
      String data,
      bool isEditAddress) async {
    final body = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID2: customerId,
      ApiParams.PARAM_ADDRESS_ID: addressId,
      ApiParams.PARAM_DATA: data
    };

    final uri =
        Uri.parse(BuildConfig.base_url + BuildConfig.edit_address + "?");
    print(uri);
    try {
      var response = await http.post(uri, body: body, headers: header);
      print(jsonDecode(response.body));
      if (isEditAddress == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyAddresses(),
          ),
        );
      } else {
        Navigator.pop(context);
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  /* Delete address from my account */
  static Future deleteAddress(BuildContext context, String apiToken,
      String customerId, String addressId) async {
    final body = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID: customerId,
      ApiParams.PARAM_ADDRESS_ID2: addressId,
    };

    final uri = Uri.parse(BuildConfig.base_url + BuildConfig.delete_address);
    print(uri);
    try {
      var response = await http.post(uri, body: body, headers: header);

      print(jsonDecode(response.body));
      Fluttertoast.showToast(msg: 'Address deleted');
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  static Future getBillingAddress(
      String apiToken, String customerId, BuildContext ctx) async {
    final queryParameters = {
      ApiParams.PARAM_API_TOKEN: apiToken,
      ApiParams.PARAM_CUSTOMER_ID: customerId,
    };

    final uri = Uri.https(BuildConfig.base_url_for_apis,
        BuildConfig.billing_address, queryParameters);

    print('address url>>> $uri');
    try {
      var response = await http.get(uri, headers: header);
      if (response.statusCode == 200) {
        Map<String, dynamic> result = json.decode(response.body);

        print('addresses>>> $result');
        return result;
      } else {
        Fluttertoast.showToast(
          msg: 'Something went wrong',
        );
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  /*Popular Grills here*/

  static Future<String> getPopularGrills() async {
    final uri = Uri.parse(
        "https://magento-561260-2500518.cloudwaysapps.com/pub/pro1.php");

    log("PopularGrills url :- $uri");
    var response = await get(uri);
    try {
      return response.body;
    } on Exception catch (e) {
      log(e.toString());
      return "Something went wrong";
    }
  }

  static Future<String> getHomeResponse() async {
    final uri = Uri.parse(
        "https://magento-561260-2500518.cloudwaysapps.com/pub/pro2.php");

    log("HomeScreen Response url :- $uri");
    var response = await get(uri);
    try {
      return response.body;
    } on Exception catch (e) {
      log(e.toString());
      return "Something went wrong";
    }
  }
}
