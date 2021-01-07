// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    this.data,
    this.error,
    this.locale,
    this.message,
    this.status,
    this.statusCode,
    this.systemTime,
  });

  Data data;
  Error error;
  String locale;
  String message;
  String status;
  int statusCode;
  int systemTime;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    data: Data.fromJson(json["data"]),
    error: Error.fromJson(json["error"]),
    locale: json["locale"],
    message: json["message"],
    status: json["status"],
    statusCode: json["statusCode"],
    systemTime: json["systemTime"],
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "error": error.toJson(),
    "locale": locale,
    "message": message,
    "status": status,
    "statusCode": statusCode,
    "systemTime": systemTime,
  };
}

class Data {
  Data({
    this.brand,
    this.brandSlug,
    this.currency,
    this.description,
    this.discountPrice,
    this.id,
    this.isFreeShip,
    this.isSameDayShip,
    this.leadTime,
    this.marketPrice,
    this.maxPurchaseQuantity,
    this.minPurchaseQuantity,
    this.partnerName,
    this.partnerSlug,
    this.salePrice,
    this.score,
    this.seoDescription,
    this.seoKeywords,
    this.seoTitle,
    this.shortDescription,
    this.slug,
    this.stockAmount,
    this.stockCode,
    this.title,
    this.discountRate,
  });

  String brand;
  String brandSlug;
  String currency;
  String description;
  String discountPrice;
  int id;
  String isFreeShip;
  String isSameDayShip;
  String leadTime;
  String marketPrice;
  String maxPurchaseQuantity;
  String minPurchaseQuantity;
  String partnerName;
  String partnerSlug;
  String salePrice;
  String score;
  String seoDescription;
  String seoKeywords;
  String seoTitle;
  String shortDescription;
  String slug;
  String stockAmount;
  String stockCode;
  String title;
  String discountRate;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    brand: json["brand"],
    brandSlug: json["brand_slug"],
    currency: json["currency"],
    description: json["description"],
    discountPrice: json["discount_price"],
    id: json["id"],
    isFreeShip: json["is_free_ship"],
    isSameDayShip: json["is_same_day_ship"],
    leadTime: json["lead_time"],
    marketPrice: json["market_price"],
    maxPurchaseQuantity: json["max_purchase_quantity"],
    minPurchaseQuantity: json["min_purchase_quantity"],
    partnerName: json["partner_name"],
    partnerSlug: json["partner_slug"],
    salePrice: json["sale_price"],
    score: json["score"],
    seoDescription: json["seo_description"],
    seoKeywords: json["seo_keywords"],
    seoTitle: json["seo_title"],
    shortDescription: json["short_description"],
    slug: json["slug"],
    stockAmount: json["stock_amount"],
    stockCode: json["stock_code"],
    title: json["title"],
    discountRate: json["discount_rate"],
  );

  Map<String, dynamic> toJson() => {
    "brand": brand,
    "brand_slug": brandSlug,
    "currency": currency,
    "description": description,
    "discount_price": discountPrice,
    "discount_rate": discountRate == null ? null : discountRate,
    "id": id,
    "is_free_ship": isFreeShip,
    "is_same_day_ship": isSameDayShip,
    "lead_time": leadTime,
    "market_price": marketPrice,
    "max_purchase_quantity": maxPurchaseQuantity,
    "min_purchase_quantity": minPurchaseQuantity,
    "partner_name": partnerName,
    "partner_slug": partnerSlug,
    "sale_price": salePrice,
    "score": score,
    "seo_description": seoDescription,
    "seo_keywords": seoKeywords,
    "seo_title": seoTitle,
    "short_description": shortDescription,
    "slug": slug,
    "stock_amount": stockAmount,
    "stock_code": stockCode,
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