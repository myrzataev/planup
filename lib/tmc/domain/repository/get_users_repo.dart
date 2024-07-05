import 'package:planup/tmc/data/models/users_model.dart';

abstract class GetUsersRepo{
  Future<List<UsersModel>> getUsers();
}