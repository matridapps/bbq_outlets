// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable, file_names

import 'dart:convert';
import 'package:BBQOUTLETS/AppPages/HomeCategory/HomeCategory.dart';
import 'package:BBQOUTLETS/AppPages/MagentoAdminApis/AdminApis.dart';
import 'package:BBQOUTLETS/AppPages/MagentoAdminApis/CustomerApis.dart';
import 'package:BBQOUTLETS/Constants/ConstantVariables.dart';
import 'package:BBQOUTLETS/utils/ApiCalls/ApiCalls.dart';
import 'package:BBQOUTLETS/utils/ApiCalls/MagentoProduct_api.dart';
import 'package:BBQOUTLETS/utils/CartBadgeCounter/CartBadgetLogic.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_add_to_cart_button/flutter_add_to_cart_button.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'ProductListWidget/ProductListWid.dart';

class ProductList extends StatefulWidget {
  const ProductList({
    Key? key,
    required this.title,
    required this.categoryValue,
    required this.categories,
  }) : super(key: key);

  final title;
  final categoryValue;
  final List<FurtherCategory> categories;

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  AddToCartButtonStateId stateId = AddToCartButtonStateId.idle;
  var customerId;
  int pageIndex = 0;
  var color;
  int productCount = 0;
  List<MagentoBBQProduct> products = [];
  var guestCustomerId;
  String token = '', customerToken = '';
  var cartId;
  var _productError = false;

  @override
  void initState() {
    initShared().whenComplete(() => AdminApis.getMegentoProductsbyCatId(
                catValue: '${widget.categoryValue}',
                pageIndex: pageIndex.toString(),
                adminToken: token,
                pageSize: 10)
            .then((value) {
          log('value :- $value');
          try {
            value.contains('Something went wrong')
                ? setState(() {
                    _productError = true;
                  })
                : setState(() {
                    List<dynamic> _response = jsonDecode(value);

                    products = List<MagentoBBQProduct>.from(
                            _response.map((e) => MagentoBBQProduct.fromJson(e)))
                        .toList();

                    log("products :- ${jsonEncode(products)}");
                  });
          } on Exception catch (e) {
            log(e.toString());
          }
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SafeArea(
        top: true,
        child: Scaffold(
          body: Center(
            child: SpinKitPouringHourGlass(
              color: Colors.orange,
              size: 40,
            ),
          ),
        ),
      );
    } else {
      return SafeArea(
        top: true,
        child: Scaffold(
          body: products.isNotEmpty
              ? _productError == true
                  ? const Center(
                      child: Text('Something went wrong'),
                    )
                  : ProdListWidget(
                      products: products,
                      title: widget.title,
                      productCount: products.length,
                      catId: widget.categoryValue,
                      categoryList: widget.categories,
                      token: token,
                      cartId: cartId,
                      customerToken: customerToken,
                    )
              : const Center(
                  child: AutoSizeText('No Items available'),
                ),
        ),
      );
    }
  }

  Future getId() async {
    setState(() {
      guestCustomerId = ConstantsVar.prefs.getString('guestCustomerID');
    });
  }

  Future initShared() async {
    ConstantsVar.storage = const FlutterSecureStorage();
    token = await ConstantsVar.storage.read(key: 'adminToken') ?? '';
    setState(() {});
  }
}

class AddCartBtn extends StatefulWidget {
  AddCartBtn({
    Key? key,
    required this.sku,
    required this.text,
    required this.isTrue,
    required this.cartId,
    required this.customerToken,
    required this.checkIcon,
    required this.color,
  }) : super(key: key);
  final sku;
  String text;
  bool isTrue;
  final cartId;
  final customerToken;
  Icon checkIcon;
  Color color;

  @override
  _AddCartBtnState createState() => _AddCartBtnState();
}

class _AddCartBtnState extends State<AddCartBtn> {
  late AddToCartButtonStateId stateId;
  var warning;

  @override
  void initState() {
    super.initState();
    stateId = AddToCartButtonStateId.idle;
    getGuid();
  }

  final cartCounte = cartCounter();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      child: AddToCartButton(
        backgroundColor: widget.color,
        stateId: stateId,
        trolley: widget.isTrue == true
            ? const Icon(
                Icons.shopping_cart,
                size: 18,
              )
            : Container(color: Colors.black),
        text: AutoSizeText(
          widget.text,
          style: TextStyle(
            fontSize: 4.w,
          ),
        ),
        check: widget.checkIcon,
        onPressed: (id) => checkStateId(stateId),
      ),
    );
  }

  void checkStateId(AddToCartButtonStateId id) async {
    if (id == AddToCartButtonStateId.idle) {
      if (ConstantsVar.prefs.getInt("subcategories").toString() != '') {
        setState(() {
          stateId = AddToCartButtonStateId.loading;
          CustomerApis.addToCart(
                  customerToken: widget.customerToken,
                  cartId: widget.cartId,
                  sku: widget.sku,
                  context: context,
                  quantity: '1')
              .then((response) {
            setState(() {
              int val = 0;

              ApiCalls.readCounter(context: context).then((value) {
                setState(() {
                  val = value;
                });
                context.read<cartCounter>().changeCounter(val);
              });

              stateId = AddToCartButtonStateId.done;
              Future.delayed(const Duration(seconds: 1), () {
                setState(() {
                  stateId = AddToCartButtonStateId.idle;
                });
              });
            });
          });
        });
      } else {}
    } else if (id == AddToCartButtonStateId.done) {
      setState(() {
        stateId = AddToCartButtonStateId.idle;
      });
    }
  }

  void getGuid() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
  }
}
