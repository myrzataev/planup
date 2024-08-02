import 'package:dio/dio.dart';
import 'package:planup/tmc/data/models/goods_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetMyGoodsDs {
  final Dio dio;
  final SharedPreferences preferences;
  GetMyGoodsDs({required this.dio, required this.preferences});
  Future<List<MyGoodsModel>> getMyGoods(String? productType) async {
    String url = "users/goods/?page=1&page_size=100000000";

    if (productType != null) {
      url += "&product_type=$productType";
    }
    final Response response = await dio.get(url,
        options: Options(headers: {
          "Authorization": "Bearer ${preferences.getString("bearerToken")}"
        }));
    List responseList = response.data;
    return responseList
        .map((toElement) => MyGoodsModel.fromJson(toElement))
        .toList();
  }
}
