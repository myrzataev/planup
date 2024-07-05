import 'dart:io';

import 'package:dio/dio.dart';
import 'package:planup/tmc/data/models/single_good_model.dart';

class EditGoodDataSource {
  final Dio dio;
  EditGoodDataSource({required this.dio});
  Future<SingleGoodModel> editGood({
    required String id,
    required String barcode,
    required String goodStatusId,
    required String productType,
    File? photo,
    required String nazvanieID,
    required String deleted,
  }) async {
    final formData = FormData.fromMap({
      "nazvanie_id": nazvanieID,
      "barcode": barcode,
      "good_status_id": goodStatusId,
      "product_type": productType,
      "id": id,
      "deleted": deleted,
      if (photo != null) "photo_path": await MultipartFile.fromFile(photo.path),
    });
    final Response response = await dio.put("goods/$id", data: formData);
    return SingleGoodModel.fromJson(response.data);
  }
}
