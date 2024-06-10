// To parse this JSON data, do
//
//     final videoModel = videoModelFromJson(jsonString);

import 'dart:convert';

VideoModel videoModelFromJson(String str) => VideoModel.fromJson(json.decode(str));

String videoModelToJson(VideoModel data) => json.encode(data.toJson());

class VideoModel {
    int id;
    String image;
    String title;
    String description;
    String video;
    DateTime createdAt;
    DateTime updatedAt;

    VideoModel({
        required this.id,
        required this.image,
        required this.title,
        required this.description,
        required this.video,
        required this.createdAt,
        required this.updatedAt,
    });

    factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
        id: json["id"],
        image: json["image"],
        title: json["title"],
        description: json["description"],
        video: json["video"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "title": title,
        "description": description,
        "video": video,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
