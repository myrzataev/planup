import 'package:planup/tmc/data/data_source/get_users_ds.dart';
import 'package:planup/tmc/data/models/users_model.dart';
import 'package:planup/tmc/domain/repository/get_users_repo.dart';

class GetUsersRepoImpl implements GetUsersRepo {
  GetUsersDataSource dataSource;
  GetUsersRepoImpl({required this.dataSource});
  @override
  Future<List<UsersModel>> getUsers() async {
    return await dataSource.getUsers();
  }
}
