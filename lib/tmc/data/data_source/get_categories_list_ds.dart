import 'package:dio/dio.dart';
import 'package:planup/tmc/data/mock_data/card_categories_model.dart';

class GetCategoriesListDs {
  final Dio dio;
  GetCategoriesListDs({required this.dio});
  Future<List<CategoriesCardModel>> getCategoriesList() async {
    final Response response = await dio.get(
      "goods/products",
    );
    List responseList = response.data;
    return responseList
        .map((toElement) => CategoriesCardModel.fromJson(toElement))
        .toList();
  }
}
