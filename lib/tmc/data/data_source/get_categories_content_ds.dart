import 'package:dio/dio.dart';
import 'package:planup/tmc/data/models/category_model.dart';

class GetCategoriesContentDataSource {
  final Dio dio;
  GetCategoriesContentDataSource({required this.dio});
  Future<List<CategoryModel>> getCategoriesContent(
      {required String urlRoute}) async {
    final Response response = await dio.get(urlRoute);
    List result = response.data;
    // print("runtime type is: ${result.map((toElement)=> toElement.runtimeType)}");
    return result
        .map((toElement) => CategoryModel.fromJson(toElement))
        .toList();
  }
}
