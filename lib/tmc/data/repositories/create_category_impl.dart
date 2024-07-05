import 'package:planup/tmc/data/data_source/create_category_ds.dart';
import 'package:planup/tmc/data/models/create_goods_model.dart';
import 'package:planup/tmc/domain/repository/create_goods_repo.dart';

class CreateCategoryImpl implements CreateCategoryRepo {
  CreateCategoryDs dataSource;
  CreateCategoryImpl({required this.dataSource});

  @override
  Future<CreateCategoryModel> createCategory(
      {required String urlRoute,
      required String productManufactureId,
      required String cost,
      required String productModelId}) async {
    return await dataSource.createCategory(
        urlRoute: urlRoute,
        productManufactureId: productManufactureId,
        cost: cost,
        productModelId: productModelId);
  }
}
