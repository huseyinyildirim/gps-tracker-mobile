// To parse this JSON data, do
//
//     final townsModel = townsModelFromJson(jsonString);

import 'dart:convert';

TownsModel townsModelFromJson(String str) => TownsModel.fromJson(json.decode(str));

String townsModelToJson(TownsModel data) => json.encode(data.toJson());

class TownsModel {
  TownsModel({
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

  factory TownsModel.fromJson(Map<String, dynamic> json) => TownsModel(
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
    this.cityId,
    this.id,
    this.title,
  });

  String cityId;
  int id;
  String title;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    cityId: json["city_id"],
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "city_id": cityId,
    "id": id,
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
