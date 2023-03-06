import 'dart:convert';

HomeScreenResponse homeScreenResponseFromJson(String str) => HomeScreenResponse.fromJson(json.decode(str));

String homeScreenResponseToJson(HomeScreenResponse data) => json.encode(data.toJson());

class HomeScreenResponse {
  HomeScreenResponse({
    required this.banner,
    required this.saleOffers,
    required this.shopPopularDepartment,
    required this.brandSection,
  });

  final ShopPopularDepartment banner;
  final ShopPopularDepartment saleOffers;
  final ShopPopularDepartment shopPopularDepartment;
  final BrandSection brandSection;

  factory HomeScreenResponse.fromJson(Map<String, dynamic> json) => HomeScreenResponse(
    banner: ShopPopularDepartment.fromJson(json["banner"]),
    saleOffers: ShopPopularDepartment.fromJson(json["sale_offers"]),
    shopPopularDepartment: ShopPopularDepartment.fromJson(json["Shop_popular_Department"]),
    brandSection: BrandSection.fromJson(json["Brand_section"]),
  );

  Map<String, dynamic> toJson() => {
    "banner": banner.toJson(),
    "sale_offers": saleOffers.toJson(),
    "Shop_popular_Department": shopPopularDepartment.toJson(),
    "Brand_section": brandSection.toJson(),
  };
}

class HomeBanners {
  HomeBanners({
    required this.title,
    required this.textName,
    required this.image,
  });

  final Title title;
  final List<String> textName;
  final List<String> image;

  factory HomeBanners.fromJson(Map<String, dynamic> json) => HomeBanners(
    title: Title.fromJson(json["title"]),
    textName: List<String>.from(json["text/name"].map((x) => x)),
    image: List<String>.from(json["image"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "title": title.toJson(),
    "text/name": List<dynamic>.from(textName.map((x) => x)),
    "image": List<dynamic>.from(image.map((x) => x)),
  };
}

class SaleOffers {
  SaleOffers({
    required this.title,
    required this.textName,
    required this.image,
  });

  final Title title;
  final List<String> textName;
  final List<String> image;

  factory SaleOffers.fromJson(Map<String, dynamic> json) => SaleOffers(
    title: Title.fromJson(json["title"]),
    textName: List<String>.from(json["text/name"].map((x) => x)),
    image: List<String>.from(json["image"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "title": title.toJson(),
    "text/name": List<dynamic>.from(textName.map((x) => x)),
    "image": List<dynamic>.from(image.map((x) => x)),
  };
}

class ShopPopularDepartment {
  ShopPopularDepartment({
    required this.title,
    required this.textName,
    required this.image,
  });

  final Title title;
  final List<String> textName;
  final List<String> image;

  factory ShopPopularDepartment.fromJson(Map<String, dynamic> json) => ShopPopularDepartment(
    title: Title.fromJson(json["title"]),
    textName: List<String>.from(json["text/name"].map((x) => x)),
    image: List<String>.from(json["image"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "title": title.toJson(),
    "text/name": List<dynamic>.from(textName.map((x) => x)),
    "image": List<dynamic>.from(image.map((x) => x)),
  };
}

class Title {
  Title({
    required this.id,
    required this.titile,
    required this.identifier,
    required this.active,
  });

  final String id;
  final String titile;
  final String identifier;
  final String active;

  factory Title.fromJson(Map<String, dynamic> json) => Title(
    id: json["ID"],
    titile: json["Titile"],
    identifier: json["Identifier"],
    active: json["Active"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "Titile": titile,
    "Identifier": identifier,
    "Active": active,
  };
}

class BrandSection {
  BrandSection({
    required this.title,
    required this.textName,
    required this.image,
    required this.url,
    required this.id,
    required this.name,
  });

  final Title title;
  final List<String> textName;
  final List<String> image;
  final List<String> url;
  final List<String> id;
  final List<String> name;

  factory BrandSection.fromJson(Map<String, dynamic> json) => BrandSection(
    title: Title.fromJson(json["title"]),
    textName: List<String>.from(json["text/name"].map((x) => x)),
    image: List<String>.from(json["image"].map((x) => x)),
    url: List<String>.from(json["url"].map((x) => x)),
    id: List<String>.from(json["id"].map((x) => x)),
    name: List<String>.from(json["name"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "title": title.toJson(),
    "text/name": List<dynamic>.from(textName.map((x) => x)),
    "image": List<dynamic>.from(image.map((x) => x)),
    "url": List<dynamic>.from(url.map((x) => x)),
    "id": List<dynamic>.from(id.map((x) => x)),
    "name": List<dynamic>.from(name.map((x) => x)),
  };
}
