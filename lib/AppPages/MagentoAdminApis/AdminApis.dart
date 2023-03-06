// ignore_for_file: file_names

import 'dart:convert';
import 'dart:developer';

import 'package:BBQOUTLETS/Constants/ConstantVariables.dart';
import 'package:BBQOUTLETS/utils/utils/build_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

import 'category_model.dart';

const String adminTokenUrl =
    'https://magento-561260-2500518.cloudwaysapps.com/rest/V1/integration/admin/token';

class AdminApis {

  static Future getAdminToken({
    required BuildContext context,
  }) async {
    ConstantsVar.isVisible = true;

    final uri = Uri.parse(adminTokenUrl);

    log('$uri');

    final body = jsonEncode({
      "username": "aspdnsf.skin@gmail.com",
      "password": "BeHappyAt007",
    });
    try {
      var response = await post(
        uri,
        body: body,
        headers: {'Content-type': 'application/json'},
      );
      log(response.body);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        log("Admin login Api response data:-" + responseData);
        ConstantsVar.storage = const FlutterSecureStorage();
        ConstantsVar.storage.write(key: "adminToken", value: responseData);

        if (responseData.toString().contains('The credentials provided are incorrect') ||
            responseData.toString().contains('No customer account found')) {
          log('Wrong account');
          Fluttertoast.showToast(
            msg: 'Wrong Details',
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG,
          );
          return false;
        } else if (responseData.toString().contains('Account is not active')) {
          Fluttertoast.showToast(msg: 'Account is not active yet.');
          return false;
        } else if (responseData.toString().contains('Customer is deleted')) {
          Fluttertoast.showToast(msg: 'Customer is deleted');
        } else {
          log('Success');
          return true;
        }
      } else {
        ConstantsVar.showSnackbar(context, 'Unable to get admin token', 5);
        return false;
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      return false;
    }
  }

  static Future showProductDetails(
      {required String productId, required String adminToken}) async {
    String responseString = '';
    log("admin Token :- $adminToken");
    final uri = Uri.parse("https://magento-561260-2500518.cloudwaysapps.com/rest/default/V1/products?searchCriteria[filter_groups][0][filters][0][field]=entity_id& searchCriteria[filter_groups][0][filters][0][value]=$productId&searchCriteria[filter_groups][0][filters][0][condition_type]=eq");
    debugPrint("uri :- ${uri.toString()}");
    final headermagentocartdetail = {'Authorization': 'Bearer $adminToken'};
    var response = await get(uri, headers: headermagentocartdetail);
    try {
      final data = response.body;
      responseString = data;
      debugPrint("Product Details>>>>:-" + response.body);
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      responseString = e.toString();
    }
    return responseString;
  }

  static Future<List<CategoryResposne>> getCategory() async {
    List<CategoryResposne> _list = [];
    final _url = Uri.parse(magentoBaseUrl + 'mma/categories');
    try {
      Response _response = await get(_url);

      if (jsonDecode(_response.body)['message'] != null) {
        Fluttertoast.showToast(
            msg: jsonDecode(_response.body)['message'].toString(),
            toastLength: Toast.LENGTH_LONG);
        _list = [];
      } else {
        ChildrenDatum _data =
            ChildrenDatum.fromJson(jsonDecode(_response.body));
        _list = _data.childrenData;
      }
    } on Exception catch (e) {
      _list = [];
      ConstantsVar.excecptionMessage(e);
    }

    return _list;
  }

  static Future<String> getMegentoProductsbyCatId({
      required String catValue,
      required String pageIndex,
      required String adminToken,
      required pageSize}) async {
    log('AdminToken:- $adminToken');
    final header = <String, String> {
      'Authorization': 'Bearer ' + adminToken,
    };

    final uri = Uri.parse("https://magento-561260-2500518.cloudwaysapps.com/rest/V1/custom/$catValue/products");

    log('ProductListApi Url:- $uri');
    var response = await get(uri, headers: header);
    try {
      log('Response from AdminApis   ${response.body}');
      return response.body;
    } on Exception catch (e) {
      log(e.toString());
      return 'Something went wrong';
    }
  }
}
