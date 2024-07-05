import 'package:planup/tmc/data/models/transfer_good_model.dart';

abstract class GetUsersTradeHistory{
  Future<TransferGoodModel> getUsersTradeHistory();
}