
import 'package:planup/tmc/data/data_source/get_all_goods_ds.dart';
import 'package:planup/tmc/data/models/all_goods_model.dart';
import 'package:planup/tmc/domain/repository/get_all_goods.dart';

class GetAllGoodsImpl implements GetAllGoodsRepo {
  GetAllGoodsDs dataSource;
  GetAllGoodsImpl({required this.dataSource});

  @override
  Future<AllGoodsModel> getAllGoods(String skip, String? productType) async {
    return await dataSource.getAllGoods(skip: skip, productType: productType);
  }
}
