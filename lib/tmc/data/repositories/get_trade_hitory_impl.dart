import 'package:planup/tmc/data/data_source/get_trade_history_ds.dart';
import 'package:planup/tmc/data/models/transfer_good_model.dart';
import 'package:planup/tmc/domain/repository/get_trade_history.dart';

class GetTransactionsHitoryImpl implements GetTradeHistory {
  GetTradeHistoryDs dataSource;
  GetTransactionsHitoryImpl({required this.dataSource});
  @override
  Future<List<TransferGoodModel>> getTransferHistoty() async {
    return await dataSource.getTransfersHistory();
  }
}
