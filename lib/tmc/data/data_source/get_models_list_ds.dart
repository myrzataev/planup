import 'package:dio/dio.dart';
import 'package:planup/tmc/data/models/models_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetModelsListDs {
  final Dio dio;
  final SharedPreferences preferences;

  GetModelsListDs({required this.dio, required this.preferences});
  Future<List<GoodsModelsModel>> getModelsList(
      {required String urlRoute}) async {
    final Response response = await dio.get(urlRoute,
        options: Options(headers: {
          "Authorization": "Bearer ${preferences.getString("bearerToken")}"
        })
        );
    List responseData = response.data;
    return responseData
        .map((toElement) => GoodsModelsModel.fromJson(toElement))
        .toList();
  }
}
