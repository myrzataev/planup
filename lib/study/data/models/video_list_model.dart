// To parse this JSON data, do
//
//     final videoListModel = videoListModelFromJson(jsonString);

import 'dart:convert';

VideoListModel videoListModelFromJson(String str) => VideoListModel.fromJson(json.decode(str));

String videoListModelToJson(VideoListModel data) => json.encode(data.toJson());

class VideoListModel {
    List<Tutorial>? tutorial;

    VideoListModel({
        this.tutorial,
    });

    factory VideoListModel.fromJson(Map<String, dynamic> json) => VideoListModel(
        tutorial: json["tutorial"] == null ? [] : List<Tutorial>.from(json["tutorial"]!.map((x) => Tutorial.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "tutorial": tutorial == null ? [] : List<dynamic>.from(tutorial!.map((x) => x.toJson())),
    };
}

class Tutorial {
    int? id;
    String? image;
    String? title;
    String? description;
    String? video;
    DateTime? createdAt;
    DateTime? updatedAt;

    Tutorial({
        this.id,
        this.image,
        this.title,
        this.description,
        this.video,
        this.createdAt,
        this.updatedAt,
    });

    factory Tutorial.fromJson(Map<String, dynamic> json) => Tutorial(
        id: json["id"],
        image: json["image"],
        title: json["title"],
        description: json["description"],
        video: json["video"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "title": title,
        "description": description,
        "video": video,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
