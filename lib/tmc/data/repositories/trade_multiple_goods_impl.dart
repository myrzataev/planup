import 'package:planup/tmc/data/data_source/trade_multiple_goods_ds.dart';
import 'package:planup/tmc/data/models/make_multiple_trade_model.dart';
import 'package:planup/tmc/data/models/multiple_trades_model.dart';
import 'package:planup/tmc/domain/repository/trade_multiple_goods_repo.dart';

class TradeMultipleGoodsImpl implements TradeMultipleGoodsRepo {
  TradeMultipleGoodsDs dataSource;
  TradeMultipleGoodsImpl({required this.dataSource});
  @override
  Future<List<MultipleTradesModel>> multipleTrade(
      {
     required   MakeMultipleTradeModel model
      //   required String sourceUserId,
      // required String destinationUserId,
      // required String goodId,
      // required String tradeStatus
      }) async {
    return await dataSource.multipleTrade(model: model);
  }
}
