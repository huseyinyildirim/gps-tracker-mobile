// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  CartModel({
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

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
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
    this.cartId,
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
    this.quantity,
    this.salePrice,
    this.salePriceExcludingTax,
    this.slug,
    this.symbol,
    this.taxPercent,
    this.title,
    this.totalPrice,
    this.unit,
  });

  String bankTransferDiscountPercent;
  String cartId;
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
  String quantity;
  String salePrice;
  String salePriceExcludingTax;
  String slug;
  String symbol;
  String taxPercent;
  String title;
  String totalPrice;
  String unit;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    bankTransferDiscountPercent: json["bank_transfer_discount_percent"],
    cartId: json["cart_id"],
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
    oldPrice: json["old_price"] == null ? null : json["old_price"],
    price: json["price"],
    productId: json["product_id"],
    quantity: json["quantity"],
    salePrice: json["sale_price"],
    salePriceExcludingTax: json["sale_price_excluding_tax"],
    slug: json["slug"],
    symbol: json["symbol"],
    taxPercent: json["tax_percent"],
    title: json["title"],
    totalPrice: json["total_price"],
    unit: json["unit"],
  );

  Map<String, dynamic> toJson() => {
    "bank_transfer_discount_percent": bankTransferDiscountPercent,
    "cart_id": cartId,
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
    "old_price": oldPrice == null ? null : oldPrice,
    "price": price,
    "product_id": productId,
    "quantity": quantity,
    "sale_price": salePrice,
    "sale_price_excluding_tax": salePriceExcludingTax,
    "slug": slug,
    "symbol": symbol,
    "tax_percent": taxPercent,
    "title": title,
    "total_price": totalPrice,
    "unit": unit,
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
