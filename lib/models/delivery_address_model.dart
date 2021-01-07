// To parse this JSON data, do
//
//     final deliveryAddressModel = deliveryAddressModelFromJson(jsonString);

import 'dart:convert';

DeliveryAddressModel deliveryAddressModelFromJson(String str) => DeliveryAddressModel.fromJson(json.decode(str));

String deliveryAddressModelToJson(DeliveryAddressModel data) => json.encode(data.toJson());

class DeliveryAddressModel {
  DeliveryAddressModel({
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

  factory DeliveryAddressModel.fromJson(Map<String, dynamic> json) => DeliveryAddressModel(
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
    this.address,
    this.alias,
    this.city,
    this.cityId,
    this.country,
    this.countryId,
    this.guid,
    this.identityNo,
    this.mobile,
    this.name,
    this.phone,
    this.postcode,
    this.surname,
    this.town,
    this.townId,
  });

  String address;
  String alias;
  City city;
  String cityId;
  Country country;
  String countryId;
  String guid;
  String identityNo;
  String mobile;
  String name;
  dynamic phone;
  String postcode;
  String surname;
  Town town;
  String townId;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    address: json["address"],
    alias: json["alias"],
    city: City.fromJson(json["city"]),
    cityId: json["city_id"],
    country: Country.fromJson(json["country"]),
    countryId: json["country_id"],
    guid: json["guid"],
    identityNo: json["identity_no"],
    mobile: json["mobile"],
    name: json["name"],
    phone: json["phone"],
    postcode: json["postcode"],
    surname: json["surname"],
    town: Town.fromJson(json["town"]),
    townId: json["town_id"],
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "alias": alias,
    "city": city.toJson(),
    "city_id": cityId,
    "country": country.toJson(),
    "country_id": countryId,
    "guid": guid,
    "identity_no": identityNo,
    "mobile": mobile,
    "name": name,
    "phone": phone,
    "postcode": postcode,
    "surname": surname,
    "town": town.toJson(),
    "town_id": townId,
  };
}

class City {
  City({
    this.countryId,
    this.createdAt,
    this.createdBy,
    this.id,
    this.phoneCode,
    this.plateCode,
    this.title,
    this.updatedAt,
    this.updatedBy,
  });

  String countryId;
  DateTime createdAt;
  String createdBy;
  int id;
  dynamic phoneCode;
  dynamic plateCode;
  String title;
  dynamic updatedAt;
  dynamic updatedBy;

  factory City.fromJson(Map<String, dynamic> json) => City(
    countryId: json["country_id"],
    createdAt: DateTime.parse(json["created_at"]),
    createdBy: json["created_by"],
    id: json["id"],
    phoneCode: json["phone_code"],
    plateCode: json["plate_code"],
    title: json["title"],
    updatedAt: json["updated_at"],
    updatedBy: json["updated_by"],
  );

  Map<String, dynamic> toJson() => {
    "country_id": countryId,
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "id": id,
    "phone_code": phoneCode,
    "plate_code": plateCode,
    "title": title,
    "updated_at": updatedAt,
    "updated_by": updatedBy,
  };
}

class Country {
  Country({
    this.binaryCode,
    this.createdAt,
    this.createdBy,
    this.currencyId,
    this.id,
    this.isActive,
    this.phoneCode,
    this.title,
    this.tripleCode,
    this.updatedAt,
    this.updatedBy,
  });

  String binaryCode;
  DateTime createdAt;
  String createdBy;
  String currencyId;
  int id;
  String isActive;
  String phoneCode;
  String title;
  String tripleCode;
  dynamic updatedAt;
  dynamic updatedBy;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    binaryCode: json["binary_code"],
    createdAt: DateTime.parse(json["created_at"]),
    createdBy: json["created_by"],
    currencyId: json["currency_id"],
    id: json["id"],
    isActive: json["is_active"],
    phoneCode: json["phone_code"],
    title: json["title"],
    tripleCode: json["triple_code"],
    updatedAt: json["updated_at"],
    updatedBy: json["updated_by"],
  );

  Map<String, dynamic> toJson() => {
    "binary_code": binaryCode,
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "currency_id": currencyId,
    "id": id,
    "is_active": isActive,
    "phone_code": phoneCode,
    "title": title,
    "triple_code": tripleCode,
    "updated_at": updatedAt,
    "updated_by": updatedBy,
  };
}

class Town {
  Town({
    this.cityId,
    this.createdAt,
    this.createdBy,
    this.id,
    this.title,
    this.updatedAt,
    this.updatedBy,
  });

  String cityId;
  DateTime createdAt;
  String createdBy;
  int id;
  String title;
  dynamic updatedAt;
  dynamic updatedBy;

  factory Town.fromJson(Map<String, dynamic> json) => Town(
    cityId: json["city_id"],
    createdAt: DateTime.parse(json["created_at"]),
    createdBy: json["created_by"],
    id: json["id"],
    title: json["title"],
    updatedAt: json["updated_at"],
    updatedBy: json["updated_by"],
  );

  Map<String, dynamic> toJson() => {
    "city_id": cityId,
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "id": id,
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