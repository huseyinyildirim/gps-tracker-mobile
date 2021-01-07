// To parse this JSON data, do
//
//     final categoriesModels = categoriesModelFromJson(jsonString);

import 'dart:convert';

CategoriesModel categoriesModelFromJson(String str) => CategoriesModel.fromJson(json.decode(str));

String categoriesModelsToJson(CategoriesModel data) => json.encode(data.toJson());

class CategoriesModel {
    CategoriesModel({
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

    factory CategoriesModel.fromJson(Map<String, dynamic> json) => CategoriesModel(
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
        this.imagePath,
        this.isInstallment,
        this.isShowDiscountProduct,
        this.isShowMainNavigation,
        this.isShowNewProduct,
        this.parentCategoryId,
        this.productDisplayType,
        this.sort,
        this.subCategoryCount,
        this.title,
        this.slug,
    });

    String categoryId;
    int id;
    dynamic imagePath;
    String isInstallment;
    String isShowDiscountProduct;
    String isShowMainNavigation;
    String isShowNewProduct;
    String parentCategoryId;
    String productDisplayType;
    String sort;
    String subCategoryCount;
    String title;
    String slug;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        categoryId: json["category_id"],
        id: json["id"],
        imagePath: json["image_path"],
        isInstallment: json["is_installment"],
        isShowDiscountProduct: json["is_show_discount_product"],
        isShowMainNavigation: json["is_show_main_navigation"],
        isShowNewProduct: json["is_show_new_product"],
        parentCategoryId: json["parent_category_id"],
        productDisplayType: json["product_display_type"],
        sort: json["sort"],
        subCategoryCount: json["sub_category_count"],
        title: json["title"],
        slug: json["slug"],
    );

    Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "id": id,
        "image_path": imagePath,
        "is_installment": isInstallment,
        "is_show_discount_product": isShowDiscountProduct,
        "is_show_main_navigation": isShowMainNavigation,
        "is_show_new_product": isShowNewProduct,
        "parent_category_id": parentCategoryId,
        "product_display_type": productDisplayType,
        "sort": sort,
        "sub_category_count": subCategoryCount,
        "title": title,
        "slug": slug,
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
