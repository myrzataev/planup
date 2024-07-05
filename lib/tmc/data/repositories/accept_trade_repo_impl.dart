import 'package:planup/tmc/data/data_source/accept_trade_ds.dart';
import 'package:planup/tmc/data/models/transfer_good_model.dart';
import 'package:planup/tmc/domain/repository/accept_trade_repo.dart';

class AcceptTradeRepoImpl implements AcceptTradeRepo {
  AcceptTradeDs dataSource;
  AcceptTradeRepoImpl({required this.dataSource});
  @override
  Future<TransferGoodModel> acceptTrade({required String id}) async {
    return await dataSource.acceptTrade(id: id);
  }
}
