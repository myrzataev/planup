import 'package:dio/dio.dart';
import 'package:planup/tmc/data/models/authorization_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginDs {
  final Dio dio;
  final SharedPreferences preferences;
  LoginDs({required this.dio, required this.preferences});
  Future<AuthorizationModel> login(
      {required String userName, required String password}) async {
    final Response response = await dio.post("login",
        data: {"username": userName, "password": password},
        options: Options(headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        }));
    return AuthorizationModel.fromJson(response.data);
  }
}
