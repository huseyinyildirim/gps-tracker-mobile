// To parse this JSON data, do
//
//     final productVideosModel = productVideosModelFromJson(jsonString);

import 'dart:convert';

ProductVideosModel productVideosModelFromJson(String str) => ProductVideosModel.fromJson(json.decode(str));

String productVideosModelToJson(ProductVideosModel data) => json.encode(data.toJson());

class ProductVideosModel {
  ProductVideosModel({
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

  factory ProductVideosModel.fromJson(Map<String, dynamic> json) => ProductVideosModel(
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
    this.thumbnailsDefault,
    this.thumbnailsHigh,
    this.thumbnailsMedium,
    this.videoId,
  });

  String thumbnailsDefault;
  String thumbnailsHigh;
  String thumbnailsMedium;
  String videoId;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    thumbnailsDefault: json["thumbnails_default"],
    thumbnailsHigh: json["thumbnails_high"],
    thumbnailsMedium: json["thumbnails_medium"],
    videoId: json["video_id"],
  );

  Map<String, dynamic> toJson() => {
    "thumbnails_default": thumbnailsDefault,
    "thumbnails_high": thumbnailsHigh,
    "thumbnails_medium": thumbnailsMedium,
    "video_id": videoId,
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