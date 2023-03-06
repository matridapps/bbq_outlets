// ignore_for_file: file_names

import 'dart:convert';
import 'package:BBQOUTLETS/utils/utils/build_config.dart';

List<MagentoBBQProduct> magentoBbqProductFromJson(String str) => List<MagentoBBQProduct>.from(json.decode(str).map((x) => MagentoBBQProduct.fromJson(x)));

String magentoBbqProductToJson(List<MagentoBBQProduct> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MagentoBBQProduct {
  MagentoBBQProduct({
    required this.sku,
    required this.id,
    required this.name,
    required this.price,
    required this.specialPrice,
    required this.finalSpecialPrice,
    required this.image,
  });

  final String sku;
  final String id;
  final String name;
  final double price;
  final double specialPrice;
  final int finalSpecialPrice;
  final String image;

  factory MagentoBBQProduct.fromJson(Map<String, dynamic> json) => MagentoBBQProduct(
    sku: json["sku"],
    id: json["id"],
    name: json["name"],
    price: json["price"].toDouble(),
    specialPrice: json["special_price"] == null || json["special_price"] >= json["price"].toDouble() ? json["price"].toDouble() : json["special_price"].toDouble(),
    finalSpecialPrice: json["final_special_price"],
    image: json["image"] ?? noImageUrl,
  );

  Map<String, dynamic> toJson() => {
    "sku": sku,
    "id": id,
    "name": name,
    "price": price,
    "special_price": specialPrice == 0 || specialPrice >= price ? price : specialPrice,
    "final_special_price": finalSpecialPrice,
    "image": image == '' ? noImageUrl : image,
  };
}
