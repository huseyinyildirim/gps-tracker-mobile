// To parse this JSON data, do
//
//     final emptyModel = emptyModelFromJson(jsonString);

import 'dart:convert';

EmptyModel emptyModelFromJson(String str) => EmptyModel.fromJson(json.decode(str));

String emptyModelToJson(EmptyModel data) => json.encode(data.toJson());

class EmptyModel {
  EmptyModel({
    this.data,
    this.error,
    this.locale,
    this.message,
    this.status,
    this.statusCode,
    this.systemTime,
  });

  dynamic data;
  Error error;
  String locale;
  String message;
  String status;
  int statusCode;
  int systemTime;

  factory EmptyModel.fromJson(Map<String, dynamic> json) => EmptyModel(
    data: json["data"],
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