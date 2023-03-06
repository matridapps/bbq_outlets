// To parse this JSON data, do
//
//     final searchResponse = searchResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

BBQSearchResponse searchResponseFromJson(String str) => BBQSearchResponse.fromJson(json.decode(str));

String searchResponseToJson(BBQSearchResponse data) => json.encode(data.toJson());

class BBQSearchResponse {
  BBQSearchResponse({
    required this.items,

    required this.totalCount,
  });

  List<Item> items;

  int totalCount;

  factory BBQSearchResponse.fromJson(Map<String, dynamic> json) => BBQSearchResponse(
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),

    totalCount: json["total_count"]??0,
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),

    "total_count": totalCount,
  };
}

class Item {
  Item({
    required this.id,
    required this.sku,
    required this.name,

    required this.price,

    required this.weight,
    required this.extensionAttributes,

  });

  int id;
  String sku;
  String name;

  double price;

  int weight;
  ItemExtensionAttributes extensionAttributes;
  // List<dynamic> productLinks;
  // List<dynamic> tierPrices;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    sku: json["sku"],
    name: json["name"],

    price: json["price"].toDouble(),

    weight: json["weight"]??0,
    extensionAttributes: ItemExtensionAttributes.fromJson(json["extension_attributes"]),
    // productLinks: List<dynamic>.from(json["product_links"].map((x) => x)),
    // tierPrices: List<dynamic>.from(json["tier_prices"].map((x) => x)),
    // customAttributes: List<CustomAttribute>.from(json["custom_attributes"].map((x) => CustomAttribute.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sku": sku,
    "name": name,

    "price": price,

    // "type_id": typeIdValues.reverse[typeId],

    "weight": weight,
    "extension_attributes": extensionAttributes.toJson(),
    // "product_links": List<dynamic>.from(productLinks.map((x) => x)),
    // "options": List<dynamic>.from(options.map((x) => x)),
    // "media_gallery_entries": List<dynamic>.from(mediaGalleryEntries.map((x) => x.toJson())),
    // "tier_prices": List<dynamic>.from(tierPrices.map((x) => x)),
    // "custom_attributes": List<dynamic>.from(customAttributes.map((x) => x.toJson())),
  };
}


class ItemExtensionAttributes {
  ItemExtensionAttributes({
    required this.quantity,

    // required this.additionalUrls,
    required this.productImages,
    required this.catalogPrice,
  });


  int quantity;

  // List<String> additionalUrls;
  List<String> productImages;
  double catalogPrice;

  factory ItemExtensionAttributes.fromJson(Map<String, dynamic> json) => ItemExtensionAttributes(
    quantity: json["quantity"]??0,

    // additionalUrls: List<String>.from(json["additional_urls"].map((x) => x)),
    productImages: List<String>.from(json["product_images"].map((x) => x)),
    catalogPrice: double.parse(json["catalog_price"].toString()),
  );

  Map<String, dynamic> toJson() => {

    "quantity": quantity,

    // "additional_urls": List<dynamic>.from(additionalUrls.map((x) => x)),
    "product_images": List<dynamic>.from(productImages.map((x) => x)),
    "catalog_price": catalogPrice,
  };
}



