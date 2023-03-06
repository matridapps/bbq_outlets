import 'dart:convert';

List<PopularGrillsResponse> popularGrillsResponseFromJson(String str) => List<PopularGrillsResponse>.from(json.decode(str).map((x) => PopularGrillsResponse.fromJson(x)));

String popularGrillsResponseToJson(List<PopularGrillsResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PopularGrillsResponse {
  PopularGrillsResponse({
    required this.id,
    required this.sku,
    required this.name,
    required this.price,
    required this.specialprice,
    required this.image,
  });

  final String id;
  final String sku;
  final String name;
  final String price;
  final String specialprice;
  final String image;

  factory PopularGrillsResponse.fromJson(Map<String, dynamic> json) => PopularGrillsResponse(
    id: json["Id"],
    sku: json["Sku"],
    name: json["Name"],
    price: json["Price"],
    specialprice: json["Specialprice"],
    image: json["Image"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Sku": sku,
    "Name": name,
    "Price": price,
    "Specialprice": specialprice,
    "Image": image,
  };
}
