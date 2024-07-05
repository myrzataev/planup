import 'package:planup/tmc/data/data_source/get_user_trade_history_ds.dart';
import 'package:planup/tmc/data/models/transfer_good_model.dart';
import 'package:planup/tmc/domain/repository/get_users_trade_history.dart';

class GetUsersTradeHistroryImpl implements GetUsersTradeHistory {
  GetUserTradeHistoryDs dataSource;
  GetUsersTradeHistroryImpl({required this.dataSource});
  @override
  Future<TransferGoodModel> getUsersTradeHistory() async {
    return await dataSource.getUsersTradeHistory();
  }
}
