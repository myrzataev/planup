import 'package:planup/tmc/data/data_source/get_my_goods_ds.dart';
import 'package:planup/tmc/data/models/goods_model.dart';
import 'package:planup/tmc/domain/repository/get_my_goods_repo.dart';

class GetMyGoodsImpl implements GetMyGoodsRepo {
  GetMyGoodsDs dataSource;
  GetMyGoodsImpl({required this.dataSource});
  @override
  Future<List<MyGoodsModel>> getMyGoods(String? productType) async {
    return await dataSource.getMyGoods(productType);
  }
}
