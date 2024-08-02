// To parse this JSON data, do
//
//     final deletedGoodsModel = deletedGoodsModelFromJson(jsonString);

import 'dart:convert';

List<DeletedGoodsModel> deletedGoodsModelFromJson(String str) => List<DeletedGoodsModel>.from(json.decode(str).map((x) => DeletedGoodsModel.fromJson(x)));

String deletedGoodsModelToJson(List<DeletedGoodsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DeletedGoodsModel {
    int? id;
    int? nazvanieId;
    String? barcode;
    String? productType;
    Product? product;
    DateTime? deleted;
    dynamic photoPath;
    GoodStatus? goodStatus;

    DeletedGoodsModel({
        this.id,
        this.nazvanieId,
        this.barcode,
        this.productType,
        this.product,
        this.deleted,
        this.photoPath,
        this.goodStatus,
    });

    factory DeletedGoodsModel.fromJson(Map<String, dynamic> json) => DeletedGoodsModel(
        id: json["id"],
        nazvanieId: json["nazvanie_id"],
        barcode: json["barcode"],
        productType: json["product_type"],
        product: json["product"] == null ? null : Product.fromJson(json["product"]),
        deleted: json["deleted"] == null ? null : DateTime.parse(json["deleted"]),
        photoPath: json["photo_path"],
        goodStatus: json["good_status"] == null ? null : GoodStatus.fromJson(json["good_status"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nazvanie_id": nazvanieId,
        "barcode": barcode,
        "product_type": productType,
        "product": product?.toJson(),
        "deleted": deleted?.toIso8601String(),
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
    int? id;
    double? cost;
    int? productManufactureId;
    int? productModelId;
    GoodStatus? manufacture;
    GoodStatus? model;

    Product({
        this.id,
        this.cost,
        this.productManufactureId,
        this.productModelId,
        this.manufacture,
        this.model,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        cost: json["cost"],
        productManufactureId: json["product_manufacture_id"],
        productModelId: json["product_model_id"],
        manufacture: json["manufacture"] == null ? null : GoodStatus.fromJson(json["manufacture"]),
        model: json["model"] == null ? null : GoodStatus.fromJson(json["model"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "cost": cost,
        "product_manufacture_id": productManufactureId,
        "product_model_id": productModelId,
        "manufacture": manufacture?.toJson(),
        "model": model?.toJson(),
    };
}
