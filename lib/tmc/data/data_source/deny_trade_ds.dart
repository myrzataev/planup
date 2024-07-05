import 'package:dio/dio.dart';
import 'package:planup/tmc/data/models/transfer_good_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DenyTradeDs {
  final Dio dio;
  final SharedPreferences preferences;
  DenyTradeDs({required this.dio, required this.preferences});
  Future<TransferGoodModel> denyTrade(
      {required String id, required String comment}) async {
    final Response response = await dio.post("trades/$id/deny",
        data: {"comment": comment},
        options: Options(headers: {
          "Authorization": "Bearer ${preferences.getString("bearerToken")}"
        }));
        return TransferGoodModel.fromJson(response.data);
  }
}
