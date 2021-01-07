// To parse this JSON data, do
//
//     final showcasesModel = showcasesModelFromJson(jsonString);

import 'dart:convert';

ShowcasesModel showcasesModelFromJson(String str) => ShowcasesModel.fromJson(json.decode(str));

String showcasesModelToJson(ShowcasesModel data) => json.encode(data.toJson());

class ShowcasesModel {
  ShowcasesModel({
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

  factory ShowcasesModel.fromJson(Map<String, dynamic> json) => ShowcasesModel(
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
    this.createdAt,
    this.createdBy,
    this.id,
    this.isActive,
    this.showcaseTypeId,
    this.sort,
    this.title,
    this.updatedAt,
    this.updatedBy,
  });

  dynamic createdAt;
  String createdBy;
  int id;
  String isActive;
  String showcaseTypeId;
  String sort;
  String title;
  dynamic updatedAt;
  dynamic updatedBy;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    createdAt: json["created_at"],
    createdBy: json["created_by"],
    id: json["id"],
    isActive: json["is_active"],
    showcaseTypeId: json["showcase_type_id"],
    sort: json["sort"],
    title: json["title"],
    updatedAt: json["updated_at"],
    updatedBy: json["updated_by"],
  );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt,
    "created_by": createdBy,
    "id": id,
    "is_active": isActive,
    "showcase_type_id": showcaseTypeId,
    "sort": sort,
    "title": title,
    "updated_at": updatedAt,
    "updated_by": updatedBy,
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