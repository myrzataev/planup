import 'package:dio/dio.dart';
import 'package:planup/tmc/data/models/deleted_goods_model.dart';

class GetDeletedGoodsDs {
  final Dio dio;
  GetDeletedGoodsDs({required this.dio});
  Future<List<DeletedGoodsModel>> getDeletedGoodsList() async {
    final Response response =
        await dio.get("soft_deleted_goods/?page=1&page_size=100000000");
    List responseList = response.data;
    return responseList
        .map((toElement) => DeletedGoodsModel.fromJson(toElement))
        .toList();
  }
}
