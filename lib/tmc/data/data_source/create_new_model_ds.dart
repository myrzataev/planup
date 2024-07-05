import 'package:dio/dio.dart';
import 'package:planup/tmc/data/models/models_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateNewModelDs {
  final Dio dio;

   final SharedPreferences preferences;
  CreateNewModelDs({required this.dio, required this.preferences});
  Future<GoodsModelsModel> createNewModel(
      {required String urlRoute, required String nameOfModel}) async {
    final Response response = await dio.post("$urlRoute/", data: {
      "name": nameOfModel,
    },  options: Options(headers: {
      "Authorization": "Bearer ${preferences.getString("bearerToken")}"
    })
    );
    return GoodsModelsModel.fromJson(response.data);
  }
}
