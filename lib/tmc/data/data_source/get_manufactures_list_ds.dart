import 'package:dio/dio.dart';
import 'package:planup/tmc/data/models/manufacture_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetManufacturesListDataSource {
  final Dio dio;
  final SharedPreferences preferences;
  GetManufacturesListDataSource({required this.dio, required this.preferences});
  Future<List<ManufactureModel>> getManufacturesList(
      {required String urlRoute}) async {
    final Response response = await dio.get(urlRoute,
        options: Options(headers: {
          "Authorization": "Bearer ${preferences.getString("bearerToken")}"
        }));
    List responseData = response.data;
    return responseData
        .map((toElement) => ManufactureModel.fromJson(toElement))
        .toList();
  }
}
