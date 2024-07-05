// To parse this JSON data, do
//
//     final singleGoodModel = singleGoodModelFromJson(jsonString);

import 'dart:convert';

SingleGoodModel singleGoodModelFromJson(String str) => SingleGoodModel.fromJson(json.decode(str));

String singleGoodModelToJson(SingleGoodModel data) => json.encode(data.toJson());

class SingleGoodModel {
    int? id;
    int? nazvanieId;
    String? barcode;
    String? productType;
    Product? product;
    dynamic deleted;
    dynamic photoPath;
    GoodStatus? goodStatus;

    SingleGoodModel({
        this.id,
        this.nazvanieId,
        this.barcode,
        this.productType,
        this.product,
        this.deleted,
        this.photoPath,
        this.goodStatus,
    });

    factory SingleGoodModel.fromJson(Map<String, dynamic> json) => SingleGoodModel(
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
