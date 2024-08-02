import 'package:dartz/dartz.dart';
import 'package:planup/tmc/data/models/transfer_good_model.dart';

abstract class TransferGoodRepo {
  Future<Either<String, TransferGoodModel>> transferGood(
      {required String sourceUserId,
      required int destinationUserId,
      required String goodID,
      required String tradeStatusId,
      required String comment
      });
}
