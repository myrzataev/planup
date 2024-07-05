import 'package:dio/dio.dart';
import 'package:planup/tmc/data/models/transfer_good_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetUserTradeHistoryDs {
  final Dio dio;
  final SharedPreferences preferences;
  GetUserTradeHistoryDs({required this.dio, required this.preferences});
  Future<TransferGoodModel> getUsersTradeHistory() async {
    final Response response = await dio.get(
        "trades/user/story/?page=1&page_size=100000000",
        options: Options(headers: {
          "Authorization": "Bearer ${preferences.getString("bearerToken")}"
        }));
    
   return TransferGoodModel.fromJson(response.data);
  }
}
