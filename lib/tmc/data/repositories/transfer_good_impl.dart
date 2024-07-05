import 'package:planup/tmc/data/data_source/transfer_good_ds.dart';
import 'package:planup/tmc/data/models/transfer_good_model.dart';
import 'package:planup/tmc/domain/repository/transfer_good_repo.dart';

class TransferGoodImpl implements TransferGoodRepo {
  TransferGoodDs dataSource;
  TransferGoodImpl({required this.dataSource});
  @override
  Future<TransferGoodModel> transferGood(
      {required String sourceUserId,
      required String destinationUserId,
      required String goodID,
      required String tradeStatusId}) async {
    return await dataSource.transferGood(
        sourceUserId: sourceUserId,
        destinationUserId: destinationUserId,
        goodID: goodID,
        tradeStatusId: tradeStatusId);
  }
}
