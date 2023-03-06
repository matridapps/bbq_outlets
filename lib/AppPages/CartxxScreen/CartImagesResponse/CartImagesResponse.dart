// To parse this JSON data, do
//
//     final cartItemImagesResponse = cartItemImagesResponseFromJson(jsonString);

import 'dart:convert';

List<CartItemImagesResponse> cartItemImagesResponseFromJson(String str) => List<CartItemImagesResponse>.from(json.decode(str).map((x) => CartItemImagesResponse.fromJson(x)));

String cartItemImagesResponseToJson(List<CartItemImagesResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartItemImagesResponse {
  CartItemImagesResponse({
    required this.id,
    // required this.mediaType,
    // required this.label,
    required this.position,
    // required this.disabled,
    required this.file,
  });

  int id;
  // MediaType mediaType;
  // dynamic label;
  int position;
  // bool disabled;

  String file;

  factory CartItemImagesResponse.fromJson(Map<String, dynamic> json) => CartItemImagesResponse(
    id: json["id"],
    // mediaType: mediaTypeValues.map[json["media_type"]],
    // label: json["label"],
    position: json["position"],
    // disabled: json["disabled"],
    file: json["file"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    // "media_type": mediaTypeValues.reverse[mediaType],
    // "label": label,
    "position": position,
    // "disabled": disabled,
    "file": file,
  };
}




