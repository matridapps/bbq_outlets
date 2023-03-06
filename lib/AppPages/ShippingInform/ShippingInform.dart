import 'package:BBQOUTLETS/AppPages/HomeScreen/HomeScreen.dart';
import 'package:BBQOUTLETS/AppPages/MagentoAdminApis/ShippingInformation.dart';
import 'package:BBQOUTLETS/Constants/ConstantVariables.dart';
import 'package:BBQOUTLETS/Widgets/CustomButton.dart';
import 'package:BBQOUTLETS/utils/utils/build_config.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class ShippingInform extends StatefulWidget {
  const ShippingInform({
    Key? key,
    required this.shippingInformation,
  }) : super(key: key);
  final ShippingInformationResponse shippingInformation;

  @override
  _ShippingInformState createState() => _ShippingInformState();
}

class _ShippingInformState extends State<ShippingInform> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: ConstantsVar.appColor,
          toolbarHeight: 14.w,
          centerTitle: true,
          title: GestureDetector(
            onTap: () => Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(
                  builder: (context) => MyApp(),
                ),
                (route) => false),
            child: Image.asset(
              logoImage,
              width: 13.w,
              height: 13.w,
            ),
          ),
        ),
        body: Container(
          width: 100.w,
          height: 100.h,
          child: ListView(children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.shippingInformation.paymentMethods.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: AutoSizeText(
                        widget.shippingInformation.paymentMethods[index].title),
                  ),
                );
              },
            ),
            Column(
              children: List.generate(
                  widget.shippingInformation.totals.items.length, (index) {
                return Card(
                  child: Container(
                    height: 30.h,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(right: 8, top: 4),
                                child: AutoSizeText(
                                  widget.shippingInformation.totals.items[index]
                                          .name +
                                      '.',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: CustomTextStyle.textFormFieldSemiBold
                                      .copyWith(fontSize: 16),
                                ),
                              ),
                              Utils.getSizedBox(null, 4),
                              AutoSizeText(
                                "Item Id: ${widget.shippingInformation.totals.items[index].itemId}",
                                style: CustomTextStyle.textFormFieldRegular
                                    .copyWith(color: Colors.grey, fontSize: 15),
                              ),
                              Utils.getSizedBox(null, 4),
                              Container(
                                width: 90.w,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AutoSizeText(
                                      "Regular Price: ${widget.shippingInformation.totals.items[index].basePriceInclTax}",
                                      style: CustomTextStyle
                                          .textFormFieldRegular
                                          .copyWith(
                                              color: Colors.grey, fontSize: 15),
                                    ),
                                    AutoSizeText(
                                      "Tax: ${widget.shippingInformation.totals.items[index].taxPercent} %",
                                      style: CustomTextStyle
                                          .textFormFieldRegular
                                          .copyWith(
                                              color: Colors.grey, fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              Utils.getSizedBox(null, 4),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: AutoSizeText(
                                        'Total Price: ' +
                                            widget.shippingInformation.totals
                                                .items[index].baseRowTotal
                                                .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: CustomTextStyle
                                            .textFormFieldBlack
                                            .copyWith(color: Colors.green),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(width: 5),
                                          Container(
                                            color: Colors.grey.shade200,
                                            padding: const EdgeInsets.only(
                                                bottom: 2, right: 12, left: 12),
                                            child: AutoSizeText(
                                              "${widget.shippingInformation.totals.items[index].qty}",
                                              style: CustomTextStyle
                                                  .textFormFieldSemiBold,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          /*child: InkWell(
                  radius: 36,
                  onTap: () {

                    ApiCalls.deleteCartItem(widget.id, widget.itemId, context)
                        .then((value) {
                      var val = 0;

                      ApiCalls.readCounter(
                              customerGuid:
                                  ConstantsVar.prefs.getString('guestGUID')!)
                          .then((value) {
                        setState(() {
                          val = value;
                        });
                        context.read<cartCounter>().changeCounter(val);
                        widget.reload();
                      });

                      Fluttertoast.showToast(msg: 'Removed from Cart');
                    });
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: 10, top: 8),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        color: Colors.black),
                  ),
                ),*/
                        )
                      ],
                    ),
                  ),
                );
              }),
            )
          ]),
        ),
      ),
    );
  }
}
