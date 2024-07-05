import 'package:dio/dio.dart';
import 'package:planup/tmc/data/models/transfer_good_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AcceptTradeDs {
  final Dio dio;
  final SharedPreferences preferences;
  AcceptTradeDs({required this.dio, required this.preferences});
  Future<TransferGoodModel> acceptTrade({required String id}) async {
    final Response response = await dio.post("trades/$id/accept",
        options: Options(headers: {
          "Authorization": "Bearer ${preferences.getString("bearerToken")}"
        }));
    return TransferGoodModel.fromJson(response.data);
  }
}
