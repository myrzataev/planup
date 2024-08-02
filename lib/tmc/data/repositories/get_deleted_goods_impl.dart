import 'package:planup/tmc/data/data_source/get_deleted_goods_ds.dart';
import 'package:planup/tmc/data/models/deleted_goods_model.dart';
import 'package:planup/tmc/domain/repository/get_deleted_goods_repo.dart';

class GetDeletedGoodsImpl implements GetDeletedGoodsRepo {
  GetDeletedGoodsDs deletedGoodsDs;
  GetDeletedGoodsImpl({required this.deletedGoodsDs});
  @override
  Future<List<DeletedGoodsModel>> getDeletedGoodsList() async {
    return await deletedGoodsDs.getDeletedGoodsList();
  }
}
