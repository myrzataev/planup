import 'package:planup/tmc/data/models/deleted_goods_model.dart';

abstract class GetDeletedGoodsRepo {
  Future<List<DeletedGoodsModel>> getDeletedGoodsList();
}
