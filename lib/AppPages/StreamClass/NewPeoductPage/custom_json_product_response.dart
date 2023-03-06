// To parse this JSON data, do
//
//     final customJsonProductResponse = customJsonProductResponseFromJson(jsonString);

import 'dart:convert';

CustomJsonProductResponse customJsonProductResponseFromJson(String str) =>
    CustomJsonProductResponse.fromJson(json.decode(str));

String customJsonProductResponseToJson(CustomJsonProductResponse data) =>
    json.encode(data.toJson());

class CustomJsonProductResponse {
  CustomJsonProductResponse(
      {required this.id,
      required this.sku,
      required this.name,
      required this.details,
      required this.moreInformation,
      required this.attributeSetId,
      required this.price,
      required this.status,
      required this.visibility,
      required this.typeId,
      required this.createdAt,
      required this.updatedAt,
      required this.extensionAttributes,
      required this.tierPrices,
      required this.size,
      required this.fuelType,
      required this.discountPercentage});

  final int id;
  final String sku;
  final String discountPercentage;
  final String name;
  final int attributeSetId;
  final int price;
  final int status;
  final int visibility;
  final String typeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ExtensionAttributes extensionAttributes;
  final List<dynamic> tierPrices;
  final List<FuelType> size;
  final List<FuelType> fuelType;
  final String details;
  final String moreInformation;

  factory CustomJsonProductResponse.fromJson(Map<String, dynamic> json) =>
      CustomJsonProductResponse(
        id: json["id"],
        sku: json["sku"],
        name: json["name"],
        discountPercentage: json["discountPercentage"],
        attributeSetId: json["attribute_set_id"],
        price: json["price"],
        status: json["status"],
        visibility: json["visibility"],
        typeId: json["type_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        extensionAttributes:
            ExtensionAttributes.fromJson(json["extension_attributes"]),
        tierPrices: List<dynamic>.from(json["tier_prices"].map((x) => x)),
        size:
            List<FuelType>.from(json["size"].map((x) => FuelType.fromJson(x))),
        fuelType: List<FuelType>.from(
            json["fuel_type"].map((x) => FuelType.fromJson(x))),
        details: json['details'],
        moreInformation: json['more_info']
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sku": sku,
        "name": name,
        "attribute_set_id": attributeSetId,
        "price": price,
        "status": status,
        "visibility": visibility,
        "type_id": typeId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "extension_attributes": extensionAttributes.toJson(),
        "tier_prices": List<dynamic>.from(tierPrices.map((x) => x)),
        "size": List<dynamic>.from(size.map((x) => x.toJson())),
        "fuel_type": List<dynamic>.from(fuelType.map((x) => x.toJson())),
      };
}

class ExtensionAttributes {
  ExtensionAttributes({
    required this.websiteIds,
    required this.categoryLinks,
    required this.parentIds,
    required this.quantity,
    required this.productImages,
    required this.catalogPrice,
  });

  final List<int> websiteIds;
  final List<CategoryLink> categoryLinks;
  final List<dynamic> parentIds;
  final int quantity;
  final List<String> productImages;
  final int catalogPrice;

  factory ExtensionAttributes.fromJson(Map<String, dynamic> json) =>
      ExtensionAttributes(
        websiteIds: List<int>.from(json["website_ids"].map((x) => x)),
        categoryLinks: List<CategoryLink>.from(
            json["category_links"].map((x) => CategoryLink.fromJson(x))),
        parentIds: List<dynamic>.from(json["parent_ids"].map((x) => x)),
        quantity: json["quantity"],
        productImages: List<String>.from(json["product_images"].map((x) => x)),
        catalogPrice: json["catalog_price"],
      );

  Map<String, dynamic> toJson() => {
        "website_ids": List<dynamic>.from(websiteIds.map((x) => x)),
        "category_links":
            List<dynamic>.from(categoryLinks.map((x) => x.toJson())),
        "parent_ids": List<dynamic>.from(parentIds.map((x) => x)),
        "quantity": quantity,
        "product_images": List<dynamic>.from(productImages.map((x) => x)),
        "catalog_price": catalogPrice,
      };
}

class CategoryLink {
  CategoryLink({
    required this.position,
    required this.categoryId,
  });

  final int position;
  final int categoryId;

  factory CategoryLink.fromJson(Map<String, dynamic> json) => CategoryLink(
        position: json["position"],
        categoryId: json["category_id"],
      );

  Map<String, dynamic> toJson() => {
        "position": position,
        "category_id": categoryId,
      };
}

class FuelType {
  FuelType({
    required this.fuel,
    required this.imageUrl,
    required this.sku,
    required this.price,
    required this.productName,
    required this.name,
  });

  final String fuel;
  final String imageUrl;
  final String sku;
  final int price;
  final String productName;
  final String name;

  factory FuelType.fromJson(Map<String, dynamic> json) => FuelType(
        fuel: json["fuel"] == null ? null : json["fuel"],
        imageUrl: json["image_path"],
        sku: json["sku"],
        price: json["price"],
        productName: json["product_name"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "fuel": fuel == null ? null : fuel,
        "image_url": imageUrl,
        "sku": sku,
        "price": price,
        "product_name": productName,
        "name": name == null ? '' : name,
      };
}
