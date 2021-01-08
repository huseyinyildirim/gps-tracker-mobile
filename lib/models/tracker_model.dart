// To parse this JSON data, do
//
//     final trackerModel = trackerModelFromJson(jsonString);

import 'dart:convert';

TrackerModel trackerModelFromJson(String str) => TrackerModel.fromJson(json.decode(str));

String trackerModelToJson(TrackerModel data) => json.encode(data.toJson());

class TrackerModel {
  TrackerModel({
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

  factory TrackerModel.fromJson(Map<String, dynamic> json) => TrackerModel(
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
    this.deviceId,
    this.longitude,
    this.latitude,
    this.speed,
    this.ipAddress,
    this.createdAt,
  });

  int id;
  int deviceId;
  String longitude;
  String latitude;
  dynamic speed;
  String ipAddress;
  DateTime createdAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    deviceId: json["device_id"],
    longitude: json["longitude"],
    latitude: json["latitude"],
    speed: json["speed"],
    ipAddress: json["ip_address"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "device_id": deviceId,
    "longitude": longitude,
    "latitude": latitude,
    "speed": speed,
    "ip_address": ipAddress,
    "created_at": createdAt.toIso8601String(),
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