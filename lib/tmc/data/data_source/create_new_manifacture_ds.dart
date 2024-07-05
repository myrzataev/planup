import 'package:dio/dio.dart';
import 'package:planup/tmc/data/models/manufacture_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateNewManifactureDs {
  final Dio dio;
  final SharedPreferences preferences;
  CreateNewManifactureDs({required this.dio, required
   this.preferences});
  Future<ManufactureModel> createNewManifacture(
      {required String name, required String urlRouteForCategory}) async {
    final Response response = await dio.post("$urlRouteForCategory/", data: {
      "name": name.toString(),
    }, 
    options: Options(headers: {
      "Authorization": "Bearer ${preferences.getString("bearerToken")}"
    })
    );

    return ManufactureModel.fromJson(response.data);
  }
}
