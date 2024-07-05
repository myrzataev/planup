import 'package:planup/tmc/data/data_source/deny_trade_ds.dart';
import 'package:planup/tmc/data/models/transfer_good_model.dart';
import 'package:planup/tmc/domain/repository/deny_trade_repo.dart';

class DenyTradeImpl implements DenyTradeRepo {
  DenyTradeDs dataSource;
  DenyTradeImpl({required this.dataSource});
  @override
  Future<TransferGoodModel> denyTrade(
      {required String id, required String comment}) async {
    return await dataSource.denyTrade(id: id, comment: comment);
  }
}
