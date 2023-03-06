// ignore_for_file: unnecessary_null_comparison, prefer_typing_uninitialized_variables

import 'package:BBQOUTLETS/Constants/ConstantVariables.dart';
import 'package:BBQOUTLETS/utils/CartBadgeCounter/CartBadgetLogic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key, required this.isFromWeb}) : super(key: key);
  final bool isFromWeb;

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> with WidgetsBindingObserver {
  var adminToken;
  var customerEmail;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    getInit().then((value) {
      final orderProvider = Provider.of<cartCounter>(context, listen: false);
      orderProvider.getOrders(
          adminToken: adminToken, customerEmail: customerEmail);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ConstantsVar.appColor,
            toolbarHeight: 14.w,
            centerTitle: true,
            title: InkWell(
              child: Image.asset(
                'BBQ_Images/bbqologomaster.png',
                width: 13.w,
                height: 13.w,
              ),
            ),
          ),
          body: Consumer<cartCounter>(
            builder: (BuildContext context, value, Widget? child) {
              if (value.isLoading == true) {
                return const Center(
                  child: SpinKitPouringHourGlass(
                    color: Colors.orange,
                    size: 60,
                  ),
                );
              } else {
                return Stack(
                  children: [
                    Visibility(
                      child: const Center(
                        child: Text(
                          'There is no data available regarding to your orders.',
                        ),
                      ),
                      visible: value.response != null ? false : true,
                    ),
                    Visibility(
                      visible: value.response.items.isEmpty
                          ? true
                          : false,
                      child: const Center(
                        child: Text(
                          'Nothing  in your orders.',
                        ),
                      ),
                    ),
                    Visibility(
                      visible: value.response.items != null ||
                              value.response.items.isNotEmpty
                          ? true
                          : false,
                      child: ListView(
                        children: [
                          Card(
                            elevation: 10,
                            child: SizedBox(
                              width: 100.w,
                              height: 6.h,
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.orange)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      'My Orders',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 5.w,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: List.generate(
                              value.response.items.length,
                              (_index) => Card(
                                child: Column(
                                  children: [
                                    Card(
                                      elevation: 10,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            Colors.orange)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(
                                                          2.0),
                                                  child: Text(
                                                    'User Information',
                                                    style: GoogleFonts
                                                        .montserrat(
                                                      fontSize: 4.2.w,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.all(8.0),
                                            child: RichText(
                                              text: TextSpan(
                                                text: 'First Name:- ',
                                                style:
                                                    GoogleFonts.montserrat(
                                                        fontSize: 4.w,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.black),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: value
                                                        .response
                                                        .items[_index]
                                                        .customerFirstname,
                                                    style: GoogleFonts
                                                        .montserrat(
                                                      fontSize: 3.6.w,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.all(8.0),
                                            child: RichText(
                                              text: TextSpan(
                                                text: 'Last Name:- ',
                                                style:
                                                    GoogleFonts.montserrat(
                                                        fontSize: 4.w,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.black),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: value
                                                        .response
                                                        .items[_index]
                                                        .customerLastname,
                                                    style: GoogleFonts
                                                        .montserrat(
                                                      fontSize: 3.6.w,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.all(8.0),
                                            child: RichText(
                                              text: TextSpan(
                                                text: 'Email:- ',
                                                style:
                                                    GoogleFonts.montserrat(
                                                        fontSize: 4.w,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.black),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: value
                                                        .response
                                                        .items[_index]
                                                        .customerEmail,
                                                    style: GoogleFonts
                                                        .montserrat(
                                                      fontSize: 3.6.w,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Card(
                                      elevation: 10,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            Colors.orange)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(
                                                          2.0),
                                                  child: Text(
                                                    'Purchase Information',
                                                    style: GoogleFonts
                                                        .montserrat(
                                                      fontSize: 4.2.w,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.all(4.0),
                                            child: RichText(
                                              text: TextSpan(
                                                text: 'Total Price:- \$',
                                                style:
                                                    GoogleFonts.montserrat(
                                                        fontSize: 4.w,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.black),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: value
                                                        .response
                                                        .items[_index]
                                                        .grandTotal
                                                        .toString(),
                                                    style: GoogleFonts
                                                        .montserrat(
                                                      fontSize: 3.6.w,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.all(4.0),
                                            child: RichText(
                                              text: TextSpan(
                                                text: 'Tax:- \$',
                                                style:
                                                    GoogleFonts.montserrat(
                                                        fontSize: 4.w,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.black),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: value
                                                        .response
                                                        .items[_index]
                                                        .taxAmount
                                                        .toString(),
                                                    style: GoogleFonts
                                                        .montserrat(
                                                      fontSize: 3.6.w,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.all(4.0),
                                            child: RichText(
                                              text: TextSpan(
                                                text:
                                                    'Shipping Amount:- \$',
                                                style:
                                                    GoogleFonts.montserrat(
                                                        fontSize: 4.w,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.black),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: value
                                                        .response
                                                        .items[_index]
                                                        .shippingAmount
                                                        .toString(),
                                                    style: GoogleFonts
                                                        .montserrat(
                                                      fontSize: 3.6.w,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.orange)),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.all(3.0),
                                            child: Text(
                                              'Ordered Items',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 4.w,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: List.generate(
                                        value.response.items[_index]
                                            .orderedItems.length,
                                        (index) => Card(
                                          child: ListView(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            children: [
                                              Column(
                                                children: [
                                                  Visibility(
                                                    visible: index == 0
                                                        ? true
                                                        : false,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .all(8.0),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .orange)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3.0),
                                                          child: Text(
                                                            'Order Id #${value.response.items[_index].orderedItems[index].orderId} ',
                                                            style: GoogleFonts
                                                                .montserrat(
                                                              fontSize: 4.w,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets
                                                            .all(8.0),
                                                    child: RichText(
                                                      text: TextSpan(
                                                        text:
                                                            'Sr. Number #  ',
                                                        style: GoogleFonts
                                                            .montserrat(
                                                                fontSize:
                                                                    3.8.w,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .orange),
                                                        children: <
                                                            TextSpan>[
                                                          TextSpan(
                                                            text: (index +
                                                                    1)
                                                                .toString(),
                                                            style: GoogleFonts
                                                                .montserrat(
                                                              fontSize:
                                                                  3.4.w,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .orange,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: RichText(
                                                          text: TextSpan(
                                                            text:
                                                                'Product Name:- ',
                                                            style: GoogleFonts.montserrat(
                                                                fontSize:
                                                                    3.2.w,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                text: value
                                                                    .response
                                                                    .items[
                                                                        _index]
                                                                    .orderedItems[
                                                                        index]
                                                                    .name,
                                                                style: GoogleFonts
                                                                    .montserrat(
                                                                  fontSize:
                                                                      3.w,
                                                                  fontWeight:
                                                                      FontWeight.bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: RichText(
                                                          text: TextSpan(
                                                            text:
                                                                'Product Sku:- ',
                                                            style: GoogleFonts.montserrat(
                                                                fontSize:
                                                                    3.2.w,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                text: value
                                                                    .response
                                                                    .items[
                                                                        _index]
                                                                    .orderedItems[
                                                                        index]
                                                                    .sku,
                                                                style: GoogleFonts
                                                                    .montserrat(
                                                                  fontSize:
                                                                      3.w,
                                                                  fontWeight:
                                                                      FontWeight.bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 100.w,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets.all(4.0),
                                                                  child:
                                                                      RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      text:
                                                                          'Product Id:- ',
                                                                      style: GoogleFonts.montserrat(
                                                                          fontSize: 3.2.w,
                                                                          fontWeight: FontWeight.bold,
                                                                          color: Colors.black),
                                                                      children: <TextSpan>[
                                                                        TextSpan(
                                                                          text: value.response.items[_index].orderedItems[index].itemId.toString(),
                                                                          style: GoogleFonts.montserrat(
                                                                            fontSize: 3.w,
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets.all(4.0),
                                                                  child:
                                                                      RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      text:
                                                                          'Product Quantity:- ',
                                                                      style: GoogleFonts.montserrat(
                                                                          fontSize: 3.2.w,
                                                                          fontWeight: FontWeight.bold,
                                                                          color: Colors.black),
                                                                      children: <TextSpan>[
                                                                        TextSpan(
                                                                          text: value.response.items[_index].orderedItems[index].qtyOrdered.toString(),
                                                                          style: GoogleFonts.montserrat(
                                                                            fontSize: 3.w,
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets.all(4.0),
                                                                  child:
                                                                      RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      text:
                                                                          'Product Price:- \$',
                                                                      style: GoogleFonts.montserrat(
                                                                          fontSize: 3.2.w,
                                                                          fontWeight: FontWeight.bold,
                                                                          color: Colors.black),
                                                                      children: <TextSpan>[
                                                                        TextSpan(
                                                                          text: value.response.items[_index].orderedItems[index].price.toString(),
                                                                          style: GoogleFonts.montserrat(
                                                                            fontSize: 3.w,
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets.all(4.0),
                                                                  child:
                                                                      RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      text:
                                                                          'Tax:- ',
                                                                      style: GoogleFonts.montserrat(
                                                                          fontSize: 3.2.w,
                                                                          fontWeight: FontWeight.bold,
                                                                          color: Colors.black),
                                                                      children: <TextSpan>[
                                                                        TextSpan(
                                                                          text: value.response.items[0].orderedItems[index].taxPercent.toString() + '%',
                                                                          style: GoogleFonts.montserrat(
                                                                            fontSize: 3.w,
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets.all(4.0),
                                                                  child:
                                                                      RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      text:
                                                                          'Applied Tax:- \$',
                                                                      style: GoogleFonts.montserrat(
                                                                          fontSize: 3.2.w,
                                                                          fontWeight: FontWeight.bold,
                                                                          color: Colors.black),
                                                                      children: <TextSpan>[
                                                                        TextSpan(
                                                                          text: value.response.items[_index].orderedItems[index].taxAmount.toString(),
                                                                          style: GoogleFonts.montserrat(
                                                                            fontSize: 3.w,
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Container(
                                                                width: 110,
                                                                height:
                                                                    110,
                                                                color: Colors
                                                                    .orange)
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: RichText(
                                                          text: TextSpan(
                                                            text:
                                                                'Created At:- ',
                                                            style: GoogleFonts.montserrat(
                                                                fontSize:
                                                                    3.2.w,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                text: value
                                                                    .response
                                                                    .items[
                                                                        _index]
                                                                    .orderedItems[
                                                                        index]
                                                                    .createdAt
                                                                    .toIso8601String(),
                                                                style: GoogleFonts
                                                                    .montserrat(
                                                                  fontSize:
                                                                      3.w,
                                                                  fontWeight:
                                                                      FontWeight.bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: RichText(
                                                          text: TextSpan(
                                                            text:
                                                                'Updated At:- ',
                                                            style: GoogleFonts.montserrat(
                                                                fontSize:
                                                                    3.2.w,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                text: value
                                                                    .response
                                                                    .items[
                                                                        _index]
                                                                    .orderedItems[
                                                                        index]
                                                                    .updatedAt
                                                                    .toIso8601String(),
                                                                style: GoogleFonts
                                                                    .montserrat(
                                                                  fontSize:
                                                                      3.w,
                                                                  fontWeight:
                                                                      FontWeight.bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RichText(
                                          text: TextSpan(
                                            text: 'Status: ',
                                            style: GoogleFonts.montserrat(
                                                fontSize: 3.8.w,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.orange),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: value.response
                                                    .items[_index].state
                                                    .toString(),
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 3.4.w,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ));
  }

  Future getInit() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    setState(() {
      adminToken = ConstantsVar.prefs.getString('adminToken');
      customerEmail = ConstantsVar.prefs.getString('customerEmail');
    });
  }
}
