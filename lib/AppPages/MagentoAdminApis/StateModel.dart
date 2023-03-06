// To parse this JSON data, do
//
//     final countryResponseModel = countryResponseModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<CountryResponseModel> countryResponseModelFromJson(String str) =>
    List<CountryResponseModel>.from(
        json.decode(str).map((x) => CountryResponseModel.fromJson(x)));

String countryResponseModelToJson(List<CountryResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CountryResponseModel {
  CountryResponseModel({
    required this.id,
    required this.twoLetterAbbreviation,
    required this.threeLetterAbbreviation,
    required this.fullNameLocale,
    required this.fullNameEnglish,
    required this.availableRegions,
  });

  String id;
  String twoLetterAbbreviation;
  String threeLetterAbbreviation;
  String fullNameLocale;
  String fullNameEnglish;
  List<AvailableRegion> availableRegions;

  factory CountryResponseModel.fromJson(Map<String, dynamic> json) =>
      CountryResponseModel(
        id: json["id"],
        twoLetterAbbreviation: json["two_letter_abbreviation"],
        threeLetterAbbreviation: json["three_letter_abbreviation"],
        fullNameLocale:
            json["full_name_locale"] == null ? '' : json["full_name_locale"],
        fullNameEnglish:
            json["full_name_english"] == null ? '' : json["full_name_english"],
        availableRegions: json["available_regions"] == null
            ? []
            : List<AvailableRegion>.from(json["available_regions"]
                .map((x) => AvailableRegion.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "two_letter_abbreviation": twoLetterAbbreviation,
        "three_letter_abbreviation": threeLetterAbbreviation,
        "full_name_locale": fullNameLocale == null ? '' : fullNameLocale,
        "full_name_english": fullNameEnglish == null ? '' : fullNameEnglish,
        "available_regions": availableRegions == null
            ? []
            : List<dynamic>.from(availableRegions.map((x) => x.toJson())),
      };
}

class AvailableRegion {
  AvailableRegion({
    required this.id,
    required this.code,
    required this.name,
  });

  String id;
  String code;
  String name;

  factory AvailableRegion.fromJson(Map<String, dynamic> json) =>
      AvailableRegion(
        id: json["id"],
        code: json["code"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
      };
}
