import 'package:planup/tmc/data/models/transfer_good_model.dart';

abstract class TransferGoodRepo {
  Future<TransferGoodModel> transferGood(
      {required String sourceUserId,
      required String destinationUserId,
      required String goodID,
      required String tradeStatusId});
}
