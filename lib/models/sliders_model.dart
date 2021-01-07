// To parse this JSON data, do
//
//     final slidersModels = slidersModelFromJson(jsonString);

import 'dart:convert';

SlidersModel slidersModelFromJson(String str) => SlidersModel.fromJson(json.decode(str));

String slidersModelsToJson(SlidersModel data) => json.encode(data.toJson());

class SlidersModel {
    SlidersModel({
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

    factory SlidersModel.fromJson(Map<String, dynamic> json) => SlidersModel(
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
        this.categoryId,
        this.id,
        this.mobilePath,
        this.sort,
        this.title,
    });

    String categoryId;
    int id;
    String mobilePath;
    String sort;
    String title;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        categoryId: json["category_id"] == null ? null : json["category_id"],
        id: json["id"],
        mobilePath: json["mobile_path"],
        sort: json["sort"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "category_id": categoryId == null ? null : categoryId,
        "id": id,
        "mobile_path": mobilePath,
        "sort": sort,
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
