import 'package:planup/tmc/data/models/authorization_model.dart';

abstract class LoginRepo {
  Future<AuthorizationModel> login(
      {required String userName, required String password});
}
