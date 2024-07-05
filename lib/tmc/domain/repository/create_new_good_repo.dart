import 'dart:io';

import 'package:planup/tmc/data/models/single_good_model.dart';

abstract class CreateNewGoodRepo {
  Future<SingleGoodModel> createNewGood(
      {required String id,
      required String barcode,
      required String goodStatusId,
      required String productType,
      File? photo
      });
}
