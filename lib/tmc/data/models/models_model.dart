// To parse this JSON data, do
//
//     final goodsModelsModel = goodsModelsModelFromJson(jsonString);

import 'dart:convert';

List<GoodsModelsModel> goodsModelsModelFromJson(String str) => List<GoodsModelsModel>.from(json.decode(str).map((x) => GoodsModelsModel.fromJson(x)));

String goodsModelsModelToJson(List<GoodsModelsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GoodsModelsModel {
    int? id;
    String? name;

    GoodsModelsModel({
        this.id,
        this.name,
    });

    factory GoodsModelsModel.fromJson(Map<String, dynamic> json) => GoodsModelsModel(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
