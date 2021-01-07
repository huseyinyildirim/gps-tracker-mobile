// To parse this JSON data, do
//
//     final memberModel = memberModelFromJson(jsonString);

import 'dart:convert';

MemberModel memberModelFromJson(String str) => MemberModel.fromJson(json.decode(str));

String memberModelToJson(MemberModel data) => json.encode(data.toJson());

class MemberModel {
  MemberModel({
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

  factory MemberModel.fromJson(Map<String, dynamic> json) => MemberModel(
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
    this.id,
    this.mail,
    this.mobile,
    this.name,
    this.surname,
  });

  int id;
  String mail;
  String mobile;
  String name;
  String surname;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    mail: json["mail"],
    mobile: json["mobile"],
    name: json["name"],
    surname: json["surname"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mail": mail,
    "mobile": mobile,
    "name": name,
    "surname": surname,
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
