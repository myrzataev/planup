import 'package:planup/tmc/data/models/goods_model.dart';

abstract interface class GetMyGoodsRepo{
  Future<List<MyGoodsModel>> getMyGoods(String? productType);
}