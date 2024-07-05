import 'package:planup/tmc/data/data_source/delete_goods_ds.dart';
import 'package:planup/tmc/domain/repository/delete_goods.dart';

class DeleteGoodsImpl implements DeleteGoodsRepo {
  DeleteGoodsDs dataSource;
  DeleteGoodsImpl({required this.dataSource});
  @override
  Future<void> deleteGoods({required String id}) async {
    await dataSource.deleteGoods(id: id);
  }
}
