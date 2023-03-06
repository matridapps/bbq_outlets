import 'package:BBQOUTLETS/BBQBuyingGasGrill/widgetClassBBq.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class buyinggasgrill extends StatefulWidget{
  @override
  _buyinggasgri_product createState() =>_buyinggasgri_product();
}

class _buyinggasgri_product extends State<buyinggasgrill> {
  @override
  Widget build(BuildContext context) {
    /*// TODO: implement build
    throw UnimplementedError();*/
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          title: Text("BBQOUTLETS"),
        ),
        body: gasGrilProduct(context),
      ),

    );

  }

}

  Widget gasGrilProduct(BuildContext context) {

   return Container(
     height:100.h,
        child:ListView(
          scrollDirection: Axis.vertical,
            children: [
              Container (
                  child: Row(
                      children: [
                        SizedBox(height: 50,),
                        Container(
                          child: Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 0),
                              child: Image.asset('MyAssets/gas-grill-bbq-bbq1.png'),
                            ),
                          ),
                        ),
                      ]
                  )
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left:10,),
                  child: txtBBqdescription(),
                ),
              ),
              Container(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left:10,top: 10,),
                    child: txtDescriptionTitile(),
                  )
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left:10,top: 10,),
                  child: txtGrillStructure(),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left:10,top: 10,),
                  child: txtGrillStructuredesc(),
                ),
              ),
              Container(
                child: Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 0),
                    child: Image.asset('MyAssets/Built-inGasGrills-gasgrilltwo.png'),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left:10,),
                  child: txtShopBuiltInGas(),
                ),
              ),
              Container(
                child: Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 0),
                    child: Image.asset('MyAssets/freestandingGasGrills.png'),
                  ),
                ),
              ),

              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left:10),
                  child:freeStandingGasGrill(),
                ),
              ),

              Container(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left:10,top: 10,),
                    child: txtDescriptionTitile(),
                  )
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left:10,top: 5),
                  child:txtshopfreeStandingGasGrill(),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 10,top: 5),
                  child:txtFuelTypeNaturalGass(),
                ),
              ),
              Container(
                alignment:Alignment.topLeft,
                child:Padding(
                  padding: EdgeInsets.only(left: 10,top: 5),
                  child:txtfuelDesc(),
                )
              )

            ],
        )
   );

}