// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  CategoryModel({
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

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
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
    this.categoryId,
    this.id,
    this.imagePath,
    this.isInstallment,
    this.isShowDiscountProduct,
    this.isShowMainNavigation,
    this.isShowNewProduct,
    this.productDisplayType,
    this.slug,
    this.sort,
    this.title,
  });

  String categoryId;
  int id;
  dynamic imagePath;
  String isInstallment;
  String isShowDiscountProduct;
  String isShowMainNavigation;
  String isShowNewProduct;
  String productDisplayType;
  String slug;
  String sort;
  String title;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    categoryId: json["category_id"],
    id: json["id"],
    imagePath: json["image_path"],
    isInstallment: json["is_installment"],
    isShowDiscountProduct: json["is_show_discount_product"],
    isShowMainNavigation: json["is_show_main_navigation"],
    isShowNewProduct: json["is_show_new_product"],
    productDisplayType: json["product_display_type"],
    slug: json["slug"],
    sort: json["sort"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "category_id": categoryId,
    "id": id,
    "image_path": imagePath,
    "is_installment": isInstallment,
    "is_show_discount_product": isShowDiscountProduct,
    "is_show_main_navigation": isShowMainNavigation,
    "is_show_new_product": isShowNewProduct,
    "product_display_type": productDisplayType,
    "slug": slug,
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
