// To parse this JSON data, do
//
//     final manufactureModel = manufactureModelFromJson(jsonString);

import 'dart:convert';

List<ManufactureModel> manufactureModelFromJson(String str) => List<ManufactureModel>.from(json.decode(str).map((x) => ManufactureModel.fromJson(x)));

String manufactureModelToJson(List<ManufactureModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ManufactureModel {
    int? id;
    String? name;

    ManufactureModel({
        this.id,
        this.name,
    });

    factory ManufactureModel.fromJson(Map<String, dynamic> json) => ManufactureModel(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
