import 'package:planup/tmc/data/models/transfer_good_model.dart';

abstract class GetMyTrades{
  Future<TransferGoodModel> getMyTrades({required String id});
}
 