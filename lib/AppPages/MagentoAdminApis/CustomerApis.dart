import 'dart:convert';

// import 'package:BBQOUTLETS/AppPages/CustomLoader/CustomDialog/CustomDialog.dart';
import 'package:BBQOUTLETS/AppPages/MagentoAdminApis/MyOrderRespose.dart';
import 'package:BBQOUTLETS/AppPages/MagentoAdminApis/ShippingMethod.dart';

// import 'package:BBQOUTLETS/AppPages/ShippingxxMethodxx/CountryResponseModel.dart';
import 'package:BBQOUTLETS/AppPages/StreamClass/NewPeoductPage/AddToCartResponse/AddToCartResponse.dart';
import 'package:BBQOUTLETS/Constants/ConstantVariables.dart';
import 'package:BBQOUTLETS/PojoClass/NetworkModelClass/CartModelClass/CartModelMagento.dart';
import 'package:BBQOUTLETS/utils/ApiCalls/ApiCalls.dart';
import 'package:BBQOUTLETS/utils/CartBadgeCounter/CartBadgetLogic.dart';
import 'package:BBQOUTLETS/utils/utils/build_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/src/provider.dart';


import 'CustomerDetailsResponse.dart';
import 'ShippingInformation.dart';
import 'StateModel.dart';

const customerTokenUrl = magentoBaseUrl + 'integration/customer/token';
const headermagento = {'Content-type': 'application/json'};

class CustomerApis {
  static Future login({
    required BuildContext context,
    required String email,
    required String password,
    required String screenName,
  }) async {
    print(password);
    CustomProgressDialog progressDialog = CustomProgressDialog(
      context,
      blur: 2,
      dismissable: true,
    );
    progressDialog.setLoadingWidget(const SpinKitPouringHourGlass(
      color: Colors.orangeAccent,
      size: 90,
    ));
    print('email>>>>>' + email + 'Password>>>>>>>>' + password);

    progressDialog.show();

    ConstantsVar.isVisible = true;

    final uri = Uri.parse(customerTokenUrl);

    print(uri);

    final body = jsonEncode({
      "username": email,
      "password": password,
    });
    try {
      var response = await post(
        uri,
        body: body,
        headers: headermagento,
      );
      print(response.body);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print("LoginApi response data:-" + responseData);
        await ConstantsVar.storage.write(key: "customerToken", value: responseData);

        await createCart(customerToken: responseData).whenComplete(() =>
            getCustomerDetails(customerToken: responseData)
                .whenComplete(() => Navigator.pop(context)));
        Fluttertoast.showToast(
          msg: 'Successfully Logged In',
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_LONG,
        );

        progressDialog.dismiss();

        print('Success');

        return true;
      } else {
        progressDialog.dismiss();
        ConstantsVar.showSnackbar(context, 'Unable to login', 5);
        return false;
      }
    } on Exception catch (e) {
      progressDialog.dismiss();

      ConstantsVar.excecptionMessage(e);
      return false;
    }
  }

  static Future showMagentoCart({required String token}) async {
    final uri = Uri.parse(magentoBaseUrl + 'carts/mine/totals');
    late CartModelMagentoApi model;
    final header = {
      'Authorization': 'Bearer $token',
    };
    print(jsonEncode(header));
    try {
      final response = await get(uri, headers: header);
      print('Cart Items>>>>>>> ${response.body}');
      jsonDecode(response.body)['message'] != null
          ? Fluttertoast.showToast(
              msg: jsonDecode(response.body)['message'].toString(),
              toastLength: Toast.LENGTH_LONG)
          : model = CartModelMagentoApi.fromJson(
              jsonDecode(response.body),
            );

      return model;
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      return model;
    }

    return model;
  }

  static Future createCart({required String customerToken}) async {
    final url = Uri.parse(magentoBaseUrl + 'carts/mine');
    print(url);
    final header = <String, String>{
      'Authorization': 'Bearer $customerToken',
    };
    final body = {
      'customerCart': {'id': customerToken}
    };
    try {
      final response = await post(
        url,
        headers: header,
        // body: body,
      );
      print(response.body);
      await ConstantsVar.storage.write(key: 'cartID', value: response.body);
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  static Future addToCart({
    required String cartId,
    required String sku,
    required BuildContext context,
    required String customerToken,
    required String quantity,
  }) async {
    // CustomProgressDialog _progress =
    final uri = Uri.parse(magentoBaseUrl + 'carts/mine/items');
    var _header = {
      'Authorization': 'Bearer ' + customerToken,
      'Content-Type': 'application/json'
    };

    print('header>>>>>>>>>>>' + jsonEncode(_header));

    Map cartItem = {
      "cartItem": {
        "sku": sku,
        "qty": quantity,
        "quote_id": cartId,
      }
    };

    final body = jsonEncode(cartItem);

    print('Add to cart item>>>>>>>>>>' + body);

    try {
      print('Add to Cart Url >>>>' + uri.toString());
      dynamic response = await post(uri, body: body, headers: _header);

      var result1 = jsonDecode(response.body);
      print('Add to cart>>>>>>' + response.body);
      if (result1['message'] ==null) {


          ApiCalls.readCounter(context: context).then(
              (value) => context.read<cartCounter>().changeCounter(value));

          Fluttertoast.showToast(msg: 'Product is added to cart successfully');
          print('noting');


        
      } else {
        Fluttertoast.showToast(msg: result1['message'].toString());
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  static Future getCountryCode({required BuildContext ctx}) async {
    final uri = Uri.parse(magentoBaseUrl + 'directory/countries');

    print('Country Api>>>>>' + uri.toString());
    try {
      var response = await get(
        uri,
      );
      List<dynamic> mList = jsonDecode(response.body);
      List<CountryResponseModel> mCountryList = List<CountryResponseModel>.from(
          mList.map((e) => CountryResponseModel.fromJson(e)).toList());
      print('Country Details>>>>>>' + response.body);
      return mCountryList;
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  static Future getCustomerDetails({
    required String customerToken,
  }) async {
    final url = Uri.parse(magentoBaseUrl + 'customers/me');
    try {
      var response = await get(url, headers: {
        'Authorization': 'Bearer ' + customerToken,
      });
      CustomerDetailsResponse responseResult =
          CustomerDetailsResponse.fromJson(jsonDecode(response.body));
      ConstantsVar.storage
          .write(key: 'customerId', value: responseResult.id.toString());
      ConstantsVar.storage.write(
          key: 'customerFirstName', value: responseResult.firstname.toString());
      ConstantsVar.storage.write(
          key: 'customerLastName', value: responseResult.lastname.toString());
      ConstantsVar.storage
          .write(key: 'customerEmail', value: responseResult.email.toString());
      print('CustomerId>>>>>>>>>>>>' + responseResult.id.toString());
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  static Future getShippingMethod(
      {required String customerToken,
      required Map<String, dynamic> body}) async {
    List<ShippingMethodResponsez> methodList = [];
    final rul =
        Uri.parse(magentoBaseUrl + 'carts/mine/estimate-shipping-methods');
    try {
      var response = await post(rul, body: jsonEncode(body), headers: {
        'Authorization': 'Bearer ' + customerToken,
        'Content-Type': 'application/json'
      });
      print(response.body);
      List<dynamic> _mList = jsonDecode(response.body);
      methodList = List<ShippingMethodResponsez>.from(
          _mList.map((e) => ShippingMethodResponsez.fromJson(e)).toList());
      print(methodList[0].methodTitle);
      return methodList;
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  static Future shippingInformation(
      {required String customerToken,
      required Map<String, dynamic> body}) async {
    late ShippingInformationResponse responsez;
    final url = Uri.parse(magentoBaseUrl + 'carts/mine/shipping-information');
    try {
      var response = await post(url, body: jsonEncode(body), headers: {
        'Authorization': 'Bearer ' + customerToken,
        'Content-Type': 'application/json'
      });
      responsez =
          ShippingInformationResponse.fromJson(jsonDecode(response.body));
      print(response.body);
      return responsez;
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  static Future updateCartItem({
    required BuildContext ctx,
    required String adminToken,
    required String itemId,
    required String cartId,
    required int qty,
  }) async {
    CustomProgressDialog _progress = CustomProgressDialog(
      ctx,
      loadingWidget: SpinKitHourGlass(
        color: ConstantsVar.appColor,
        size: 40,
      ),
    );
    _progress.show();
    Map cartItem = {
      "cartItem": {
        "item_id": itemId,
        "qty": qty,
        "quote_id": cartId,
      }
    };
    final url = Uri.parse(magentoBaseUrl + 'carts/mine/items/$itemId');
    try {
      var response = await put(
        url,
        body: jsonEncode(cartItem),
        headers: {
          'Authorization': 'Bearer ' + adminToken,
          'Content-Type': 'application/json'
        },
      );
      print('updateCart>>>>>' + response.body);
     await ApiCalls.readCounter(context: ctx).then((value) {
        ctx.read<cartCounter>().changeCounter(value);
      });
      _progress.dismiss();
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  static Future deleteCartItem(
      {required String adminToken,
      required String itemId,
      required String cartId,
      required BuildContext ctx,
      required VoidCallback callback}) async {
    CustomProgressDialog _progress = CustomProgressDialog(
      ctx,
      loadingWidget: SpinKitHourGlass(
        color: ConstantsVar.appColor,
        size: 40,
      ),
    );
    _progress.show();
    final url = Uri.parse(magentoBaseUrl + 'carts/$cartId/items/$itemId');
    try {
      var response = await delete(
        url,
        headers: {
          'Authorization': 'Bearer ' + adminToken,
          'Content-Type': 'application/json'
        },
      );
      print('Delete Cart>>>>>' + response.body);
      ApiCalls.readCounter(context: ctx).then((value) {
        ctx.read<cartCounter>().changeCounter(value);
      });
      _progress.dismiss();
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      _progress.dismiss();
    }
  }

  static Future<MyOrdersResponse?> getMyOrder({
    required String emailId,
    required String adminToken,
  }) async {
    MyOrdersResponse? myResponse;
    final url = Uri.parse(magentoBaseUrl +
        'orders?searchCriteria[filter_groups][0][filters][0][field]=customer_email&searchCriteria[filter_groups][0][filters][0][value]=$emailId');

    try {
      var response = await get(
        url,
        headers: {
          'Authorization': 'Bearer ' + adminToken,
          'Content-Type': 'application/json'
        },
      );
      myResponse = MyOrdersResponse.fromJson(jsonDecode(response.body));
      print('My Orders>>>>>' + response.body);
      return myResponse;
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      return myResponse;
    }
  }

  static Future resetPassword(
      {required String customerId,
      required String adminToken,
      required BuildContext ctx,
      required String oldPassword,
      required String newPassword}) async {
    bool isVisible = false;
    CustomProgressDialog progressDialog = CustomProgressDialog(ctx, blur: 10);
    progressDialog.setLoadingWidget(SpinKitPouringHourGlassRefined(
      color: ConstantsVar.appColor,
      size: 40,
    ));
    progressDialog.show();
    final url = Uri.parse(
        magentoBaseUrl + 'customers/me/password?customerId=$customerId');

    try {
      var response = await put(
        url,
        body: jsonEncode({
          'currentPassword': oldPassword,
          'newPassword': newPassword,
        }),
        headers: {
          'Authorization': 'Bearer ' + adminToken,
          'Content-Type': 'application/json'
        },
      );
      var result = jsonDecode(response.body);
      print(result);
      result == true ? isVisible = true : isVisible = false;
      print(isVisible);
      progressDialog.dismiss();
      return isVisible;
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      progressDialog.dismiss();
      return e.toString();
    }
  }

  static Future forgotPassword({
    required BuildContext ctx,
    required String adminToken,
    required String emailId,
  }) async {
    CustomProgressDialog progressDialog = CustomProgressDialog(ctx, blur: 10);
    progressDialog.setLoadingWidget(SpinKitPouringHourGlassRefined(
      color: ConstantsVar.appColor,
      size: 40,
    ));
    progressDialog.show();
    bool isVisible = false;

    final url = Uri.parse(magentoBaseUrl + 'customers/password');
    try {
      var response = await put(
        url,
        body: jsonEncode({
          "email": emailId,
          "template": "email_reset",
          "websiteId": 1,
        }),
        headers: {
          'Authorization': 'Bearer ' + adminToken,
          'Content-Type': 'application/json'
        },
      );
      var result = jsonDecode(response.body);
      print(result);
      result == true ? isVisible = true : isVisible = false;
      print(isVisible);
      progressDialog.dismiss();
      return isVisible;
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      progressDialog.dismiss();

      return e.toString();
    }
  }

  static Future clearUserDetails() async {
    await ConstantsVar.storage.deleteAll();
  }
}
