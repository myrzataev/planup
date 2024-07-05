// To parse this JSON data, do
//
//     final createGoodsModel = createGoodsModelFromJson(jsonString);

import 'dart:convert';

CreateCategoryModel createGoodsModelFromJson(String str) => CreateCategoryModel.fromJson(json.decode(str));

String createGoodsModelToJson(CreateCategoryModel data) => json.encode(data.toJson());

class CreateCategoryModel {
    int? productManufactureId;
    int? productModelId;
    double? cost;
    int? id;
    Manufacture? manufacture;
    Manufacture? model;

    CreateCategoryModel({
        this.productManufactureId,
        this.productModelId,
        this.cost,
        this.id,
        this.manufacture,
        this.model,
    });

    factory CreateCategoryModel.fromJson(Map<String, dynamic> json) => CreateCategoryModel(
        productManufactureId: json["product_manufacture_id"],
        productModelId: json["product_model_id"],
        cost: json["cost"],
        id: json["id"],
        manufacture: json["manufacture"] == null ? null : Manufacture.fromJson(json["manufacture"]),
        model: json["model"] == null ? null : Manufacture.fromJson(json["model"]),
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

class Manufacture {
    String? name;
    int? id;

    Manufacture({
        this.name,
        this.id,
    });

    factory Manufacture.fromJson(Map<String, dynamic> json) => Manufacture(
        name: json["name"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
    };
}
