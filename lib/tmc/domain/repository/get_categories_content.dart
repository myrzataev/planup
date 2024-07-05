import 'package:planup/tmc/data/models/category_model.dart';

abstract class GetCategoriesContentRepo{
  Future<List<CategoryModel>> getCategoriesContent({required String urlRoute});
}