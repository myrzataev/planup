// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

List<CategoryModel> categoryModelFromJson(String str) => List<CategoryModel>.from(json.decode(str).map((x) => CategoryModel.fromJson(x)));

String categoryModelToJson(List<CategoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryModel {
    int? cableManufactureId;
    int? cableModelId;
    double? cost;
    int? id;
    Manufacture? manufacture;
    Manufacture? model;

    CategoryModel({
        this.cableManufactureId,
        this.cableModelId,
        this.cost,
        this.id,
        this.manufacture,
        this.model,
    });

    factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        cableManufactureId: json["cable_manufacture_id"],
        cableModelId: json["cable_model_id"],
        cost: json["cost"],
        id: json["id"],
        manufacture: json["manufacture"] == null ? null : Manufacture.fromJson(json["manufacture"]),
        model: json["model"] == null ? null : Manufacture.fromJson(json["model"]),
    );

    Map<String, dynamic> toJson() => {
        "cable_manufacture_id": cableManufactureId,
        "cable_model_id": cableModelId,
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
