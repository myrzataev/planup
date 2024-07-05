import 'package:dio/dio.dart';
import 'package:planup/tmc/data/models/all_goods_model.dart';

class GetAllGoodsDs {
  final Dio dio;
  GetAllGoodsDs({required this.dio});
  Future<AllGoodsModel> getAllGoods(
      {required String skip, String? productType}) async {
    String url = "goods/?page=$skip&page_size=100000000";

    if (productType != null) {
      url += "&product_type=$productType";
    }

    final Response response = await dio.get(url);
   
    return AllGoodsModel.fromJson(response.data);
    // return allGoodsList
    //     .map((toElement) => AllGoodsModel.fromJson(toElement))
    //     .toList();
  }
}
