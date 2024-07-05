import 'package:dio/dio.dart';
import 'package:planup/tmc/data/models/transfer_good_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetTradeHistoryDs {
  final Dio dio;
  final SharedPreferences preferences;
  GetTradeHistoryDs({required this.dio, required this.preferences});
  Future<List<TransferGoodModel>> getTransfersHistory() async {
    final Response response = await dio.get("trades",
        options: Options(headers: {
          "Authorization": "Bearer ${preferences.getString("bearerToken")}"
        }));
    List responseList = response.data;
    return responseList
        .map((toElement) => TransferGoodModel.fromJson(toElement))
        .toList();
  }
}
