import 'package:planup/tmc/data/models/transfer_good_model.dart';

abstract class GetTradeHistory {
  Future<List<TransferGoodModel>> getTransferHistoty();
}
