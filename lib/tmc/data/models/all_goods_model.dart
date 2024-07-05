// To parse this JSON data, do
//
//     final allGoodsModel = allGoodsModelFromJson(jsonString);

import 'dart:convert';

AllGoodsModel allGoodsModelFromJson(String str) => AllGoodsModel.fromJson(json.decode(str));

String allGoodsModelToJson(AllGoodsModel data) => json.encode(data.toJson());

class AllGoodsModel {
    List<Datum>? data;
    int? totalPages;
    int? currentPage;
    int? pageSize;
    int? totalCount;

    AllGoodsModel({
        this.data,
        this.totalPages,
        this.currentPage,
        this.pageSize,
        this.totalCount,
    });

    factory AllGoodsModel.fromJson(Map<String, dynamic> json) => AllGoodsModel(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        totalPages: json["total_pages"],
        currentPage: json["current_page"],
        pageSize: json["page_size"],
        totalCount: json["total_count"],
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "total_pages": totalPages,
        "current_page": currentPage,
        "page_size": pageSize,
        "total_count": totalCount,
    };
}

class Datum {
    int? id;
    int? nazvanieId;
    String? barcode;
    String? productType;
    Product? product;
    dynamic deleted;
    dynamic photoPath;
    GoodStatus? goodStatus;

    Datum({
        this.id,
        this.nazvanieId,
        this.barcode,
        this.productType,
        this.product,
        this.deleted,
        this.photoPath,
        this.goodStatus,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        nazvanieId: json["nazvanie_id"],
        barcode: json["barcode"],
        productType: json["product_type"],
        product: json["product"] == null ? null : Product.fromJson(json["product"]),
        deleted: json["deleted"],
        photoPath: json["photo_path"],
        goodStatus: json["good_status"] == null ? null : GoodStatus.fromJson(json["good_status"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nazvanie_id": nazvanieId,
        "barcode": barcode,
        "product_type": productType,
        "product": product?.toJson(),
        "deleted": deleted,
        "photo_path": photoPath,
        "good_status": goodStatus?.toJson(),
    };
}

class GoodStatus {
    String? name;
    int? id;

    GoodStatus({
        this.name,
        this.id,
    });

    factory GoodStatus.fromJson(Map<String, dynamic> json) => GoodStatus(
        name: json["name"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
    };
}

class Product {
    int? productManufactureId;
    int? productModelId;
    double? cost;
    int? id;
    GoodStatus? manufacture;
    GoodStatus? model;

    Product({
        this.productManufactureId,
        this.productModelId,
        this.cost,
        this.id,
        this.manufacture,
        this.model,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        productManufactureId: json["product_manufacture_id"],
        productModelId: json["product_model_id"],
        cost: json["cost"],
        id: json["id"],
        manufacture: json["manufacture"] == null ? null : GoodStatus.fromJson(json["manufacture"]),
        model: json["model"] == null ? null : GoodStatus.fromJson(json["model"]),
    );

    Map<String, dynamic> toJson() => {
        "product_manufacture_id": productManufactureId,
        "product_model_id": productModelId,
        "cost": cost,
        "id": id,
        "manufacture": manufacture?.toJson(),
        "model": model?.toJson(),
    };
}
