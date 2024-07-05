import 'package:dio/dio.dart';
import 'package:planup/tmc/data/models/create_goods_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateCategoryDs {
  final Dio dio;
  final SharedPreferences preferences;

  CreateCategoryDs({required this.dio, required this.preferences});
  Future<CreateCategoryModel> createCategory(
      {required String urlRoute,
      required String productManufactureId,
      required String cost,
      required String productModelId}) async {
    final Response response = await dio.post("$urlRoute/",
        data: {
          "cost": int.parse(cost),
          "product_manufacture_id": productManufactureId,
          "product_model_id": productModelId
        },
        options: Options(headers: {
          "Authorization": "Bearer ${preferences.getString("bearerToken")}"
        })
        );
    return CreateCategoryModel.fromJson(response.data);
  }
}
