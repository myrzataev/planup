import 'package:planup/tmc/data/data_source/get_categories_list_ds.dart';
import 'package:planup/tmc/data/mock_data/card_categories_model.dart';
import 'package:planup/tmc/domain/repository/get_categories_list.dart';

class GetCategoriesListImpl implements GetCategoriesList{
  GetCategoriesListDs dataSource;
  GetCategoriesListImpl({required this.dataSource});
  @override
  Future<List<CategoriesCardModel>> getCategoriesList()async {
    return await dataSource.getCategoriesList();
  }
  
}