// To parse this JSON data, do
//
//     final customerModel = customerModelFromJson(jsonString);

import 'dart:convert';

CustomerModel customerModelFromJson(String str) => CustomerModel.fromJson(json.decode(str));

String customerModelToJson(CustomerModel data) => json.encode(data.toJson());

class CustomerModel {
  CustomerModel({
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
  Data data;
  dynamic message;
  String locale;
  Error error;

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
    status: json["status"] == null ? null : json["status"],
    statusCode: json["statusCode"] == null ? null : json["statusCode"],
    systemTime: json["systemTime"] == null ? null : json["systemTime"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    message: json["message"],
    locale: json["locale"] == null ? null : json["locale"],
    error: json["error"] == null ? null : Error.fromJson(json["error"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "statusCode": statusCode == null ? null : statusCode,
    "systemTime": systemTime == null ? null : systemTime,
    "data": data == null ? null : data.toJson(),
    "message": message,
    "locale": locale == null ? null : locale,
    "error": error == null ? null : error.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.name,
    this.surname,
    this.mail,
    this.phone,
    this.password,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  int id;
  String name;
  String surname;
  String mail;
  String phone;
  String password;
  DateTime createdAt;
  dynamic createdBy;
  dynamic updatedAt;
  dynamic updatedBy;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    surname: json["surname"] == null ? null : json["surname"],
    mail: json["mail"] == null ? null : json["mail"],
    phone: json["phone"] == null ? null : json["phone"],
    password: json["password"] == null ? null : json["password"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    createdBy: json["created_by"],
    updatedAt: json["updated_at"],
    updatedBy: json["updated_by"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "surname": surname == null ? null : surname,
    "mail": mail == null ? null : mail,
    "phone": phone == null ? null : phone,
    "password": password == null ? null : password,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
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
