// To parse this JSON data, do
//
//     final categoryResposne = categoryResposneFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CategoryResposne categoryResposneFromJson(String str) => CategoryResposne.fromJson(json.decode(str));

String categoryResposneToJson(CategoryResposne data) => json.encode(data.toJson());

class ChildrenDatum {
  ChildrenDatum({
    required this.id,
    required this.parentId,
    required this.name,
    required this.image,
    required this.includeInMenu,
    required this.position,
    required this.level,
    required this.productCount,
    required this.childrenData,
  });

  int id;
  int parentId;
  String name;
  dynamic image;
  bool includeInMenu;
  int position;
  int level;
  int productCount;
  List<CategoryResposne> childrenData;

  factory ChildrenDatum.fromJson(Map<String, dynamic> json) => ChildrenDatum(
    id: json["id"],
    parentId: json["parent_id"],
    name: json["name"],
    image: json["image"],
    includeInMenu: json["include_in_menu"],
    position: json["position"],
    level: json["level"],
    productCount: json["product_count"],
    childrenData: List<CategoryResposne>.from(json["children_data"].map((x) => CategoryResposne.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "parent_id": parentId,
    "name": name,
    "image": image,
    "include_in_menu": includeInMenu,
    "position": position,
    "level": level,
    "product_count": productCount,
    "children_data": List<dynamic>.from(childrenData.map((x) => x.toJson())),
  };
}

class CategoryResposne {
  CategoryResposne({
    required this.id,
    required this.parentId,
    required this.name,
    required this.image,
    required this.includeInMenu,
    required this.position,
    required this.level,
    required this.productCount,
    required this.childrenData,
  });

  int id;
  int parentId;
  String name;
  String image;
  bool includeInMenu;
  int position;
  int level;
  int productCount;
  List<ChildrenDatum> childrenData;

  factory CategoryResposne.fromJson(Map<String, dynamic> json) => CategoryResposne(
    id: json["id"],
    parentId: json["parent_id"],
    name: json["name"],
    image: json["image"] == null ? null : json["image"],
    includeInMenu: json["include_in_menu"],
    position: json["position"],
    level: json["level"],
    productCount: json["product_count"],
    childrenData: List<ChildrenDatum>.from(json["children_data"].map((x) => ChildrenDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "parent_id": parentId,
    "name": name,
    "image": image == null ? null : image,
    "include_in_menu": includeInMenu,
    "position": position,
    "level": level,
    "product_count": productCount,
    "children_data": List<dynamic>.from(childrenData.map((x) => x.toJson())),
  };
}
