import 'dart:io';

import 'package:planup/tmc/data/models/all_goods_model.dart';
import 'package:planup/tmc/data/models/single_good_model.dart';

abstract class EditGoodRepo {
  Future<SingleGoodModel> editGood({
    required String id,
    required String barcode,
    required String goodStatusId,
    required String productType,
    File? photo,
    required String nazvanieID,
    required String deleted,
  });
}
