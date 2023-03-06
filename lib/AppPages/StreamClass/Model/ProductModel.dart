// To parse required this.JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

// import 'dart:convert';
//
// ProductMagentoResponse productMagentoResponseFromJson(String str) => ProductMagentoResponse.fromJson(json.decode(str));
//
// String welcomeToJson(ProductMagentoResponse data) => json.encode(data.toJson());
//
// class ProductMagentoResponse {
//   ProductMagentoResponse({
//     required this.items,
//     required this.searchCriteria,
//     required this.totalCount,
//   });
//
//   List<Item> items;
//   SearchCriteria searchCriteria;
//   int totalCount;
//
//   factory ProductMagentoResponse.fromJson(Map<String, dynamic> json) => ProductMagentoResponse(
//     items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
//     searchCriteria: SearchCriteria.fromJson(json["search_criteria"]),
//     totalCount: json["total_count"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "items": List<dynamic>.from(items.map((x) => x.toJson())),
//     "search_criteria": searchCriteria.toJson(),
//     "total_count": totalCount,
//   };
// }
//
// class Item {
//   Item({
//     required this.id,
//     required this.sku,
//     required this.name,
//   //  required this.attributeSetId,
//     required this.price,
//   //  required this.status,
//    // required this.visibility,
//    // required this.typeId,
//    /* required this.createdAt,
//     required this.updatedAt,*/
//   //  required this.weight,
//     required this.extensionAttributes,
//   //  required this.productLinks,
//   //  required this.options,
//   //  required this.mediaGalleryEntries,
//    // required this.tierPrices,
//    // required this.customAttributes,
//   });
//
//   int id;
//   String sku;
//   String name;
// //  int attributeSetId;
//   String price;
//  // int status;
//  // int visibility;
//  // String typeId;
//  /* DateTime createdAt;
//   DateTime updatedAt;*/
// //  int weight;
//   ItemExtensionAttributes extensionAttributes;
// //  List<dynamic> productLinks;
//  // List<dynamic> options;
// //  List<MediaGalleryEntry> mediaGalleryEntries;
//  // List<dynamic> tierPrices;
//  // List<CustomAttribute> customAttributes;
//
//   factory Item.fromJson(Map<String, dynamic> json) => Item(
//     id: json["id"],
//     sku: json["sku"],
//     name: json["name"],
//  //   attributeSetId: json["attribute_set_id"],
//     price: json["price"].toString(),
//  //   status: json["status"],
//   //  visibility: json["visibility"],
//   //  typeId: json["type_id"],
//    /* createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),*/
//   //  weight: json["weight"],
//     extensionAttributes: ItemExtensionAttributes.fromJson(json["extension_attributes"]),
//
//    // productLinks: List<dynamic>.from(json["product_links"].map((x) => x)),
//  //   options: List<dynamic>.from(json["options"].map((x) => x)),
//   //  mediaGalleryEntries: List<MediaGalleryEntry>.from(json["media_gallery_entries"].map((x) => MediaGalleryEntry.fromJson(x))),
//   //  tierPrices: List<dynamic>.from(json["tier_prices"].map((x) => x)),
//   //  customAttributes: List<CustomAttribute>.from(json["custom_attributes"].map((x) => CustomAttribute.fromJson(x))),
//
//   );
//
//   Map<String, dynamic> toJson() => {
//
//     "id": id,
//     "sku": sku,
//     "name": name,
//   //  "attribute_set_id": attributeSetId,
//     "price": price,
//
//   //  "status": status,
//   //  "visibility": visibility,
//    // "type_id": typeId,
//    /* "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),*/
//  //   "weight": weight,
//   //  "extension_attributes": extensionAttributes.toJson(),
//  //   "product_links": List<dynamic>.from(productLinks.map((x) => x)),
//   //  "options": List<dynamic>.from(options.map((x) => x)),
//   //  "media_gallery_entries": List<dynamic>.from(mediaGalleryEntries.map((x) => x.toJson())),
//   //  "tier_prices": List<dynamic>.from(tierPrices.map((x) => x)),
//   //  "custom_attributes": List<dynamic>.from(customAttributes.map((x) => x.toJson())),
//
//   };
// }
//
// class CustomAttribute {
//   CustomAttribute({
//     required this.attributeCode,
//     required this.value,
//   });
//
//   String attributeCode;
//   dynamic value;
//
//   factory CustomAttribute.fromJson(Map<String, dynamic> json) => CustomAttribute(
//     attributeCode: json["attribute_code"],
//     value: json["value"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "attribute_code": attributeCode,
//     "value": value,
//   };
// }
//
// class ItemExtensionAttributes {
//   ItemExtensionAttributes({
//     required this.websiteIds,
//     required this.categoryLinks,
//     required this.parentIds,
//     required this.quantity,
//     required this.productUrl,
//     required this.additionalUrls,
//     required this.productImages,
//     required this.catalogPrice,
//   });
//
//   List<int> websiteIds;
//   List<CategoryLink> categoryLinks;
//   List<dynamic> parentIds;
//   int quantity;
//   String productUrl;
//   List<String> additionalUrls;
//   List<String> productImages;
//   int catalogPrice;
//
//   factory ItemExtensionAttributes.fromJson(Map<String, dynamic> json) => ItemExtensionAttributes(
//     websiteIds: List<int>.from(json["website_ids"].map((x) => x)),
//     categoryLinks: List<CategoryLink>.from(json["category_links"].map((x) => CategoryLink.fromJson(x))),
//     parentIds: List<dynamic>.from(json["parent_ids"].map((x) => x)),
//     quantity: json["quantity"],
//     productUrl: json["product_url"],
//     additionalUrls: List<String>.from(json["additional_urls"].map((x) => x)),
//     productImages: List<String>.from(json["product_images"].map((x) => x)),
//     catalogPrice: json["catalog_price"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "website_ids": List<dynamic>.from(websiteIds.map((x) => x)),
//     "category_links": List<dynamic>.from(categoryLinks.map((x) => x.toJson())),
//     "parent_ids": List<dynamic>.from(parentIds.map((x) => x)),
//     "quantity": quantity,
//     "product_url": productUrl,
//     "additional_urls": List<dynamic>.from(additionalUrls.map((x) => x)),
//     "product_images": List<dynamic>.from(productImages.map((x) => x)),
//     "catalog_price": catalogPrice,
//   };
// }
//
// class CategoryLink {
//   CategoryLink({
//     required this.position,
//     required this.categoryId,
//   });
//
//   int position;
//   String categoryId;
//
//   factory CategoryLink.fromJson(Map<String, dynamic> json) => CategoryLink(
//     position: json["position"],
//     categoryId: json["category_id"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "position": position,
//     "category_id": categoryId,
//   };
// }
//
// class MediaGalleryEntry {
//   MediaGalleryEntry({
//     required this.id,
//   //  required this.mediaType,
//     required this.label,
//     required this.position,
//     required this.disabled,
//     required this.types,
//     required this.file,
//     required this.extensionAttributes,
//   });
//
//   int id;
//  // MediaType mediaType;
//   String label;
//   int position;
//   bool disabled;
//   List<String> types;
//   String file;
//   MediaGalleryEntryExtensionAttributes extensionAttributes;
//
//   factory MediaGalleryEntry.fromJson(Map<String, dynamic> json) => MediaGalleryEntry(
//     id: json["id"],
//   //  mediaType: mediaTypeValues.map[json["media_type"]],
//     label: json["label"],
//     position: json["position"],
//     disabled: json["disabled"],
//     types: List<String>.from(json["types"].map((x) => x)),
//     file: json["file"],
//     extensionAttributes: json["extension_attributes"] /*== null ? null : MediaGalleryEntryExtensionAttributes.fromJson(json["extension_attributes"])*/,
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//    // "media_type": mediaTypeValues.reverse[mediaType],
//     "label": label,
//     "position": position,
//     "disabled": disabled,
//     "types": List<dynamic>.from(types.map((x) => x)),
//     "file": file,
//     "extension_attributes": extensionAttributes == null ? null : extensionAttributes.toJson(),
//   };
// }
//
// class MediaGalleryEntryExtensionAttributes {
//   MediaGalleryEntryExtensionAttributes({
//     required this.videoContent,
//   });
//
//   VideoContent videoContent;
//
//   factory MediaGalleryEntryExtensionAttributes.fromJson(Map<String, dynamic> json) => MediaGalleryEntryExtensionAttributes(
//     videoContent: VideoContent.fromJson(json["video_content"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "video_content": videoContent.toJson(),
//   };
// }
//
// class VideoContent {
//   VideoContent({
//   //  required this.mediaType,
//     required this.videoProvider,
//     required this.videoUrl,
//     required this.videoTitle,
//     required this.videoDescription,
//     required this.videoMetadata,
//   });
//
// //  MediaType mediaType;
//   String videoProvider;
//   String videoUrl;
//   String videoTitle;
//   String videoDescription;
//   dynamic videoMetadata;
//
//   factory VideoContent.fromJson(Map<String, dynamic> json) => VideoContent(
//  //   mediaType: mediaTypeValues.map[json["media_type"]]!,
//     videoProvider: json["video_provider"],
//     videoUrl: json["video_url"],
//     videoTitle: json["video_title"],
//     videoDescription: json["video_description"],
//     videoMetadata: json["video_metadata"],
//   );
//
//   Map<String, dynamic> toJson() => {
//   //  "media_type": mediaTypeValues.reverse[mediaType],
//     "video_provider": videoProvider,
//     "video_url": videoUrl,
//     "video_title": videoTitle,
//     "video_description": videoDescription,
//     "video_metadata": videoMetadata,
//   };
// }
//
// enum MediaType { IMAGE, EXTERNAL_VIDEO }
//
// /*final mediaTypeValues = EnumValues({
//   "external-video": MediaType.EXTERNAL_VIDEO,
//   "image": MediaType.IMAGE
// });*/
//
// class SearchCriteria {
//   SearchCriteria({
//     required this.filterGroups,
//   });
//
//   List<FilterGroup> filterGroups;
//
//   factory SearchCriteria.fromJson(Map<String, dynamic> json) => SearchCriteria(
//     filterGroups: List<FilterGroup>.from(json["filter_groups"].map((x) => FilterGroup.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "filter_groups": List<dynamic>.from(filterGroups.map((x) => x.toJson())),
//   };
// }
//
// class FilterGroup {
//   FilterGroup({
//     required this.filters,
//   });
//
//   List<Filter> filters;
//
//   factory FilterGroup.fromJson(Map<String, dynamic> json) => FilterGroup(
//     filters: List<Filter>.from(json["filters"].map((x) => Filter.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "filters": List<dynamic>.from(filters.map((x) => x.toJson())),
//   };
// }
//
// class Filter {
//   Filter({
//     required this.field,
//     required this.value,
//     required this.conditionType,
//   });
//
//   String field;
//   String value;
//   String conditionType;
//
//   factory Filter.fromJson(Map<String, dynamic> json) => Filter(
//     field: json["field"],
//     value: json["value"],
//     conditionType: json["condition_type"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "field": field,
//     "value": value,
//     "condition_type": conditionType,
//   };
// }
//
// /*class EnumValues<T> {
//   Map<String, T> map;
//   Map<T, String> reverseMap;
//
//   EnumValues(
//       required this.map,
//       required this.reve
//       );
//
//   Map<T, String> get reverse {
//     if (reverseMap == null) {
//       reverseMap = map.map((k, v) => new MapEntry(v, k));
//     }
//     return reverseMap;
//   }
// }*/

// To parse this JSON data, do
//
//     final productMagentoResponse = productMagentoResponseFromJson(jsonString);

// ignore_for_file: constant_identifier_names

import 'dart:convert';

ProductMagentoResponse productMagentoResponseFromJson(String str) =>
    ProductMagentoResponse.fromJson(json.decode(str));

String productMagentoResponseToJson(ProductMagentoResponse data) =>
    json.encode(data.toJson());

class ProductMagentoResponse {
  ProductMagentoResponse({
    required this.items,
    required this.searchCriteria,
    required this.totalCount,
  });

  final List<Item> items;
  final SearchCriteria searchCriteria;
  final int totalCount;

  factory ProductMagentoResponse.fromJson(Map<String, dynamic> json) =>
      ProductMagentoResponse(
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        searchCriteria: SearchCriteria.fromJson(json["search_criteria"]),
        totalCount: json["total_count"],
      );

  Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "search_criteria": searchCriteria.toJson(),
        "total_count": totalCount,
      };
}

class Item {
  Item({
    required this.id,
    required this.sku,
    required this.name,
    required this.attributeSetId,
    required this.price,
    required this.status,
    required this.visibility,
    required this.typeId,
    required this.createdAt,
    required this.updatedAt,
    required this.weight,
    required this.extensionAttributes,
    required this.productLinks,
    required this.options,
    required this.mediaGalleryEntries,
    required this.tierPrices,
    required this.customAttributes,
  });

  final int id;
  final String sku;
  final String name;
  final int attributeSetId;
  final double price;
  final int status;
  final int visibility;
  final String typeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int weight;
  final ExtensionAttributes extensionAttributes;
  final List<dynamic> productLinks;
  final List<dynamic> options;
  final List<MediaGalleryEntry> mediaGalleryEntries;
  final List<dynamic> tierPrices;
  final List<CustomAttribute> customAttributes;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        sku: json["sku"],
        name: json["name"],
        attributeSetId: json["attribute_set_id"],
        price: json["price"].toDouble(),
        status: json["status"],
        visibility: json["visibility"],
        typeId: json["type_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        weight: json["weight"],
        extensionAttributes:
            ExtensionAttributes.fromJson(json["extension_attributes"]),
        productLinks: List<dynamic>.from(json["product_links"].map((x) => x)),
        options: List<dynamic>.from(json["options"].map((x) => x)),
        mediaGalleryEntries: List<MediaGalleryEntry>.from(
            json["media_gallery_entries"]
                .map((x) => MediaGalleryEntry.fromJson(x))),
        tierPrices: List<dynamic>.from(json["tier_prices"].map((x) => x)),
        customAttributes: List<CustomAttribute>.from(
            json["custom_attributes"].map((x) => CustomAttribute.fromJson(x))),
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
        "weight": weight,
        "extension_attributes": extensionAttributes.toJson(),
        "product_links": List<dynamic>.from(productLinks.map((x) => x)),
        "options": List<dynamic>.from(options.map((x) => x)),
        "media_gallery_entries":
            List<dynamic>.from(mediaGalleryEntries.map((x) => x.toJson())),
        "tier_prices": List<dynamic>.from(tierPrices.map((x) => x)),
        "custom_attributes":
            List<dynamic>.from(customAttributes.map((x) => x.toJson())),
      };
}

class CustomAttribute {
  CustomAttribute({
    required this.attributeCode,
    required this.value,
  });

  final String attributeCode;
  final dynamic value;

  factory CustomAttribute.fromJson(Map<String, dynamic> json) =>
      CustomAttribute(
        attributeCode: json["attribute_code"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "attribute_code": attributeCode,
        "value": value,
      };
}

class ExtensionAttributes {
  ExtensionAttributes({
    required this.websiteIds,
    required this.categoryLinks,
  });

  final List<int> websiteIds;
  final List<CategoryLink> categoryLinks;

  factory ExtensionAttributes.fromJson(Map<String, dynamic> json) =>
      ExtensionAttributes(
        websiteIds: List<int>.from(json["website_ids"].map((x) => x)),
        categoryLinks: List<CategoryLink>.from(
            json["category_links"].map((x) => CategoryLink.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "website_ids": List<dynamic>.from(websiteIds.map((x) => x)),
        "category_links":
            List<dynamic>.from(categoryLinks.map((x) => x.toJson())),
      };
}

class CategoryLink {
  CategoryLink({
    required this.position,
    required this.categoryId,
  });

  final int position;
  final String categoryId;

  factory CategoryLink.fromJson(Map<String, dynamic> json) => CategoryLink(
        position: json["position"],
        categoryId: json["category_id"],
      );

  Map<String, dynamic> toJson() => {
        "position": position,
        "category_id": categoryId,
      };
}

class MediaGalleryEntry {
  MediaGalleryEntry({
    required this.id,
    required this.label,
    required this.position,
    required this.disabled,
    required this.types,
    required this.file,
  });

  final int id;
  final dynamic label;
  final int position;
  final bool disabled;
  final List<String> types;
  final String file;

  factory MediaGalleryEntry.fromJson(Map<String, dynamic> json) =>
      MediaGalleryEntry(
        id: json["id"],
        label: json["label"],
        position: json["position"],
        disabled: json["disabled"],
        types: List<String>.from(json["types"].map((x) => x)),
        file: json["file"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
        "position": position,
        "disabled": disabled,
        "types": List<dynamic>.from(types.map((x) => x)),
        "file": file,
      };
}

enum MediaType { IMAGE }

class SearchCriteria {
  SearchCriteria({
    required this.filterGroups,
  });

  final List<FilterGroup> filterGroups;

  factory SearchCriteria.fromJson(Map<String, dynamic> json) => SearchCriteria(
        filterGroups: List<FilterGroup>.from(
            json["filter_groups"].map((x) => FilterGroup.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "filter_groups":
            List<dynamic>.from(filterGroups.map((x) => x.toJson())),
      };
}

class FilterGroup {
  FilterGroup({
    required this.filters,
  });

  final List<Filter> filters;

  factory FilterGroup.fromJson(Map<String, dynamic> json) => FilterGroup(
        filters:
            List<Filter>.from(json["filters"].map((x) => Filter.fromJson(x))),
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

  final String field;
  final String value;
  final String conditionType;

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
