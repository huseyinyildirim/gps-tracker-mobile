// To parse this JSON data, do
//
//     final productsCategoryModel = productsCategoryModelFromJson(jsonString);

import 'dart:convert';

ProductsCategoryModel productsCategoryModelFromJson(String str) => ProductsCategoryModel.fromJson(json.decode(str));

String productsCategoryModelToJson(ProductsCategoryModel data) => json.encode(data.toJson());

class ProductsCategoryModel {
  ProductsCategoryModel({
    this.data,
    this.error,
    this.locale,
    this.message,
    this.status,
    this.statusCode,
    this.systemTime,
  });

  List<Datum> data;
  Error error;
  String locale;
  String message;
  String status;
  int statusCode;
  int systemTime;

  factory ProductsCategoryModel.fromJson(Map<String, dynamic> json) => ProductsCategoryModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    error: Error.fromJson(json["error"]),
    locale: json["locale"],
    message: json["message"],
    status: json["status"],
    statusCode: json["statusCode"],
    systemTime: json["systemTime"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "error": error.toJson(),
    "locale": locale,
    "message": message,
    "status": status,
    "statusCode": statusCode,
    "systemTime": systemTime,
  };
}

class Datum {
  Datum({
    this.brand,
    this.currency,
    this.discountPrice,
    this.discountRate,
    this.id,
    this.image,
    this.marketPrice,
    this.salePrice,
    this.slug,
    this.stockAmount,
    this.title,
    this.score,
    this.isFreeShip,
    this.isSameDayShip,
  });

  String brand;
  String currency;
  String discountPrice;
  String discountRate;
  int id;
  String image;
  String marketPrice;
  String salePrice;
  String slug;
  String stockAmount;
  String title;
  String score;
  String isFreeShip;
  String isSameDayShip;


  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    brand: json["brand"],
    currency: json["currency"],
    discountPrice: json["discount_price"],
    discountRate: json["discount_rate"] == null ? null : json["discount_rate"],
    id: json["id"],
    image: json["image"],
    marketPrice: json["market_price"],
    salePrice: json["sale_price"],
    slug: json["slug"],
    stockAmount: json["stock_amount"],
    title: json["title"],
    score: json["score"],
    isFreeShip: json["is_free_ship"],
    isSameDayShip: json["is_same_day_ship"],
  );

  Map<String, dynamic> toJson() => {
    "brand": brand,
    "currency": currency,
    "discount_price": discountPrice,
    "discount_rate": discountRate == null ? null : discountRate,
    "id": id,
    "image": image,
    "market_price": marketPrice,
    "sale_price": salePrice,
    "slug": slug,
    "stock_amount": stockAmount,
    "title": title,
    "score": score,
    "is_free_ship": isFreeShip,
    "is_same_day_ship": isSameDayShip,
  };
}

class Error {
  Error({
    this.help,
    this.internalMessage,
    this.message,
  });

  dynamic help;
  dynamic internalMessage;
  dynamic message;

  factory Error.fromJson(Map<String, dynamic> json) => Error(
    help: json["help"],
    internalMessage: json["internalMessage"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "help": help,
    "internalMessage": internalMessage,
    "message": message,
  };
}
