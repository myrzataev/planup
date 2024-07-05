import 'package:planup/tmc/data/data_source/get_categories_content_ds.dart';
import 'package:planup/tmc/data/models/category_model.dart';
import 'package:planup/tmc/domain/repository/get_categories_content.dart';

class GetCategoriesContentImpl implements GetCategoriesContentRepo {
  GetCategoriesContentDataSource dataSource;
  GetCategoriesContentImpl({required this.dataSource});
  @override
  Future<List<CategoryModel>> getCategoriesContent(
      {required String urlRoute}) async {
    return dataSource.getCategoriesContent(urlRoute: urlRoute);
  }
}
