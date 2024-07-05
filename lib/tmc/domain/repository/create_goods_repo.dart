import 'package:planup/tmc/data/models/create_goods_model.dart';

abstract class CreateCategoryRepo {
  Future<CreateCategoryModel> createCategory(
      {required String urlRoute,
      required String productManufactureId,
      required String cost,
      required String productModelId});
}
