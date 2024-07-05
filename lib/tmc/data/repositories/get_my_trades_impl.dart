import 'package:planup/tmc/data/data_source/get_my_trades_ds.dart';
import 'package:planup/tmc/data/models/transfer_good_model.dart';
import 'package:planup/tmc/domain/repository/get_my_trades.dart';

class GetMyTradesImpl implements GetMyTrades{
  GetMyTradesDs dataSource;
  GetMyTradesImpl({required this.dataSource});
  @override
  Future<TransferGoodModel> getMyTrades({required String id})async {
    return await dataSource.getMyTrades(id: id);
  }
  
}