// To parse this JSON data, do
//
//     final multipleTradesModel = multipleTradesModelFromJson(jsonString);

import 'dart:convert';

List<MultipleTradesModel> multipleTradesModelFromJson(String str) => List<MultipleTradesModel>.from(json.decode(str).map((x) => MultipleTradesModel.fromJson(x)));

String multipleTradesModelToJson(List<MultipleTradesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MultipleTradesModel {
    int? sourceUserId;
    int? destinationUserId;
    int? goodId;
    DateTime? createDate;
    dynamic approvedDate;
    dynamic comment;
    int? tradeStatusId;
    bool? isDeleted;
    int? id;
    TradeStatus? tradeStatus;

    MultipleTradesModel({
        this.sourceUserId,
        this.destinationUserId,
        this.goodId,
        this.createDate,
        this.approvedDate,
        this.comment,
        this.tradeStatusId,
        this.isDeleted,
        this.id,
        this.tradeStatus,
    });

    factory MultipleTradesModel.fromJson(Map<String, dynamic> json) => MultipleTradesModel(
        sourceUserId: json["source_user_id"],
        destinationUserId: json["destination_user_id"],
        goodId: json["good_id"],
        createDate: json["create_date"] == null ? null : DateTime.parse(json["create_date"]),
        approvedDate: json["approved_date"],
        comment: json["comment"],
        tradeStatusId: json["trade_status_id"],
        isDeleted: json["is_deleted"],
        id: json["id"],
        tradeStatus: json["trade_status"] == null ? null : TradeStatus.fromJson(json["trade_status"]),
    );

    Map<String, dynamic> toJson() => {
        "source_user_id": sourceUserId,
        "destination_user_id": destinationUserId,
        "good_id": goodId,
        "create_date": createDate?.toIso8601String(),
        "approved_date": approvedDate,
        "comment": comment,
        "trade_status_id": tradeStatusId,
        "is_deleted": isDeleted,
        "id": id,
        "trade_status": tradeStatus?.toJson(),
    };
}

class TradeStatus {
    String? name;
    int? id;

    TradeStatus({
        this.name,
        this.id,
    });

    factory TradeStatus.fromJson(Map<String, dynamic> json) => TradeStatus(
        name: json["name"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
    };
}
