import 'package:dio/dio.dart';
import 'package:planup/tmc/data/models/users_model.dart';

class GetUsersDataSource {
  final Dio dio;
  GetUsersDataSource({required this.dio});
  Future<List<UsersModel>> getUsers() async {
    final Response response = await dio.get("installers");
    List usersList = response.data;
    return usersList
        .map((toElement) => UsersModel.fromJson(toElement))
        .toList();
  }
}
