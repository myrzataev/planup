import 'package:planup/tmc/data/models/all_goods_model.dart';

abstract class GetAllGoodsRepo{
  Future<AllGoodsModel> getAllGoods(String skip, String? productType);
}