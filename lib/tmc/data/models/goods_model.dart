// To parse this JSON data, do
//
//     final myGoodsModel = myGoodsModelFromJson(jsonString);

import 'dart:convert';

List<MyGoodsModel> myGoodsModelFromJson(String str) => List<MyGoodsModel>.from(json.decode(str).map((x) => MyGoodsModel.fromJson(x)));

String myGoodsModelToJson(List<MyGoodsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyGoodsModel {
    int? id;
    int? nazvanieId;
    String? barcode;
    String? productType;
    Product? product;
    int? userId;
    dynamic deleted;
    dynamic photoPath;
    GoodStatus? goodStatus;
    GoodStatus? tradeStatus;
    dynamic tradeData;

    MyGoodsModel({
        this.id,
        this.nazvanieId,
        this.barcode,
        this.productType,
        this.product,
        this.userId,
        this.deleted,
        this.photoPath,
        this.goodStatus,
        this.tradeStatus,
        this.tradeData,
    });

    factory MyGoodsModel.fromJson(Map<String, dynamic> json) => MyGoodsModel(
        id: json["id"],
        nazvanieId: json["nazvanie_id"],
        barcode: json["barcode"],
        productType: json["product_type"],
        product: json["product"] == null ? null : Product.fromJson(json["product"]),
        userId: json["user_id"],
        deleted: json["deleted"],
        photoPath: json["photo_path"],
        goodStatus: json["good_status"] == null ? null : GoodStatus.fromJson(json["good_status"]),
        tradeStatus: json["trade_status"] == null ? null : GoodStatus.fromJson(json["trade_status"]),
        tradeData: json["trade_data"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nazvanie_id": nazvanieId,
        "barcode": barcode,
        "product_type": productType,
        "product": product?.toJson(),
        "user_id": userId,
        "deleted": deleted,
        "photo_path": photoPath,
        "good_status": goodStatus?.toJson(),
        "trade_status": tradeStatus?.toJson(),
        "trade_data": tradeData,
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
