// To parse this JSON data, do
//
//     final favoritesModel = favoritesModelFromJson(jsonString);

import 'dart:convert';

FavoritesModel favoritesModelFromJson(String str) => FavoritesModel.fromJson(json.decode(str));

String favoritesModelToJson(FavoritesModel data) => json.encode(data.toJson());

class FavoritesModel {
  FavoritesModel({
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
  dynamic message;
  String status;
  int statusCode;
  int systemTime;

  factory FavoritesModel.fromJson(Map<String, dynamic> json) => FavoritesModel(
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
    this.bankTransferDiscountPercent,
    this.companyId,
    this.companySlug,
    this.companyTitle,
    this.discountPrice,
    this.discountPriceExcludingTax,
    this.guestId,
    this.image,
    this.isFreeShip,
    this.isSameDayShip,
    this.marketPrice,
    this.marketPriceExcludingTax,
    this.memberId,
    this.oldPrice,
    this.price,
    this.productId,
    this.salePrice,
    this.salePriceExcludingTax,
    this.slug,
    this.symbol,
    this.taxPercent,
    this.title,
  });

  String bankTransferDiscountPercent;
  String companyId;
  String companySlug;
  String companyTitle;
  String discountPrice;
  String discountPriceExcludingTax;
  dynamic guestId;
  String image;
  String isFreeShip;
  String isSameDayShip;
  String marketPrice;
  String marketPriceExcludingTax;
  String memberId;
  String oldPrice;
  String price;
  String productId;
  String salePrice;
  String salePriceExcludingTax;
  String slug;
  String symbol;
  String taxPercent;
  String title;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    bankTransferDiscountPercent: json["bank_transfer_discount_percent"],
    companyId: json["company_id"],
    companySlug: json["company_slug"],
    companyTitle: json["company_title"],
    discountPrice: json["discount_price"],
    discountPriceExcludingTax: json["discount_price_excluding_tax"],
    guestId: json["guest_id"],
    image: json["image"],
    isFreeShip: json["is_free_ship"],
    isSameDayShip: json["is_same_day_ship"],
    marketPrice: json["market_price"],
    marketPriceExcludingTax: json["market_price_excluding_tax"],
    memberId: json["member_id"],
    oldPrice: json["old_price"],
    price: json["price"],
    productId: json["product_id"],
    salePrice: json["sale_price"],
    salePriceExcludingTax: json["sale_price_excluding_tax"],
    slug: json["slug"],
    symbol: json["symbol"],
    taxPercent: json["tax_percent"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "bank_transfer_discount_percent": bankTransferDiscountPercent,
    "company_id": companyId,
    "company_slug": companySlug,
    "company_title": companyTitle,
    "discount_price": discountPrice,
    "discount_price_excluding_tax": discountPriceExcludingTax,
    "guest_id": guestId,
    "image": image,
    "is_free_ship": isFreeShip,
    "is_same_day_ship": isSameDayShip,
    "market_price": marketPrice,
    "market_price_excluding_tax": marketPriceExcludingTax,
    "member_id": memberId,
    "old_price": oldPrice,
    "price": price,
    "product_id": productId,
    "sale_price": salePrice,
    "sale_price_excluding_tax": salePriceExcludingTax,
    "slug": slug,
    "symbol": symbol,
    "tax_percent": taxPercent,
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
