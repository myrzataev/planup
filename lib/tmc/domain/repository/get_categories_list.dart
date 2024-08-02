import 'package:planup/tmc/data/mock_data/card_categories_model.dart';

abstract interface class GetCategoriesList{
  Future<List<CategoriesCardModel>> getCategoriesList();
}