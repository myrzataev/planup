import 'package:planup/tmc/data/models/transfer_good_model.dart';

abstract class DenyTradeRepo {
  Future<TransferGoodModel> denyTrade(
      {required String id, required String comment});
}
