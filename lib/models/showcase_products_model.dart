// To parse this JSON data, do
//
//     final showcaseProductsModel = showcaseProductsModelFromJson(jsonString);

import 'dart:convert';

ShowcaseProductsModel showcaseProductsModelFromJson(String str) => ShowcaseProductsModel.fromJson(json.decode(str));

String showcaseProductsModelToJson(ShowcaseProductsModel data) => json.encode(data.toJson());

class ShowcaseProductsModel {
  ShowcaseProductsModel({
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

  factory ShowcaseProductsModel.fromJson(Map<String, dynamic> json) => ShowcaseProductsModel(
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
    this.isFreeShip,
    this.isSameDayShip,
    this.marketPrice,
    this.salePrice,
    this.score,
    this.slug,
    this.stockAmount,
    this.title,
  });

  String brand;
  String currency;
  String discountPrice;
  String discountRate;
  int id;
  String image;
  String isFreeShip;
  String isSameDayShip;
  String marketPrice;
  String salePrice;
  String score;
  String slug;
  String stockAmount;
  String title;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    brand: json["brand"],
    currency: json["currency"],
    discountPrice: json["discount_price"],
    discountRate: json["discount_rate"],
    id: json["id"],
    image: json["image"],
    isFreeShip: json["is_free_ship"],
    isSameDayShip: json["is_same_day_ship"],
    marketPrice: json["market_price"],
    salePrice: json["sale_price"],
    score: json["score"] == null ? null : json["score"],
    slug: json["slug"],
    stockAmount: json["stock_amount"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "brand": brand,
    "currency": currency,
    "discount_price": discountPrice,
    "discount_rate": discountRate,
    "id": id,
    "image": image,
    "is_free_ship": isFreeShip,
    "is_same_day_ship": isSameDayShip,
    "market_price": marketPrice,
    "sale_price": salePrice,
    "score": score == null ? null : score,
    "slug": slug,
    "stock_amount": stockAmount,
    "title": title,
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
