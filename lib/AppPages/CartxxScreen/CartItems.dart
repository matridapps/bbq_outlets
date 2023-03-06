// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:BBQOUTLETS/AppPages/MagentoAdminApis/CustomerApis.dart';
import 'package:BBQOUTLETS/PojoClass/NetworkModelClass/CartModelClass/CartModelMagento.dart';
import 'package:BBQOUTLETS/Widgets/CustomButton.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CartItem extends StatefulWidget {
  ItemCart itemCart;
  final String adminToken, cartId;
  RefreshController controller;
  VoidCallback refreshCallback;

  CartItem({
    Key? key,
    required this.itemCart,
    required this.cartId,
    required this.adminToken,
    required this.controller,
    required this.refreshCallback,
  }) : super(key: key);

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> with WidgetsBindingObserver {

  var qty = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    qty = widget.itemCart.qty;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25.h,
      child: Stack(
        children: <Widget>[
          Card(
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(right: 8, top: 4),
                    child: AutoSizeText(
                      widget.itemCart.name + '.',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: CustomTextStyle.textFormFieldSemiBold
                          .copyWith(fontSize: 3.w),
                    ),
                  ),
                  AutoSizeText(
                    "Item Id: ${widget.itemCart.itemId}",
                    style: CustomTextStyle.textFormFieldRegular
                        .copyWith(color: Colors.grey, fontSize: 2.2.w),
                  ),
                  SizedBox(
                    width: 90.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoSizeText(
                          "Regular Price: \$${widget.itemCart.basePriceInclTax}",
                          style: CustomTextStyle.textFormFieldRegular
                              .copyWith(color: Colors.grey, fontSize: 2.2.w),
                        ),
                        AutoSizeText(
                          "Tax: ${widget.itemCart.taxPercent + '%'}",
                          style: CustomTextStyle.textFormFieldRegular
                              .copyWith(color: Colors.grey, fontSize: 2.2.w),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: AutoSizeText(
                          'Total Price: \$' + widget.itemCart.baseRowTotal,
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyle.textFormFieldBlack
                              .copyWith(color: Colors.green),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              radius: 36,
                              onTap: () async {
                                log('SomeOne Tap on Me' + qty.toString());

                                if (qty <= 1) {
                                  MotionToast.info(
                                          description: const Text(
                                              'Item will be deleted from cart'))
                                      .show(context);
                                  await CustomerApis.deleteCartItem(
                                          adminToken: widget.adminToken,
                                          itemId: widget.itemCart.itemId,
                                          cartId: widget.cartId,
                                          callback: widget.refreshCallback,
                                          ctx: context)
                                      .then((value) async =>
                                          widget.refreshCallback())
                                      .then((value) => widget.controller
                                          .refreshCompleted());
                                } else {
                                  setState(() {
                                    qty = qty - 1;

                                    log('${widget.itemCart.qty}');
                                  });
                                  await CustomerApis.updateCartItem(
                                    cartId: widget.cartId,
                                    adminToken: widget.adminToken,
                                    itemId:
                                        widget.itemCart.itemId.toString(),
                                    qty: qty,
                                    ctx: context,
                                  ).then((value) {
                                    widget.refreshCallback();
                                  }).then((value) =>
                                      widget.controller.refreshCompleted());
                                  setState(() {});
                                }
                              },
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius:
                                        BorderRadius.circular(6.0)),
                                child: const Icon(
                                  Icons.remove,
                                  size: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              color: Colors.grey.shade200,
                              padding: const EdgeInsets.only(
                                  bottom: 2, right: 12, left: 12),
                              child: AutoSizeText(
                                "${widget.itemCart.qty}",
                                style:
                                    CustomTextStyle.textFormFieldSemiBold,
                              ),
                            ),
                            const SizedBox(width: 5),
                            InkWell(
                              radius: 36,
                              onTap: () async {
                                log('SomeOne Tap on Me');
                                {
                                  setState(() {
                                    qty = qty + 1;
                                  });

                                  log('$qty');
                                  await CustomerApis.updateCartItem(
                                          cartId: widget.cartId,
                                          adminToken: widget.adminToken,
                                          itemId: widget.itemCart.itemId
                                              .toString(),
                                          qty: qty,
                                          ctx: context)
                                      .then((value) =>
                                          widget.refreshCallback());
                                  log('${widget.itemCart.qty}');
                                  setState(() {});
                                }
                              },
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius:
                                        BorderRadius.circular(6.0)),
                                child: const Icon(
                                  Icons.add,
                                  size: 22,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              radius: 36,
              onTap: () async {
                await CustomerApis.deleteCartItem(
                        adminToken: widget.adminToken,
                        itemId: widget.itemCart.itemId,
                        cartId: widget.cartId,
                        callback: widget.refreshCallback,
                        ctx: context)
                    .then((value) => widget.refreshCallback())
                    .then((value) => widget.controller.refreshCompleted())
                    .then((value) =>
                        Fluttertoast.showToast(msg: 'Removed from Cart'));
              },
              child: Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 2, top: 2),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 25,
                ),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }
}
