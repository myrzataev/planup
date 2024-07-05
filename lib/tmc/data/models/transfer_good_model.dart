// To parse this JSON data, do
//
//     final transferGoodModel = transferGoodModelFromJson(jsonString);

import 'dart:convert';

TransferGoodModel transferGoodModelFromJson(String str) => TransferGoodModel.fromJson(json.decode(str));

String transferGoodModelToJson(TransferGoodModel data) => json.encode(data.toJson());

class TransferGoodModel {
    List<Datum>? data;
    int? totalPages;
    int? totalCount;
    int? currentPage;

    TransferGoodModel({
        this.data,
        this.totalPages,
        this.totalCount,
        this.currentPage,
    });

    factory TransferGoodModel.fromJson(Map<String, dynamic> json) => TransferGoodModel(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        totalPages: json["total_pages"],
        totalCount: json["total_count"],
        currentPage: json["current_page"],
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_count": totalCount,
        "current_page": currentPage,
    };
}

class Datum {
    int? sourceUserId;
    int? destinationUserId;
    int? goodId;
    String? createDate;
    String? approvedDate;
    String? comment;
    int? tradeStatusId;
    bool? isDeleted;
    int? id;

    Datum({
        this.sourceUserId,
        this.destinationUserId,
        this.goodId,
        this.createDate,
        this.approvedDate,
        this.comment,
        this.tradeStatusId,
        this.isDeleted,
        this.id,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        sourceUserId: json["source_user_id"],
        destinationUserId: json["destination_user_id"],
        goodId: json["good_id"],
        createDate: json["create_date"],
        approvedDate: json["approved_date"],
        comment: json["comment"],
        tradeStatusId: json["trade_status_id"],
        isDeleted: json["is_deleted"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "source_user_id": sourceUserId,
        "destination_user_id": destinationUserId,
        "good_id": goodId,
        "create_date": createDate,
        "approved_date": approvedDate,
        "comment": comment,
        "trade_status_id": tradeStatusId,
        "is_deleted": isDeleted,
        "id": id,
    };
}
