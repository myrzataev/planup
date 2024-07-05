import 'dart:io';

import 'package:planup/tmc/data/data_source/edit_good_ds.dart';
import 'package:planup/tmc/data/models/all_goods_model.dart';
import 'package:planup/tmc/data/models/single_good_model.dart';
import 'package:planup/tmc/domain/repository/edit_good_repo.dart';

class EditGoodRepoImpl implements EditGoodRepo {
  EditGoodDataSource dataSource;
  EditGoodRepoImpl({required this.dataSource});
  @override
  Future<SingleGoodModel> editGood(
      {required String id,
      required String barcode,
      required String goodStatusId,
      required String productType,
      File? photo,
      required String nazvanieID,
      required String deleted}) async {
    return await dataSource.editGood(
        id: id,
        barcode: barcode,
        goodStatusId: goodStatusId,
        productType: productType,
        nazvanieID: nazvanieID,
        deleted: deleted);
  }
}
