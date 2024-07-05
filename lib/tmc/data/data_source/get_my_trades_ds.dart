import 'package:dio/dio.dart';
import 'package:planup/tmc/data/models/transfer_good_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetMyTradesDs {
  final Dio dio;
  final SharedPreferences preferences;

  GetMyTradesDs({required this.dio, required this.preferences});
  Future<TransferGoodModel> getMyTrades({required String id}) async {
    final Response response = await dio.get(
        "trades/user/story/?id=$id&page=1&page_size=100000000",
        options: Options(headers: {
          "Authorization": "Bearer ${preferences.getString("bearerToken")}"
        }));
        return TransferGoodModel.fromJson(response.data);
    // List responseList = response.data;
    // return responseList
    //     .map((toElement) => TransferGoodModel.fromJson(toElement))
    //     .toList();
  }
}
