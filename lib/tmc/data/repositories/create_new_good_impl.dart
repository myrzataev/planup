import 'dart:io';

import 'package:planup/tmc/data/data_source/create_new_good_ds.dart';
import 'package:planup/tmc/data/models/single_good_model.dart';
import 'package:planup/tmc/domain/repository/create_new_good_repo.dart';

class CreateNewGoodImpl implements CreateNewGoodRepo {
  CreateNewGoodDs dataSource;
  CreateNewGoodImpl({required this.dataSource});
  @override
  Future<SingleGoodModel> createNewGood(
      {required String id,
      required String barcode,
      required String goodStatusId,
      required String productType,
      File? photo}) async {
    return await dataSource.createNewGood(
        id: id,
        barcode: barcode,
        goodStatusId: goodStatusId,
        photo: photo,
        productType: productType);
  }
}
