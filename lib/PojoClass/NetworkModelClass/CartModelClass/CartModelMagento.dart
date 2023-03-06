// To parse required this JSON data, do
//
//     final CartModelMagentoApi = CartModelMagentoApiFromJson(jsonString);

import 'dart:convert';

// To parse required this JSON data, do
//
//     final CartModelMagentoApi = CartModelMagentoApiFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';

CartModelMagentoApi cartModelMagentoApiFromJson(String str) => CartModelMagentoApi.fromJson(json.decode(str));

String cartModelMagentoApiToJson(CartModelMagentoApi data) => json.encode(data.toJson());

class CartModelMagentoApi {
  CartModelMagentoApi({
    required  this.grandTotal,
    required this.baseGrandTotal,
    required this.subtotal,
    required this.baseSubtotal,
    required this.discountAmount,
    required this.baseDiscountAmount,
    required this.subtotalWithDiscount,
    required this.baseSubtotalWithDiscount,
    required this.shippingAmount,
    required this.baseShippingAmount,
    required this.shippingDiscountAmount,
    required this.baseShippingDiscountAmount,
    required this.taxAmount,
    required this.baseTaxAmount,
    required this.weeeTaxAppliedAmount,
    required this.shippingTaxAmount,
    required this.baseShippingTaxAmount,
    required this.subtotalInclTax,
    required this.shippingInclTax,
    required this.baseShippingInclTax,
    required this.baseCurrencyCode,
    required this.quoteCurrencyCode,
    required this.itemsQty,
    required this.items,
    required this.totalSegments,
  });

  String grandTotal;
  String baseGrandTotal;
  String subtotal;
  String baseSubtotal;
  String discountAmount;
  String baseDiscountAmount;
  String subtotalWithDiscount;
  String baseSubtotalWithDiscount;
  String shippingAmount;
  String baseShippingAmount;
  String shippingDiscountAmount;
  String baseShippingDiscountAmount;
  String taxAmount;
  String baseTaxAmount;
  dynamic weeeTaxAppliedAmount;
  String shippingTaxAmount;
  String baseShippingTaxAmount;
  String subtotalInclTax;
  String shippingInclTax;
  String baseShippingInclTax;
  String baseCurrencyCode;
  String quoteCurrencyCode;
  String itemsQty;
  List<ItemCart> items;
  List<TotalSegment> totalSegments;

  factory CartModelMagentoApi.fromJson(Map<String, dynamic> json) => CartModelMagentoApi(

    grandTotal: json["grand_total"].toString(),
    baseGrandTotal: json["base_grand_total"].toString(),
    subtotal: json["subtotal"].toString(),
    baseSubtotal: json["base_subtotal"].toString(),
    discountAmount: json["discount_amount"].toString(),
    baseDiscountAmount: json["base_discount_amount"].toString(),
    subtotalWithDiscount: json["subtotal_with_discount"].toString(),
    baseSubtotalWithDiscount: json["base_subtotal_with_discount"].toString(),
    shippingAmount: json["shipping_amount"].toString(),
    baseShippingAmount: json["base_shipping_amount"].toString(),
    shippingDiscountAmount: json["shipping_discount_amount"].toString(),
    baseShippingDiscountAmount: json["base_shipping_discount_amount"].toString(),
    taxAmount: json["tax_amount"].toString(),
    baseTaxAmount: json["base_tax_amount"].toString(),
    weeeTaxAppliedAmount: json["weee_tax_applied_amount"].toString(),
    shippingTaxAmount: json["shipping_tax_amount"].toString(),
    baseShippingTaxAmount: json["base_shipping_tax_amount"].toString(),
    subtotalInclTax: json["subtotal_incl_tax"].toString(),
    shippingInclTax: json["shipping_incl_tax"].toString(),
    baseShippingInclTax: json["base_shipping_incl_tax"].toString(),
    baseCurrencyCode: json["base_currency_code"].toString(),
    quoteCurrencyCode: json["quote_currency_code"].toString(),
    itemsQty: json["items_qty"].toString(),
    items: List<ItemCart>.from(json["items"].map((x) => ItemCart.fromJson(x))),
   // items: json["items"]!=null ? new List<ItemCart>.from(json["items"].map((x)=>ItemCart.fromJson(x))) : [ ],
    //  seriesNo: json["series_no"] != null ? new List<SeriesNo>.from( json["series_no"].map((x) => SeriesNo.fromJson(x))) : List<SeriesNo>().
    totalSegments: List<TotalSegment>.from(json["total_segments"].map((x) => TotalSegment.fromJson(x))),
   // totalSegments: json["total_segments"]!=null ? new List<TotalSegment>.from(json["total_segments"].map((x)=>TotalSegment.fromJson(x))) : [ ],

  );

  Map<String, dynamic> toJson() => {
    "grand_total": grandTotal,
    "base_grand_total": baseGrandTotal,
    "subtotal": subtotal,
    "base_subtotal": baseSubtotal,
    "discount_amount": discountAmount,
    "base_discount_amount": baseDiscountAmount,
    "subtotal_with_discount": subtotalWithDiscount,
    "base_subtotal_with_discount": baseSubtotalWithDiscount,
    "shipping_amount": shippingAmount,
    "base_shipping_amount": baseShippingAmount,
    "shipping_discount_amount": shippingDiscountAmount,
    "base_shipping_discount_amount": baseShippingDiscountAmount,
    "tax_amount": taxAmount,
    "base_tax_amount": baseTaxAmount,
    "weee_tax_applied_amount": weeeTaxAppliedAmount,
    "shipping_tax_amount": shippingTaxAmount,
    "base_shipping_tax_amount": baseShippingTaxAmount,
    "subtotal_incl_tax": subtotalInclTax,
    "shipping_incl_tax": shippingInclTax,
    "base_shipping_incl_tax": baseShippingInclTax,
    "base_currency_code": baseCurrencyCode,
    "quote_currency_code": quoteCurrencyCode,
    "items_qty": itemsQty,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "total_segments": List<dynamic>.from(totalSegments.map((x) => x.toJson())),
  };
}

class ItemCart {
  ItemCart({

    required this.itemId,
    required this.price,
    required this.basePrice,
    required this.qty,
    required this.rowTotal,
    required this.baseRowTotal,
    required this.rowTotalWithDiscount,
    required this.taxAmount,
    required this.baseTaxAmount,
    required this.taxPercent,
    required this.discountAmount,
    required this.baseDiscountAmount,
    required this.discountPercent,
    required this.priceInclTax,
    required this.basePriceInclTax,
    required this.rowTotalInclTax,
    required this.baseRowTotalInclTax,
    required this.options,
    required this.weeeTaxAppliedAmount,
    required this.weeeTaxApplied,
    required this.name,

  });

  String itemId;
  String price;
  String basePrice;
  int qty;
  String rowTotal;
  String baseRowTotal;
  String rowTotalWithDiscount;
  String taxAmount;
  String baseTaxAmount;
  String taxPercent;
  String discountAmount;
  String baseDiscountAmount;
  String discountPercent;
  String priceInclTax;
  String basePriceInclTax;
  String rowTotalInclTax;
  String baseRowTotalInclTax;
  String options;
  dynamic weeeTaxAppliedAmount;
  dynamic weeeTaxApplied;
  String name;

  factory ItemCart.fromJson(Map<String, dynamic> json) => ItemCart(
    itemId: json["item_id"].toString(),
    price: json["price"].toString(),
    basePrice: json["base_price"].toString(),
    qty: json["qty"],
    rowTotal: json["row_total"].toString(),
    baseRowTotal: json["base_row_total"].toString(),
    rowTotalWithDiscount: json["row_total_with_discount"].toString(),
    taxAmount: json["tax_amount"].toString(),
    baseTaxAmount: json["base_tax_amount"].toString(),
    taxPercent: json["tax_percent"].toString(),
    discountAmount: json["discount_amount"].toString(),
    baseDiscountAmount: json["base_discount_amount"].toString(),
    discountPercent: json["discount_percent"].toString(),
    priceInclTax: json["price_incl_tax"].toString(),
    basePriceInclTax: json["base_price_incl_tax"].toString(),
    rowTotalInclTax: json["row_total_incl_tax"].toString(),
    baseRowTotalInclTax: json["base_row_total_incl_tax"].toString(),
    options: json["options"].toString(),
    weeeTaxAppliedAmount: json["weee_tax_applied_amount"].toString(),
    weeeTaxApplied: json["weee_tax_applied"].toString(),
    name: json["name"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "item_id": itemId,
    "price": price,
    "base_price": basePrice,
    "qty": qty,
    "row_total": rowTotal,
    "base_row_total": baseRowTotal,
    "row_total_with_discount": rowTotalWithDiscount,
    "tax_amount": taxAmount,
    "base_tax_amount": baseTaxAmount,
    "tax_percent": taxPercent,
    "discount_amount": discountAmount,
    "base_discount_amount": baseDiscountAmount,
    "discount_percent": discountPercent,
    "price_incl_tax": priceInclTax,
    "base_price_incl_tax": basePriceInclTax,
    "row_total_incl_tax": rowTotalInclTax,
    "base_row_total_incl_tax": baseRowTotalInclTax,
    "options": options,
    "weee_tax_applied_amount": weeeTaxAppliedAmount,
    "weee_tax_applied": weeeTaxApplied,
    "name": name,
  };
}

class TotalSegment {
  TotalSegment({
    required this.code,
    required this.title,
    required this.value,
   // required this.extensionAttributes,
   // required this.area,
  });

  String code;
  String title;
  String value;
//  ExtensionAttributes extensionAttributes;
 // String area;

  factory TotalSegment.fromJson(Map<String, dynamic> json) => TotalSegment(
    code: json["code"].toString(),
    title: json["title"].toString(),
    value: json["value"].toString(),
   // extensionAttributes: json["extension_attributes"],
   // area: json["area"] == null ? null : json["area"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "title": title,
    "value": value,
   // "extension_attributes": extensionAttributes == null ? null : extensionAttributes.toJson(),
   // "area": area == null ? null : area,
  };
}

class ExtensionAttributes {
  ExtensionAttributes({
    required this.taxGrandtotalDetails,
  });

  List<TaxGrandtotalDetail> taxGrandtotalDetails;

  factory ExtensionAttributes.fromJson(Map<String, dynamic> json) => ExtensionAttributes(
    taxGrandtotalDetails: List<TaxGrandtotalDetail>.from(json["tax_grandtotal_details"].map((x) => TaxGrandtotalDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "tax_grandtotal_details": List<dynamic>.from(taxGrandtotalDetails.map((x) => x.toJson())),
  };
}

class TaxGrandtotalDetail {
  TaxGrandtotalDetail({
    required this.amount,
    required this.rates,
    required this.groupId,
  });

  String amount;
  List<Rate> rates;
  String groupId;

  factory TaxGrandtotalDetail.fromJson(Map<String, dynamic> json) => TaxGrandtotalDetail(
    amount: json["amount"].toString(),
    rates: List<Rate>.from(json["rates"].map((x) => Rate.fromJson(x))),
    groupId: json["group_id"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "rates": List<dynamic>.from(rates.map((x) => x.toJson())),
    "group_id": groupId,
  };
}

class Rate {
  Rate({
    required this.percent,
    required this.title,
  });

  String percent;
  String title;

  factory Rate.fromJson(Map<String, dynamic> json) => Rate(
    percent: json["percent"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "percent": percent,
    "title": title,
  };

}
