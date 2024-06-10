// To parse this JSON data, do
//
//     final newsListModel = newsListModelFromJson(jsonString);

import 'dart:convert';

NewsListModel newsListModelFromJson(String str) => NewsListModel.fromJson(json.decode(str));

String newsListModelToJson(NewsListModel data) => json.encode(data.toJson());

class NewsListModel {
    List<News>? news;

    NewsListModel({
        this.news,
    });

    factory NewsListModel.fromJson(Map<String, dynamic> json) => NewsListModel(
        news: json["news"] == null ? [] : List<News>.from(json["news"]!.map((x) => News.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "news": news == null ? [] : List<dynamic>.from(news!.map((x) => x.toJson())),
    };
}

class News {
    int? id;
    String? image;
    String? title;
    String? description;
    DateTime? createdAt;
    DateTime? updatedAt;

    News({
        this.id,
        this.image,
        this.title,
        this.description,
        this.createdAt,
        this.updatedAt,
    });

    factory News.fromJson(Map<String, dynamic> json) => News(
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
