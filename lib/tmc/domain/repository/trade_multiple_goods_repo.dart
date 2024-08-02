import 'package:planup/tmc/data/models/make_multiple_trade_model.dart';
import 'package:planup/tmc/data/models/multiple_trades_model.dart';

abstract interface class TradeMultipleGoodsRepo {
  Future<List<MultipleTradesModel>> multipleTrade(
      {required MakeMultipleTradeModel model
      //   required String sourceUserId,
      // required String destinationUserId,
      // required String goodId,
      // required String tradeStatus
      });
}
