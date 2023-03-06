// To parse this JSON data, do
//
//     final customerDetailsResponse = customerDetailsResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CustomerDetailsResponse customerDetailsResponseFromJson(String str) => CustomerDetailsResponse.fromJson(json.decode(str));

String customerDetailsResponseToJson(CustomerDetailsResponse data) => json.encode(data.toJson());

class CustomerDetailsResponse {
  CustomerDetailsResponse({
    required this.id,
    required this.groupId,
    required this.createdAt,
    required this.updatedAt,
    required this.createdIn,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.storeId,
    required this.websiteId,
    required this.addresses,
    required this.disableAutoGroupChange,
    required this.extensionAttributes,
    // required this.customAttributes,
  });

  int id;
  int groupId;
  DateTime createdAt;
  DateTime updatedAt;
  String createdIn;
  String email;
  String firstname;
  String lastname;
  int storeId;
  int websiteId;
  List<dynamic> addresses;
  int disableAutoGroupChange;
  ExtensionAttributes extensionAttributes;
  // List<CustomAttribute> customAttributes;

  factory CustomerDetailsResponse.fromJson(Map<String, dynamic> json) => CustomerDetailsResponse(
    id: json["id"],
    groupId: json["group_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    createdIn: json["created_in"],
    email: json["email"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    storeId: json["store_id"],
    websiteId: json["website_id"],
    addresses: List<dynamic>.from(json["addresses"].map((x) => x)),
    disableAutoGroupChange: json["disable_auto_group_change"],
    extensionAttributes: ExtensionAttributes.fromJson(json["extension_attributes"]),
    // customAttributes: List<CustomAttribute>.from(json["custom_attributes"].map((x) => CustomAttribute.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "group_id": groupId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "created_in": createdIn,
    "email": email,
    "firstname": firstname,
    "lastname": lastname,
    "store_id": storeId,
    "website_id": websiteId,
    "addresses": List<dynamic>.from(addresses.map((x) => x)),
    "disable_auto_group_change": disableAutoGroupChange,
    "extension_attributes": extensionAttributes.toJson(),
    // "custom_attributes": List<dynamic>.from(customAttributes.map((x) => x.toJson())),
  };
}



class ExtensionAttributes {
  ExtensionAttributes({
    required this.isSubscribed,
  });

  bool isSubscribed;

  factory ExtensionAttributes.fromJson(Map<String, dynamic> json) => ExtensionAttributes(
    isSubscribed: json["is_subscribed"],
  );

  Map<String, dynamic> toJson() => {
    "is_subscribed": isSubscribed,
  };
}
