// To parse this JSON data, do
//
//     final productCommentsModel = productCommentsModelFromJson(jsonString);

import 'dart:convert';

ProductCommentsModel productCommentsModelFromJson(String str) => ProductCommentsModel.fromJson(json.decode(str));

String productCommentsModelToJson(ProductCommentsModel data) => json.encode(data.toJson());

class ProductCommentsModel {
  ProductCommentsModel({
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

  factory ProductCommentsModel.fromJson(Map<String, dynamic> json) => ProductCommentsModel(
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
    this.comment,
    this.createdAt,
    this.name,
    this.score,
    this.surname,
    this.title,
  });

  String comment;
  DateTime createdAt;
  String name;
  String score;
  String surname;
  String title;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    comment: json["comment"],
    createdAt: DateTime.parse(json["created_at"]),
    name: json["name"],
    score: json["score"],
    surname: json["surname"],
    title: json["title"] == null ? null : json["title"],
  );

  Map<String, dynamic> toJson() => {
    "comment": comment,
    "created_at": createdAt.toIso8601String(),
    "name": name,
    "score": score,
    "surname": surname,
    "title": title == null ? null : title,
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