import 'package:planup/tmc/data/data_source/login_ds.dart';
import 'package:planup/tmc/data/models/authorization_model.dart';
import 'package:planup/tmc/domain/repository/login_repo.dart';

class LoginRepoImpl implements LoginRepo {
  LoginDs dataSource;
  LoginRepoImpl({required this.dataSource});
  @override
  Future<AuthorizationModel> login(
      {required String userName, required String password}) async {
    return await dataSource.login(userName: userName, password: password);
  }
}
