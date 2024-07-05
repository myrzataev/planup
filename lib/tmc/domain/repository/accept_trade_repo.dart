import 'package:planup/tmc/data/models/transfer_good_model.dart';

abstract class AcceptTradeRepo {
  Future<TransferGoodModel> acceptTrade({required String id });
}
