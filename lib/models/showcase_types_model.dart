// To parse this JSON data, do
//
//     final showcaseTypesModels = showcaseTypesModelFromJson(jsonString);

import 'dart:convert';

ShowcaseTypesModel showcaseTypesModelFromJson(String str) => ShowcaseTypesModel.fromJson(json.decode(str));

String showcaseTypesModelsToJson(ShowcaseTypesModel data) => json.encode(data.toJson());

class ShowcaseTypesModel {
    ShowcaseTypesModel({
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

    factory ShowcaseTypesModel.fromJson(Map<String, dynamic> json) => ShowcaseTypesModel(
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
        this.id,
        this.isGroup,
        this.title,
    });

    int id;
    String isGroup;
    String title;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        isGroup: json["is_group"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "is_group": isGroup,
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
