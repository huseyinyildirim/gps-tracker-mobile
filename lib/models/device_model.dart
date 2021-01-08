// To parse this JSON data, do
//
//     final deviceModel = deviceModelFromJson(jsonString);

import 'dart:convert';

DeviceModel deviceModelFromJson(String str) => DeviceModel.fromJson(json.decode(str));

String deviceModelToJson(DeviceModel data) => json.encode(data.toJson());

class DeviceModel {
  DeviceModel({
    this.status,
    this.statusCode,
    this.systemTime,
    this.data,
    this.message,
    this.locale,
    this.error,
  });

  String status;
  int statusCode;
  int systemTime;
  List<Datum> data;
  dynamic message;
  String locale;
  Error error;

  factory DeviceModel.fromJson(Map<String, dynamic> json) => DeviceModel(
    status: json["status"],
    statusCode: json["statusCode"],
    systemTime: json["systemTime"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    message: json["message"],
    locale: json["locale"],
    error: Error.fromJson(json["error"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "systemTime": systemTime,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
    "locale": locale,
    "error": error.toJson(),
  };
}

class Datum {
  Datum({
    this.id,
    this.title,
    this.serialNo,
    this.secretKey,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  int id;
  String title;
  String serialNo;
  String secretKey;
  DateTime createdAt;
  int createdBy;
  dynamic updatedAt;
  dynamic updatedBy;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    serialNo: json["serial_no"],
    secretKey: json["secret_key"],
    createdAt: DateTime.parse(json["created_at"]),
    createdBy: json["created_by"],
    updatedAt: json["updated_at"],
    updatedBy: json["updated_by"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "serial_no": serialNo,
    "secret_key": secretKey,
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "updated_at": updatedAt,
    "updated_by": updatedBy,
  };
}

class Error {
  Error({
    this.message,
    this.internalMessage,
    this.help,
  });

  dynamic message;
  dynamic internalMessage;
  dynamic help;

  factory Error.fromJson(Map<String, dynamic> json) => Error(
    message: json["message"],
    internalMessage: json["internalMessage"],
    help: json["help"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "internalMessage": internalMessage,
    "help": help,
  };
}