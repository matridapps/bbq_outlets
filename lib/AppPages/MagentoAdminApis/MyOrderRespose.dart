// To parse this JSON data, do
//
//     final myOrdersResponse = myOrdersResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

MyOrdersResponse myOrdersResponseFromJson(String str) => MyOrdersResponse.fromJson(json.decode(str));

String myOrdersResponseToJson(MyOrdersResponse data) => json.encode(data.toJson());

class MyOrdersResponse {
  MyOrdersResponse({
    required this.items,
    // required this.searchCriteria,
    required this.totalCount,
  });

  List<MyOrdersResponseItem> items;
  // SearchCriteria searchCriteria;
  int totalCount;

  factory MyOrdersResponse.fromJson(Map<String, dynamic> json) => MyOrdersResponse(
    items: List<MyOrdersResponseItem>.from(json["items"].map((x) => MyOrdersResponseItem.fromJson(x))),
    // searchCriteria: SearchCriteria.fromJson(json["search_criteria"]),
    totalCount: json["total_count"],
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    // "search_criteria": searchCriteria.toJson(),
    "total_count": totalCount,
  };
}

class MyOrdersResponseItem {
  MyOrdersResponseItem({
    required this.baseCurrencyCode,
    required this.baseDiscountAmount,
    required this.baseGrandTotal,
    required this.baseDiscountTaxCompensationAmount,
    required this.baseShippingAmount,
    required this.baseShippingDiscountAmount,
    required this.baseShippingDiscountTaxCompensationAmnt,
    required this.baseShippingInclTax,
    required this.baseShippingTaxAmount,
    required this.baseSubtotal,
    required this.baseSubtotalInclTax,
    required this.baseTaxAmount,
    required this.baseTotalDue,
    required this.baseToGlobalRate,
    required this.baseToOrderRate,
    required this.billingAddressId,
    required this.createdAt,
    required this.customerEmail,
    required this.customerFirstname,
    required this.customerGroupId,
    required this.customerId,
    required this.customerIsGuest,
    required this.customerLastname,
    required this.customerNoteNotify,
    required this.discountAmount,
    required this.emailSent,
    required this.entityId,
    required this.globalCurrencyCode,
    required this.grandTotal,
    required this.discountTaxCompensationAmount,
    required this.incrementId,
    required this.isVirtual,
    required this.orderCurrencyCode,
    required this.protectCode,
    required this.quoteId,
    required this.remoteIp,
    required this.shippingAmount,
    required this.shippingDescription,
    required this.shippingDiscountAmount,
    required this.shippingDiscountTaxCompensationAmount,
    required this.shippingInclTax,
    required this.shippingTaxAmount,
    required this.state,
    required this.status,
    required this.storeCurrencyCode,
    required this.storeId,
    required this.storeName,
    required this.storeToBaseRate,
    required this.storeToOrderRate,
    required this.subtotal,
    required this.subtotalInclTax,
    required this.taxAmount,
    required this.totalDue,
    required this.totalItemCount,
    required this.totalQtyOrdered,
    required this.updatedAt,
    required this.weight,
    required this.xForwardedFor,
    required this.orderedItems,
    required this.billingAddress,
    required this.payment,
    required this.statusHistories,
    required this.extensionAttributes,
  });

  String baseCurrencyCode;
  int baseDiscountAmount;
  double baseGrandTotal;
  int baseDiscountTaxCompensationAmount;
  int baseShippingAmount;
  int baseShippingDiscountAmount;
  int baseShippingDiscountTaxCompensationAmnt;
  int baseShippingInclTax;
  int baseShippingTaxAmount;
  double baseSubtotal;
  double baseSubtotalInclTax;
  int baseTaxAmount;
  double baseTotalDue;
  int baseToGlobalRate;
  int baseToOrderRate;
  int billingAddressId;
  DateTime createdAt;
  String customerEmail;
  String customerFirstname;
  int customerGroupId;
  int customerId;
  int customerIsGuest;
  String customerLastname;
  int customerNoteNotify;
  int discountAmount;
  int emailSent;
  int entityId;
  String globalCurrencyCode;
  double grandTotal;
  int discountTaxCompensationAmount;
  String incrementId;
  int isVirtual;
  String orderCurrencyCode;
  String protectCode;
  int quoteId;
  String remoteIp;
  int shippingAmount;
  String shippingDescription;
  int shippingDiscountAmount;
  int shippingDiscountTaxCompensationAmount;
  int shippingInclTax;
  int shippingTaxAmount;
  String state;
  String status;
  String storeCurrencyCode;
  int storeId;
  String storeName;
  int storeToBaseRate;
  int storeToOrderRate;
  double subtotal;
  double subtotalInclTax;
  int taxAmount;
  double totalDue;
  int totalItemCount;
  int totalQtyOrdered;
  DateTime updatedAt;
  int weight;
  String xForwardedFor;
  List<ShippingAssignmentItem> orderedItems;
  Address billingAddress;
  Payment payment;
  List<dynamic> statusHistories;
  ExtensionAttributes extensionAttributes;

  factory MyOrdersResponseItem.fromJson(Map<String, dynamic> json) => MyOrdersResponseItem(
    baseCurrencyCode: json["base_currency_code"],
    baseDiscountAmount: json["base_discount_amount"],
    baseGrandTotal: json["base_grand_total"].toDouble(),
    baseDiscountTaxCompensationAmount: json["base_discount_tax_compensation_amount"],
    baseShippingAmount: json["base_shipping_amount"],
    baseShippingDiscountAmount: json["base_shipping_discount_amount"],
    baseShippingDiscountTaxCompensationAmnt: json["base_shipping_discount_tax_compensation_amnt"],
    baseShippingInclTax: json["base_shipping_incl_tax"],
    baseShippingTaxAmount: json["base_shipping_tax_amount"],
    baseSubtotal: json["base_subtotal"].toDouble(),
    baseSubtotalInclTax: json["base_subtotal_incl_tax"].toDouble(),
    baseTaxAmount: json["base_tax_amount"],
    baseTotalDue: json["base_total_due"].toDouble(),
    baseToGlobalRate: json["base_to_global_rate"],
    baseToOrderRate: json["base_to_order_rate"],
    billingAddressId: json["billing_address_id"],
    createdAt: DateTime.parse(json["created_at"]),
    customerEmail: json["customer_email"],
    customerFirstname: json["customer_firstname"],
    customerGroupId: json["customer_group_id"],
    customerId: json["customer_id"],
    customerIsGuest: json["customer_is_guest"],
    customerLastname: json["customer_lastname"],
    customerNoteNotify: json["customer_note_notify"],
    discountAmount: json["discount_amount"],
    emailSent: json["email_sent"],
    entityId: json["entity_id"],
    globalCurrencyCode: json["global_currency_code"],
    grandTotal: json["grand_total"].toDouble(),
    discountTaxCompensationAmount: json["discount_tax_compensation_amount"],
    incrementId: json["increment_id"],
    isVirtual: json["is_virtual"],
    orderCurrencyCode: json["order_currency_code"],
    protectCode: json["protect_code"],
    quoteId: json["quote_id"],
    remoteIp: json["remote_ip"],
    shippingAmount: json["shipping_amount"],
    shippingDescription: json["shipping_description"],
    shippingDiscountAmount: json["shipping_discount_amount"],
    shippingDiscountTaxCompensationAmount: json["shipping_discount_tax_compensation_amount"],
    shippingInclTax: json["shipping_incl_tax"],
    shippingTaxAmount: json["shipping_tax_amount"],
    state: json["state"],
    status: json["status"],
    storeCurrencyCode: json["store_currency_code"],
    storeId: json["store_id"],
    storeName: json["store_name"],
    storeToBaseRate: json["store_to_base_rate"],
    storeToOrderRate: json["store_to_order_rate"],
    subtotal: json["subtotal"].toDouble(),
    subtotalInclTax: json["subtotal_incl_tax"].toDouble(),
    taxAmount: json["tax_amount"],
    totalDue: json["total_due"].toDouble(),
    totalItemCount: json["total_item_count"],
    totalQtyOrdered: json["total_qty_ordered"],
    updatedAt: DateTime.parse(json["updated_at"]),
    weight: json["weight"],
    xForwardedFor: json["x_forwarded_for"],
    orderedItems: List<ShippingAssignmentItem>.from(json["items"].map((x) => ShippingAssignmentItem.fromJson(x))),
    billingAddress: Address.fromJson(json["billing_address"]),
    payment: Payment.fromJson(json["payment"]),
    statusHistories: List<dynamic>.from(json["status_histories"].map((x) => x)),
    extensionAttributes: ExtensionAttributes.fromJson(json["extension_attributes"]),
  );

  Map<String, dynamic> toJson() => {
    "base_currency_code": baseCurrencyCode,
    "base_discount_amount": baseDiscountAmount,
    "base_grand_total": baseGrandTotal,
    "base_discount_tax_compensation_amount": baseDiscountTaxCompensationAmount,
    "base_shipping_amount": baseShippingAmount,
    "base_shipping_discount_amount": baseShippingDiscountAmount,
    "base_shipping_discount_tax_compensation_amnt": baseShippingDiscountTaxCompensationAmnt,
    "base_shipping_incl_tax": baseShippingInclTax,
    "base_shipping_tax_amount": baseShippingTaxAmount,
    "base_subtotal": baseSubtotal,
    "base_subtotal_incl_tax": baseSubtotalInclTax,
    "base_tax_amount": baseTaxAmount,
    "base_total_due": baseTotalDue,
    "base_to_global_rate": baseToGlobalRate,
    "base_to_order_rate": baseToOrderRate,
    "billing_address_id": billingAddressId,
    "created_at": createdAt.toIso8601String(),
    "customer_email": customerEmail,
    "customer_firstname": customerFirstname,
    "customer_group_id": customerGroupId,
    "customer_id": customerId,
    "customer_is_guest": customerIsGuest,
    "customer_lastname": customerLastname,
    "customer_note_notify": customerNoteNotify,
    "discount_amount": discountAmount,
    "email_sent": emailSent,
    "entity_id": entityId,
    "global_currency_code": globalCurrencyCode,
    "grand_total": grandTotal,
    "discount_tax_compensation_amount": discountTaxCompensationAmount,
    "increment_id": incrementId,
    "is_virtual": isVirtual,
    "order_currency_code": orderCurrencyCode,
    "protect_code": protectCode,
    "quote_id": quoteId,
    "remote_ip": remoteIp,
    "shipping_amount": shippingAmount,
    "shipping_description": shippingDescription,
    "shipping_discount_amount": shippingDiscountAmount,
    "shipping_discount_tax_compensation_amount": shippingDiscountTaxCompensationAmount,
    "shipping_incl_tax": shippingInclTax,
    "shipping_tax_amount": shippingTaxAmount,
    "state": state,
    "status": status,
    "store_currency_code": storeCurrencyCode,
    "store_id": storeId,
    "store_name": storeName,
    "store_to_base_rate": storeToBaseRate,
    "store_to_order_rate": storeToOrderRate,
    "subtotal": subtotal,
    "subtotal_incl_tax": subtotalInclTax,
    "tax_amount": taxAmount,
    "total_due": totalDue,
    "total_item_count": totalItemCount,
    "total_qty_ordered": totalQtyOrdered,
    "updated_at": updatedAt.toIso8601String(),
    "weight": weight,
    "x_forwarded_for": xForwardedFor,
    "items": List<dynamic>.from(orderedItems.map((x) => x.toJson())),
    "billing_address": billingAddress.toJson(),
    "payment": payment.toJson(),
    "status_histories": List<dynamic>.from(statusHistories.map((x) => x)),
    "extension_attributes": extensionAttributes.toJson(),
  };
}

class Address {
  Address({
    required this.addressType,
    required this.city,
    required this.countryId,
    required this.email,
    required this.entityId,
    required this.firstname,
    required this.lastname,
    required this.parentId,
    required this.postcode,
    required this.region,
    required this.regionCode,
    required this.regionId,
    required this.street,
    required this.telephone,
    required this.customerAddressId,
  });

  String addressType;
  String city;
  String countryId;
  String email;
  int entityId;
  String firstname;
  String lastname;
  int parentId;
  String postcode;
  String region;
  String regionCode;
  int regionId;
  List<String> street;
  String telephone;
  int customerAddressId;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    addressType: json["address_type"],
    city: json["city"],
    countryId: json["country_id"],
    email: json["email"],
    entityId: json["entity_id"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    parentId: json["parent_id"],
    postcode: json["postcode"],
    region: json["region"],
    regionCode: json["region_code"],
    regionId: json["region_id"],
    street: List<String>.from(json["street"].map((x) => x)),
    telephone: json["telephone"],
    customerAddressId: json["customer_address_id"] == null ? null : json["customer_address_id"],
  );

  Map<String, dynamic> toJson() => {
    "address_type": addressType,
    "city": city,
    "country_id": countryId,
    "email": email,
    "entity_id": entityId,
    "firstname": firstname,
    "lastname": lastname,
    "parent_id": parentId,
    "postcode": postcode,
    "region": region,
    "region_code": regionCode,
    "region_id": regionId,
    "street": List<dynamic>.from(street.map((x) => x)),
    "telephone": telephone,
    "customer_address_id": customerAddressId == null ? null : customerAddressId,
  };
}

class ExtensionAttributes {
  ExtensionAttributes({
    required this.shippingAssignments,
    required this.paymentAdditionalInfo,
    required this.appliedTaxes,
    required this.itemAppliedTaxes,
  });

  List<ShippingAssignment> shippingAssignments;
  List<PaymentAdditionalInfo> paymentAdditionalInfo;
  List<dynamic> appliedTaxes;
  List<dynamic> itemAppliedTaxes;

  factory ExtensionAttributes.fromJson(Map<String, dynamic> json) => ExtensionAttributes(
    shippingAssignments: List<ShippingAssignment>.from(json["shipping_assignments"].map((x) => ShippingAssignment.fromJson(x))),
    paymentAdditionalInfo: List<PaymentAdditionalInfo>.from(json["payment_additional_info"].map((x) => PaymentAdditionalInfo.fromJson(x))),
    appliedTaxes: List<dynamic>.from(json["applied_taxes"].map((x) => x)),
    itemAppliedTaxes: List<dynamic>.from(json["item_applied_taxes"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "shipping_assignments": List<dynamic>.from(shippingAssignments.map((x) => x.toJson())),
    "payment_additional_info": List<dynamic>.from(paymentAdditionalInfo.map((x) => x.toJson())),
    "applied_taxes": List<dynamic>.from(appliedTaxes.map((x) => x)),
    "item_applied_taxes": List<dynamic>.from(itemAppliedTaxes.map((x) => x)),
  };
}

class PaymentAdditionalInfo {
  PaymentAdditionalInfo({
    required this.key,
    required this.value,
  });

  String key;
  String value;

  factory PaymentAdditionalInfo.fromJson(Map<String, dynamic> json) => PaymentAdditionalInfo(
    key: json["key"],
    value: json["value"] == null?'':json["value"],
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "value": value,
  };
}

class ShippingAssignment {
  ShippingAssignment({
    required this.shipping,
    required this.items,
  });

  Shipping shipping;
  List<ShippingAssignmentItem> items;

  factory ShippingAssignment.fromJson(Map<String, dynamic> json) => ShippingAssignment(
    shipping: Shipping.fromJson(json["shipping"]),
    items: List<ShippingAssignmentItem>.from(json["items"].map((x) => ShippingAssignmentItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "shipping": shipping.toJson(),
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class ShippingAssignmentItem {
  ShippingAssignmentItem({
    required this.amountRefunded,
    required this.baseAmountRefunded,
    required this.baseDiscountAmount,
    required this.baseDiscountInvoiced,
    required this.baseDiscountTaxCompensationAmount,
    required this.baseOriginalPrice,
    required this.basePrice,
    required this.basePriceInclTax,
    required this.baseRowInvoiced,
    required this.baseRowTotal,
    required this.baseRowTotalInclTax,
    required this.baseTaxAmount,
    required this.baseTaxInvoiced,
    required this.createdAt,
    required this.discountAmount,
    required this.discountInvoiced,
    required this.discountPercent,
    required this.freeShipping,
    required this.discountTaxCompensationAmount,
    required this.isQtyDecimal,
    required this.isVirtual,
    required this.itemId,
    required this.name,
    required this.noDiscount,
    required this.orderId,
    required this.originalPrice,
    required this.price,
    required this.priceInclTax,
    required this.productId,
    required this.productType,
    required this.qtyCanceled,
    required this.qtyInvoiced,
    required this.qtyOrdered,
    required this.qtyRefunded,
    required this.qtyShipped,
    required this.quoteItemId,
    required this.rowInvoiced,
    required this.rowTotal,
    required this.rowTotalInclTax,
    required this.rowWeight,
    required this.sku,
    required this.storeId,
    required this.taxAmount,
    required this.taxInvoiced,
    required this.taxPercent,
    required this.updatedAt,
    required this.weight,
  });

  int amountRefunded;
  int baseAmountRefunded;
  int baseDiscountAmount;
  int baseDiscountInvoiced;
  int baseDiscountTaxCompensationAmount;
  double baseOriginalPrice;
  double basePrice;
  double basePriceInclTax;
  int baseRowInvoiced;
  double baseRowTotal;
  double baseRowTotalInclTax;
  int baseTaxAmount;
  int baseTaxInvoiced;
  DateTime createdAt;
  int discountAmount;
  int discountInvoiced;
  int discountPercent;
  int freeShipping;
  int discountTaxCompensationAmount;
  int isQtyDecimal;
  int isVirtual;
  int itemId;
  String name;
  int noDiscount;
  int orderId;
  double originalPrice;
  double price;
  double priceInclTax;
  int productId;
  String productType;
  int qtyCanceled;
  int qtyInvoiced;
  int qtyOrdered;
  int qtyRefunded;
  int qtyShipped;
  int quoteItemId;
  int rowInvoiced;
  double rowTotal;
  double rowTotalInclTax;
  int rowWeight;
  String sku;
  int storeId;
  int taxAmount;
  int taxInvoiced;
  int taxPercent;
  DateTime updatedAt;
  int weight;

  factory ShippingAssignmentItem.fromJson(Map<String, dynamic> json) => ShippingAssignmentItem(
    amountRefunded: json["amount_refunded"],
    baseAmountRefunded: json["base_amount_refunded"],
    baseDiscountAmount: json["base_discount_amount"],
    baseDiscountInvoiced: json["base_discount_invoiced"],
    baseDiscountTaxCompensationAmount: json["base_discount_tax_compensation_amount"],
    baseOriginalPrice: json["base_original_price"].toDouble(),
    basePrice: json["base_price"].toDouble(),
    basePriceInclTax: json["base_price_incl_tax"].toDouble(),
    baseRowInvoiced: json["base_row_invoiced"],
    baseRowTotal: json["base_row_total"].toDouble(),
    baseRowTotalInclTax: json["base_row_total_incl_tax"].toDouble(),
    baseTaxAmount: json["base_tax_amount"],
    baseTaxInvoiced: json["base_tax_invoiced"],
    createdAt: DateTime.parse(json["created_at"]),
    discountAmount: json["discount_amount"],
    discountInvoiced: json["discount_invoiced"],
    discountPercent: json["discount_percent"],
    freeShipping: json["free_shipping"],
    discountTaxCompensationAmount: json["discount_tax_compensation_amount"],
    isQtyDecimal: json["is_qty_decimal"],
    isVirtual: json["is_virtual"],
    itemId: json["item_id"],
    name: json["name"],
    noDiscount: json["no_discount"],
    orderId: json["order_id"],
    originalPrice: json["original_price"].toDouble(),
    price: json["price"].toDouble(),
    priceInclTax: json["price_incl_tax"].toDouble(),
    productId: json["product_id"],
    productType: json["product_type"],
    qtyCanceled: json["qty_canceled"],
    qtyInvoiced: json["qty_invoiced"],
    qtyOrdered: json["qty_ordered"],
    qtyRefunded: json["qty_refunded"],
    qtyShipped: json["qty_shipped"],
    quoteItemId: json["quote_item_id"],
    rowInvoiced: json["row_invoiced"],
    rowTotal: json["row_total"].toDouble(),
    rowTotalInclTax: json["row_total_incl_tax"].toDouble(),
    rowWeight: json["row_weight"],
    sku: json["sku"],
    storeId: json["store_id"],
    taxAmount: json["tax_amount"],
    taxInvoiced: json["tax_invoiced"],
    taxPercent: json["tax_percent"],
    updatedAt: DateTime.parse(json["updated_at"]),
    weight: json["weight"],
  );

  Map<String, dynamic> toJson() => {
    "amount_refunded": amountRefunded,
    "base_amount_refunded": baseAmountRefunded,
    "base_discount_amount": baseDiscountAmount,
    "base_discount_invoiced": baseDiscountInvoiced,
    "base_discount_tax_compensation_amount": baseDiscountTaxCompensationAmount,
    "base_original_price": baseOriginalPrice,
    "base_price": basePrice,
    "base_price_incl_tax": basePriceInclTax,
    "base_row_invoiced": baseRowInvoiced,
    "base_row_total": baseRowTotal,
    "base_row_total_incl_tax": baseRowTotalInclTax,
    "base_tax_amount": baseTaxAmount,
    "base_tax_invoiced": baseTaxInvoiced,
    "created_at": createdAt.toIso8601String(),
    "discount_amount": discountAmount,
    "discount_invoiced": discountInvoiced,
    "discount_percent": discountPercent,
    "free_shipping": freeShipping,
    "discount_tax_compensation_amount": discountTaxCompensationAmount,
    "is_qty_decimal": isQtyDecimal,
    "is_virtual": isVirtual,
    "item_id": itemId,
    "name": name,
    "no_discount": noDiscount,
    "order_id": orderId,
    "original_price": originalPrice,
    "price": price,
    "price_incl_tax": priceInclTax,
    "product_id": productId,
    "product_type": productType,
    "qty_canceled": qtyCanceled,
    "qty_invoiced": qtyInvoiced,
    "qty_ordered": qtyOrdered,
    "qty_refunded": qtyRefunded,
    "qty_shipped": qtyShipped,
    "quote_item_id": quoteItemId,
    "row_invoiced": rowInvoiced,
    "row_total": rowTotal,
    "row_total_incl_tax": rowTotalInclTax,
    "row_weight": rowWeight,
    "sku": sku,
    "store_id": storeId,
    "tax_amount": taxAmount,
    "tax_invoiced": taxInvoiced,
    "tax_percent": taxPercent,
    "updated_at": updatedAt.toIso8601String(),
    "weight": weight,
  };
}

class Shipping {
  Shipping({
    required this.address,
    required this.method,
    required this.total,
  });

  Address address;
  String method;
  Total total;

  factory Shipping.fromJson(Map<String, dynamic> json) => Shipping(
    address: Address.fromJson(json["address"]),
    method: json["method"],
    total: Total.fromJson(json["total"]),
  );

  Map<String, dynamic> toJson() => {
    "address": address.toJson(),
    "method": method,
    "total": total.toJson(),
  };
}

class Total {
  Total({
    required this.baseShippingAmount,
    required this.baseShippingDiscountAmount,
    required this.baseShippingDiscountTaxCompensationAmnt,
    required this.baseShippingInclTax,
    required this.baseShippingTaxAmount,
    required this.shippingAmount,
    required this.shippingDiscountAmount,
    required this.shippingDiscountTaxCompensationAmount,
    required this.shippingInclTax,
    required this.shippingTaxAmount,
  });

  int baseShippingAmount;
  int baseShippingDiscountAmount;
  int baseShippingDiscountTaxCompensationAmnt;
  int baseShippingInclTax;
  int baseShippingTaxAmount;
  int shippingAmount;
  int shippingDiscountAmount;
  int shippingDiscountTaxCompensationAmount;
  int shippingInclTax;
  int shippingTaxAmount;

  factory Total.fromJson(Map<String, dynamic> json) => Total(
    baseShippingAmount: json["base_shipping_amount"],
    baseShippingDiscountAmount: json["base_shipping_discount_amount"],
    baseShippingDiscountTaxCompensationAmnt: json["base_shipping_discount_tax_compensation_amnt"],
    baseShippingInclTax: json["base_shipping_incl_tax"],
    baseShippingTaxAmount: json["base_shipping_tax_amount"],
    shippingAmount: json["shipping_amount"],
    shippingDiscountAmount: json["shipping_discount_amount"],
    shippingDiscountTaxCompensationAmount: json["shipping_discount_tax_compensation_amount"],
    shippingInclTax: json["shipping_incl_tax"],
    shippingTaxAmount: json["shipping_tax_amount"],
  );

  Map<String, dynamic> toJson() => {
    "base_shipping_amount": baseShippingAmount,
    "base_shipping_discount_amount": baseShippingDiscountAmount,
    "base_shipping_discount_tax_compensation_amnt": baseShippingDiscountTaxCompensationAmnt,
    "base_shipping_incl_tax": baseShippingInclTax,
    "base_shipping_tax_amount": baseShippingTaxAmount,
    "shipping_amount": shippingAmount,
    "shipping_discount_amount": shippingDiscountAmount,
    "shipping_discount_tax_compensation_amount": shippingDiscountTaxCompensationAmount,
    "shipping_incl_tax": shippingInclTax,
    "shipping_tax_amount": shippingTaxAmount,
  };
}

class Payment {
  Payment({
    required this.accountStatus,
    required this.additionalInformation,
    required this.amountOrdered,
    required this.baseAmountOrdered,
    required this.baseShippingAmount,
    required this.ccExpYear,
    required this.ccLast4,
    required this.ccSsStartMonth,
    required this.ccSsStartYear,
    required this.entityId,
    required this.method,
    required this.parentId,
    required this.shippingAmount,
  });

  dynamic accountStatus;
  List<String> additionalInformation;
  double amountOrdered;
  double baseAmountOrdered;
  int baseShippingAmount;
  String ccExpYear;
  dynamic ccLast4;
  String ccSsStartMonth;
  String ccSsStartYear;
  int entityId;
  String method;
  int parentId;
  int shippingAmount;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    accountStatus: json["account_status"],
    additionalInformation: List<String>.from(json["additional_information"].map((x) => x == null ? null : x)),
    amountOrdered: json["amount_ordered"].toDouble(),
    baseAmountOrdered: json["base_amount_ordered"].toDouble(),
    baseShippingAmount: json["base_shipping_amount"],
    ccExpYear: json["cc_exp_year"],
    ccLast4: json["cc_last4"] == null?'':json["cc_last4"],
    ccSsStartMonth: json["cc_ss_start_month"],
    ccSsStartYear: json["cc_ss_start_year"],
    entityId: json["entity_id"],
    method: json["method"],
    parentId: json["parent_id"],
    shippingAmount: json["shipping_amount"],
  );

  Map<String, dynamic> toJson() => {
    "account_status": accountStatus,
    "additional_information": List<dynamic>.from(additionalInformation.map((x) => x == null ? null : x)),
    "amount_ordered": amountOrdered,
    "base_amount_ordered": baseAmountOrdered,
    "base_shipping_amount": baseShippingAmount,
    "cc_exp_year": ccExpYear,
    "cc_last4": ccLast4,
    "cc_ss_start_month": ccSsStartMonth,
    "cc_ss_start_year": ccSsStartYear,
    "entity_id": entityId,
    "method": method,
    "parent_id": parentId,
    "shipping_amount": shippingAmount,
  };
}

class SearchCriteria {
  SearchCriteria({
    required this.filterGroups,
  });

  List<
      FilterGroup> filterGroups;

  factory SearchCriteria.fromJson(Map<String, dynamic> json) => SearchCriteria(
    filterGroups: List<FilterGroup>.from(json["filter_groups"].map((x) => FilterGroup.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "filter_groups": List<dynamic>.from(filterGroups.map((x) => x.toJson())),
  };
}

class FilterGroup {
  FilterGroup({
    required this.filters,
  });

  List<Filter> filters;

  factory FilterGroup.fromJson(Map<String, dynamic> json) => FilterGroup(
    filters: List<Filter>.from(json["filters"].map((x) => Filter.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "filters": List<dynamic>.from(filters.map((x) => x.toJson())),
  };
}

class Filter {
  Filter({
    required this.field,
    required this.value,
    required this.conditionType,
  });

  String field;
  String value;
  String conditionType;

  factory Filter.fromJson(Map<String, dynamic> json) => Filter(
    field: json["field"],
    value: json["value"],
    conditionType: json["condition_type"],
  );

  Map<String, dynamic> toJson() => {
    "field": field,
    "value": value,
    "condition_type": conditionType,
  };
}
