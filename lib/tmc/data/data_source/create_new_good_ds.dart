import 'dart:io';
import 'package:dio/dio.dart';
import 'package:planup/tmc/data/models/all_goods_model.dart';
import 'package:planup/tmc/data/models/single_good_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateNewGoodDs {
  final Dio dio;
  final SharedPreferences preferences;
  CreateNewGoodDs({required this.dio, required this.preferences});

  Future<SingleGoodModel> createNewGood({
    required String id,
    required String barcode,
    required String goodStatusId,
    required String productType,
    File? photo,
  }) async {
    final formData = FormData.fromMap({
      "nazvanie_id": id,
      "barcode": barcode,
      "good_status_id": goodStatusId,
      "product_type": productType,
      if (photo != null) "photo_path": await MultipartFile.fromFile(photo.path),
    });

    final Response response = await dio.post(
      "goods/",
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
          "Authorization": "Bearer ${preferences.getString("bearerToken")}"
        },
      ),
    );

    return SingleGoodModel.fromJson(response.data);
  }
}
