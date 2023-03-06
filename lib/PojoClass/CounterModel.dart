// ignore_for_file: file_names

import 'dart:convert';

CounterModel cartModelFromJson(String str) =>
    CounterModel.fromJson(json.decode(str));

String cartModelToJson(CounterModel data) => json.encode(data.toJson());

class CounterModel {
  String quantity;

  CounterModel({required this.quantity});
  factory CounterModel.fromJson(Map<String, dynamic> json) => CounterModel(
        quantity: json["items_qty"].toString(),
      );
  Map<String, dynamic> toJson() => {
        "items_qty": quantity,
      };
}
