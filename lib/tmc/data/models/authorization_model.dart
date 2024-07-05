// To parse this JSON data, do
//
//     final authorizationModel = authorizationModelFromJson(jsonString);

import 'dart:convert';

AuthorizationModel authorizationModelFromJson(String str) => AuthorizationModel.fromJson(json.decode(str));

String authorizationModelToJson(AuthorizationModel data) => json.encode(data.toJson());

class AuthorizationModel {
    String? accessToken;
    String? tokenType;
    String? username;
    int? userId;
    String? permissionName;

    AuthorizationModel({
        this.accessToken,
        this.tokenType,
        this.username,
        this.userId,
        this.permissionName,
    });

    factory AuthorizationModel.fromJson(Map<String, dynamic> json) => AuthorizationModel(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        username: json["username"],
        userId: json["user_id"],
        permissionName: json["permission_name"],
    );

    Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "username": username,
        "user_id": userId,
        "permission_name": permissionName,
    };
}
