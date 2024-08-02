import 'package:dio/dio.dart';
import 'package:planup/tmc/data/models/make_multiple_trade_model.dart';
import 'package:planup/tmc/data/models/multiple_trades_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TradeMultipleGoodsDs {
  final Dio dio;
  final SharedPreferences preferences;
  TradeMultipleGoodsDs({required this.dio, required this.preferences});
  Future<List<MultipleTradesModel>> multipleTrade(
      {required MakeMultipleTradeModel model
      //   required String sourceUserId,
      // required String destinationUserId,
      // required String goodId,
      // required String tradeStatus
      }) async {
    final Response response = await dio.post("trades/multiple",
        options: Options(headers: {
          "Authorization": "Bearer ${preferences.getString("bearerToken")}"
        }),
        data: model.toJson());
    List result = response.data;
    return result
        .map((toElement) => MultipleTradesModel.fromJson(toElement))
        .toList();
  }
}
