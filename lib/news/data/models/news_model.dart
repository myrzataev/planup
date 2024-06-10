// To parse this JSON data, do
//
//     final newsModel = newsModelFromJson(jsonString);

import 'dart:convert';

NewsModel newsModelFromJson(String str) => NewsModel.fromJson(json.decode(str));

String newsModelToJson(NewsModel data) => json.encode(data.toJson());

class NewsModel {
    int? id;
    String? image;
    String? title;
    String? description;
    DateTime? createdAt;
    DateTime? updatedAt;

    NewsModel({
        this.id,
        this.image,
        this.title,
        this.description,
        this.createdAt,
        this.updatedAt,
    });

    factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        id: json["id"],
        image: json["image"],
        title: json["title"],
        description: json["description"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "title": title,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
