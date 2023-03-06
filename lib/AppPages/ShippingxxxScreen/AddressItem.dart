import 'dart:convert';

import 'package:BBQOUTLETS/AppPages/ShippingxxxScreen/BillingxxScreen/SelectBillingAddressModel/SelectBillAdd.dart';
import 'package:BBQOUTLETS/Constants/ConstantVariables.dart';
import 'package:BBQOUTLETS/Widgets/CustomButton.dart';
import 'package:BBQOUTLETS/utils/ApiCalls/ApiCalls.dart';
import 'package:BBQOUTLETS/utils/utils/general_functions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:nb_utils/nb_utils.dart';


class AddressItem extends StatefulWidget {
  AddressItem(
      {Key? key,
      // required this.isLoading,
      required this.guestId,
      required this.buttonName,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.companyEnabled,
      required this.companyRequired,
      required this.countryEnabled,
      required this.countryId,
      required this.countryName,
      required this.stateProvinceEnabled,
      required this.cityEnabled,
      required this.cityRequired,
      required this.city,
      required this.streetAddressEnabled,
      required this.streetAddressRequired,
      required this.address1,
      required this.streetAddress2Enabled,
      required this.streetAddress2Required,
      required this.zipPostalCodeEnabled,
      required this.zipPostalCodeRequired,
      required this.zipPostalCode,
      required this.phoneEnabled,
      required this.phoneRequired,
      required this.phoneNumber,
      required this.faxEnabled,
      required this.faxRequired,
      required this.faxNumber,
      required this.id,
      required this.callback})
      : super(key: key);

  String buttonName;
  String firstName;
  String lastName;
  String email;
  bool companyEnabled;
  bool companyRequired;
  bool countryEnabled;
  int countryId;
  String countryName;
  bool stateProvinceEnabled;
  bool cityEnabled;
  bool cityRequired;
  String city;
  bool streetAddressEnabled;
  bool streetAddressRequired;
  String address1;
  bool streetAddress2Enabled;
  bool streetAddress2Required;
  bool zipPostalCodeEnabled;
  bool zipPostalCodeRequired;
  dynamic zipPostalCode;
  bool phoneEnabled;
  bool phoneRequired;
  String phoneNumber;
  bool faxEnabled;
  bool faxRequired;
  dynamic faxNumber;
  int id;
  String guestId;
  ValueChanged<String> callback;

  // var
  @override
  _AddressItemState createState() => _AddressItemState();
}

class _AddressItemState extends State<AddressItem> {
  var guestId;
  var addressJsonString;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGuestCustomer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white,
        child: Container(
          height: 25.h,
          margin: EdgeInsets.only(
            left: 10,
            right: 10,
            bottom: 3.2,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  // padding: const EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(right: 8, top: 4),
                        child: AutoSizeText(
                          widget.firstName + ' ' + widget.lastName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: CustomTextStyle.textFormFieldBold
                              .copyWith(fontSize: 16),
                        ),
                      ),
                      Utils.getSizedBox(null, 6),
                      Container(child: AutoSizeText('Email - ' + widget.email)),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: AutoSizeText(
                                'Address -' + widget.address1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          child: AutoSizeText(
                              'Phone -' + ' ' + widget.phoneNumber)),
                      Container(
                          child: AutoSizeText(
                              'Country -' + ' ' + widget.countryName)),
                      addVerticalSpace(12),
                      GestureDetector(
                        onTap: () async {
                          print('button bill clicked');
                          if (widget.buttonName.contains('Bill')) {


                            ApiCalls.selectBillingAddress(
                                    ConstantsVar.apiTokken.toString(),
                                    '$guestId',
                                    widget.id.toString())
                                .then((value) {
                              ConstantsVar.prefs
                                  .setString('addressJsonString', '');
                              // Fluttertoast.showToast(msg: '$value');
                              SelectBillingAddress map =
                                  SelectBillingAddress.fromJson(value);
                              // String
                              if (map.error == null) {
                                //means no error..


                                var fName =
                                    map.selectedaddress.firstName.toString();
                                var lName =
                                    map.selectedaddress.lastName.toString();
                                var email =
                                    map.selectedaddress.email.toString();
                                var company =
                                    map.selectedaddress.company.toString();
                                var countryId =
                                    map.selectedaddress.countryId.toString();
                                var city = map.selectedaddress.city.toString();
                                var stateProvincId = 12;
                                var address1 =
                                    map.selectedaddress.address1.toString();
                                var address2 =
                                    map.selectedaddress.address2.toString();
                                var postalCode = map
                                    .selectedaddress.zipPostalCode
                                    .toString();
                                var phoneNumner =
                                    map.selectedaddress.phoneNumber.toString();
                                var faxNumber =
                                    map.selectedaddress.faxNumber.toString();

                                Map<String, dynamic> addressBody = {
                                  'FirstName': fName,
                                  'LastName': lName,
                                  'Email': email,
                                  'Company': company,
                                  'CountryId': countryId,
                                  'StateProvinceId': stateProvincId,
                                  'City': city,
                                  'Address1': address1,
                                  'Address2': address2,
                                  'ZipPostalCode': postalCode,
                                  'PhoneNumber': phoneNumner,
                                  'FaxNumber': faxNumber,
                                };

                                addressJsonString = jsonEncode(addressBody);
                                ConstantsVar.prefs
                                    .setString(
                                        'addressJsonString', addressJsonString)
                                    .whenComplete(() => null);
                              } else {
                                Fluttertoast.showToast(
                                    msg: map.error.toString());
                              }
                            });
                          } else {
                            //Means shipping button is clicked on shipping screen


                            ApiCalls.selectShippingAddress(
                                    ConstantsVar.apiTokken.toString(),
                                    widget.guestId,
                                    widget.id.toString())
                                .then((value) {
                              print('$value');


                              // Navigator.pushReplacement(
                              //     context,
                              //     CupertinoPageRoute(
                              //       builder: (context) => ShippingMethod(
                              //         customerId: widget.guestId,
                              //         paymentUrl: paymentUrl,
                              //         // paymentUrl: paymentUrl),
                              //       ),
                              //     ));

                            });
                          }
                        },
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                              child: AutoSizeText(
                            widget.buttonName,
                            style: TextStyle(
                                fontSize: 4.w,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                          decoration: BoxDecoration(
                              color: ConstantsVar.appColor,
                              borderRadius: BorderRadius.circular(4.0)),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getGuestCustomer() async {
    guestId = ConstantsVar.prefs.getString('guestCustomerID');
  }
}
