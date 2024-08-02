// To parse this JSON data, do
//
//     final makeMultipleTradeModel = makeMultipleTradeModelFromJson(jsonString);

import 'dart:convert';

MakeMultipleTradeModel makeMultipleTradeModelFromJson(String str) => MakeMultipleTradeModel.fromJson(json.decode(str));

String makeMultipleTradeModelToJson(MakeMultipleTradeModel data) => json.encode(data.toJson());

class MakeMultipleTradeModel {
    List<Trade>? trades;

    MakeMultipleTradeModel({
        this.trades,
    });

    factory MakeMultipleTradeModel.fromJson(Map<String, dynamic> json) => MakeMultipleTradeModel(
        trades: json["trades"] == null ? [] : List<Trade>.from(json["trades"]!.map((x) => Trade.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "trades": trades == null ? [] : List<dynamic>.from(trades!.map((x) => x.toJson())),
    };
}

class Trade {
    int? sourceUserId;
    int? destinationUserId;
    int? goodId;
    int? tradeStatusId;

    Trade({
        this.sourceUserId,
        this.destinationUserId,
        this.goodId,
        this.tradeStatusId,
    });

    factory Trade.fromJson(Map<String, dynamic> json) => Trade(
        sourceUserId: json["source_user_id"],
        destinationUserId: json["destination_user_id"],
        goodId: json["good_id"],
        tradeStatusId: json["trade_status_id"],
    );

    Map<String, dynamic> toJson() => {
        "source_user_id": sourceUserId,
        "destination_user_id": destinationUserId,
        "good_id": goodId,
        "trade_status_id": tradeStatusId,
    };
}
