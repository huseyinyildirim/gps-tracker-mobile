// To parse this JSON data, do
//
//     final cartTotalsModel = cartTotalsModelFromJson(jsonString);

import 'dart:convert';

CartTotalsModel cartTotalsModelFromJson(String str) => CartTotalsModel.fromJson(json.decode(str));

String cartTotalsModelToJson(CartTotalsModel data) => json.encode(data.toJson());

class CartTotalsModel {
  CartTotalsModel({
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

  factory CartTotalsModel.fromJson(Map<String, dynamic> json) => CartTotalsModel(
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
    this.currency,
    this.discount,
    this.orderTotal,
    this.paymentTotal,
    this.shippingCost,
    this.subtotal,
    this.subtotalExcludingTax,
    this.vatTotal,
  });

  String currency;
  String discount;
  String orderTotal;
  String paymentTotal;
  String shippingCost;
  String subtotal;
  String subtotalExcludingTax;
  String vatTotal;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currency: json["currency"],
    discount: json["discount"],
    orderTotal: json["order_total"],
    paymentTotal: json["payment_total"],
    shippingCost: json["shipping_cost"],
    subtotal: json["subtotal"],
    subtotalExcludingTax: json["subtotal_excluding_tax"],
    vatTotal: json["vat_total"],
  );

  Map<String, dynamic> toJson() => {
    "currency": currency,
    "discount": discount,
    "order_total": orderTotal,
    "payment_total": paymentTotal,
    "shipping_cost": shippingCost,
    "subtotal": subtotal,
    "subtotal_excluding_tax": subtotalExcludingTax,
    "vat_total": vatTotal,
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
